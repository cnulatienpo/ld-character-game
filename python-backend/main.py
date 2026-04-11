from __future__ import annotations

import json
from pathlib import Path
from typing import Any

import numpy as np
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from sentence_transformers import SentenceTransformer

DEFAULT_LABELS_PATH = Path(__file__).resolve().parent / "labels.json"
EMBED_MODEL_NAME = "all-MiniLM-L6-v2"
TOP_K = 8
SIGNAL_THRESHOLD = 0.40
MISCONCEPTION_THRESHOLD = 0.45


class AnalyzeRequest(BaseModel):
    text: str = Field(..., min_length=1)
    concept_id: str = Field(..., min_length=1)


class RAGAnalyzer:
    def __init__(self, labels_path: Path, model_name: str = EMBED_MODEL_NAME) -> None:
        self.labels_path = labels_path
        self.model = SentenceTransformer(model_name)
        self.rows: list[dict[str, Any]] = []
        self.signals_by_concept: dict[str, list[dict[str, Any]]] = {}
        self.misconceptions_by_concept: dict[str, list[dict[str, Any]]] = {}
        self.corpus_rows: list[dict[str, Any]] = []
        self.corpus_embeddings: np.ndarray = np.zeros((0, 0), dtype=np.float32)

        self._load_labels()
        self._build_indexes()
        self._build_embedding_corpus()

    def _load_labels(self) -> None:
        if not self.labels_path.exists():
            raise FileNotFoundError(f"labels file not found: {self.labels_path}")

        with self.labels_path.open("r", encoding="utf-8") as f:
            data = json.load(f)

        if not isinstance(data, list):
            raise ValueError("labels.json must contain a top-level array")

        self.rows = [row for row in data if isinstance(row, dict)]

    def _build_indexes(self) -> None:
        self.signals_by_concept = {}
        self.misconceptions_by_concept = {}

        for row in self.rows:
            concept_id = row.get("concept_id")
            if not concept_id:
                continue

            if row.get("signal_id"):
                self.signals_by_concept.setdefault(concept_id, []).append(row)

            if row.get("misconception_id"):
                self.misconceptions_by_concept.setdefault(concept_id, []).append(row)

    @staticmethod
    def _row_to_corpus_text(row: dict[str, Any]) -> str:
        parts = [
            str(row.get("detection_hint", "")).strip(),
            str(row.get("description", "")).strip(),
            str(row.get("minimal_example", "")).strip(),
            str(row.get("tells", "")).strip(),
        ]
        return " ".join([p for p in parts if p])

    def _build_embedding_corpus(self) -> None:
        corpus_rows: list[dict[str, Any]] = []
        corpus_texts: list[str] = []

        for row in self.rows:
            concept_id = row.get("concept_id")
            if not concept_id:
                continue

            has_signal = bool(row.get("signal_id"))
            has_misconception = bool(row.get("misconception_id"))
            if not has_signal and not has_misconception:
                continue

            text = self._row_to_corpus_text(row)
            if not text:
                continue

            corpus_rows.append(row)
            corpus_texts.append(text)

        self.corpus_rows = corpus_rows

        if not corpus_texts:
            self.corpus_embeddings = np.zeros((0, 384), dtype=np.float32)
            return

        embeddings = self.model.encode(
            corpus_texts,
            convert_to_numpy=True,
            normalize_embeddings=True,
            show_progress_bar=False,
        )
        self.corpus_embeddings = embeddings.astype(np.float32)

    @staticmethod
    def _cosine_scores(query_embedding: np.ndarray, matrix: np.ndarray) -> np.ndarray:
        if matrix.size == 0:
            return np.zeros((0,), dtype=np.float32)
        return np.dot(matrix, query_embedding)

    def retrieve_relevant(self, text: str, concept_id: str, top_k: int = TOP_K) -> list[dict[str, Any]]:
        if self.corpus_embeddings.size == 0:
            return []

        query_embedding = self.model.encode(
            text,
            convert_to_numpy=True,
            normalize_embeddings=True,
            show_progress_bar=False,
        ).astype(np.float32)

        scores = self._cosine_scores(query_embedding, self.corpus_embeddings)

        ranked = np.argsort(-scores)
        results: list[dict[str, Any]] = []

        for idx in ranked:
            row = self.corpus_rows[int(idx)]
            if row.get("concept_id") != concept_id:
                continue

            results.append(
                {
                    "row": row,
                    "similarity": float(scores[int(idx)]),
                }
            )

            if len(results) >= top_k:
                break

        return results

    def _detect_signals(
        self, retrieved: list[dict[str, Any]], concept_id: str
    ) -> tuple[list[str], list[str]]:
        matched_signal_ids: set[str] = set()

        for item in retrieved:
            row = item["row"]
            similarity = item["similarity"]
            signal_id = row.get("signal_id")
            if signal_id and similarity >= SIGNAL_THRESHOLD:
                matched_signal_ids.add(str(signal_id))

        all_signals = self.signals_by_concept.get(concept_id, [])
        all_signal_ids = {str(row.get("signal_id")) for row in all_signals if row.get("signal_id")}

        matched = sorted(matched_signal_ids)
        missing = sorted([sid for sid in all_signal_ids if sid not in matched_signal_ids])

        return matched, missing

    def _detect_misconceptions(self, retrieved: list[dict[str, Any]]) -> list[dict[str, str]]:
        by_id: dict[str, dict[str, str]] = {}

        for item in retrieved:
            row = item["row"]
            similarity = item["similarity"]
            misconception_id = row.get("misconception_id")
            if not misconception_id or similarity < MISCONCEPTION_THRESHOLD:
                continue

            key = str(misconception_id)
            if key in by_id:
                continue

            by_id[key] = {
                "id": key,
                "tells": str(row.get("tells", "")).strip(),
                "feedback": str(row.get("corrective_feedback", "")).strip(),
            }

        return list(by_id.values())

    @staticmethod
    def _synthesize_feedback(
        concept_id: str,
        missing_signals: list[str],
        misconceptions: list[dict[str, str]],
    ) -> str:
        lines: list[str] = []

        if missing_signals:
            lines.append("You're missing key signals: " + ", ".join(missing_signals) + ".")

        if misconceptions:
            corrections = [m["feedback"] for m in misconceptions if m.get("feedback")]
            if corrections:
                lines.append(" ".join(corrections))

        if not lines:
            lines.append(f"This shows clear use of {concept_id}. Push it further.")

        return " ".join(lines)

    def analyze(self, text: str, concept_id: str) -> dict[str, Any]:
        retrieved = self.retrieve_relevant(text=text, concept_id=concept_id, top_k=TOP_K)
        matched_signals, missing_signals = self._detect_signals(retrieved, concept_id)
        misconceptions = self._detect_misconceptions(retrieved)
        feedback = self._synthesize_feedback(concept_id, missing_signals, misconceptions)

        return {
            "matched_signals": matched_signals,
            "missing_signals": missing_signals,
            "misconceptions": misconceptions,
            "feedback": feedback,
        }


app = FastAPI(title="Local Writing RAG Server")
analyzer: RAGAnalyzer | None = None


@app.on_event("startup")
def _startup() -> None:
    global analyzer
    analyzer = RAGAnalyzer(labels_path=DEFAULT_LABELS_PATH)


@app.get("/healthz")
def healthz() -> dict[str, bool]:
    return {"ok": True}


@app.post("/analyze")
def analyze(payload: AnalyzeRequest) -> dict[str, Any]:
    if analyzer is None:
        raise HTTPException(status_code=503, detail="analyzer unavailable")

    return analyzer.analyze(text=payload.text, concept_id=payload.concept_id)
