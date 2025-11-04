import { useMemo, useState } from "react";

interface RangeTuple { start: number; end: number; }

interface ReadingRoomAnswer {
  id: string;
  label: string;
  ranges: RangeTuple[];
}

interface ReadingRoomProps {
  passage: string;
  question: string;
  answers: ReadingRoomAnswer[];
}

interface HighlightSpan extends RangeTuple {
  tone: "selected" | "answer";
}

const DESIGN_NOTE = "This beat shifts the center of gravity; the door latch click is a field change.";

export function ReadingRoom({ passage, question, answers }: ReadingRoomProps) {
  const [selectedRanges, setSelectedRanges] = useState<RangeTuple[]>([]);
  const [choice, setChoice] = useState<string>("");
  const [submitted, setSubmitted] = useState(false);

  const handleSelection = () => {
    if (typeof window === "undefined") return;
    const selection = window.getSelection?.();
    if (!selection || selection.isCollapsed) return;
    const text = selection.toString();
    if (!text) return;
    const start = passage.indexOf(text);
    if (start === -1) return;
    const end = start + text.length;
    setSelectedRanges((prev)=>[...prev, { start, end }]);
  };

  const selectedAnswer = useMemo(() => answers.find((answer)=>answer.id === choice) || null, [answers, choice]);

  const highlightSpans:HighlightSpan[] = useMemo(()=>{
    const spans:HighlightSpan[] = selectedRanges.map((range)=>({ ...range, tone: "selected" }));
    if (submitted && selectedAnswer) {
      selectedAnswer.ranges.forEach((range)=>{
        spans.push({ ...range, tone: "answer" });
      });
    }
    return spans;
  }, [selectedRanges, submitted, selectedAnswer]);

  const renderedPassage = useMemo(()=>renderPassage(passage, highlightSpans), [passage, highlightSpans]);

  return (
    <div className="space-y-4">
      <div
        className="border rounded p-4 bg-white leading-relaxed whitespace-pre-wrap relative"
        onMouseUp={handleSelection}
      >
        {renderedPassage}
      </div>
      <div className="space-y-2">
        <p className="font-semibold text-slate-800">{question}</p>
        <div className="space-y-2">
          {answers.map((answer)=>(
            <button
              key={answer.id}
              className={`block w-full text-left border rounded px-3 py-2 text-sm transition ${choice === answer.id ? "border-indigo-500 bg-indigo-50" : "border-slate-300 bg-white"}`}
              onClick={()=>{
                setChoice(answer.id);
                if (!submitted) {
                  setSubmitted(false);
                }
              }}
            >
              {answer.label}
            </button>
          ))}
        </div>
        <button
          className="bg-slate-900 text-white px-4 py-2 rounded text-sm"
          onClick={()=>setSubmitted(true)}
          disabled={!choice}
        >
          Reveal focus
        </button>
      </div>
      {submitted && (
        <div className="text-sm text-slate-600 border-t pt-3">
          <p className="font-semibold text-slate-700">Design note</p>
          <p>{DESIGN_NOTE}</p>
        </div>
      )}
    </div>
  );
}

function renderPassage(text:string, spans:HighlightSpan[]) {
  if (!spans.length) {
    return text;
  }
  const ordered = [...spans].sort((a,b)=>a.start - b.start);
  const segments:JSX.Element[] = [];
  let cursor = 0;
  ordered.forEach((span, index)=>{
    if (span.start > cursor) {
      segments.push(<span key={`plain-${index}-${cursor}`}>{text.slice(cursor, span.start)}</span>);
    }
    const toneClass = span.tone === "answer" ? "bg-emerald-200/60" : "bg-sky-200/60";
    segments.push(
      <mark key={`hl-${index}-${span.start}`} className={`${toneClass} rounded-sm px-0.5`}>
        {text.slice(span.start, span.end)}
      </mark>
    );
    cursor = span.end;
  });
  if (cursor < text.length) {
    segments.push(<span key={`plain-end-${cursor}`}>{text.slice(cursor)}</span>);
  }
  return segments;
}

let fsModule: typeof import("fs") | null = null;
let pathModule: typeof import("path") | null = null;
if (typeof process !== "undefined" && process.versions?.node) {
  // eslint-disable-next-line @typescript-eslint/no-var-requires
  fsModule = require("fs");
  // eslint-disable-next-line @typescript-eslint/no-var-requires
  pathModule = require("path");
}

export function makeLongPassage(): string {
  if (!fsModule || !pathModule) {
    return "Two paragraphs unfold here.\n\nThe second lingers long enough to test the component.";
  }
  const datasetDir = pathModule.join(process.cwd(), "dataset", "quizzes");
  const files = fsModule.readdirSync(datasetDir).filter((file)=>file.endsWith(".jsonl"));
  const passages:string[] = [];
  for (const file of files.slice(0, 3)) {
    const lines = fsModule.readFileSync(pathModule.join(datasetDir, file), "utf8").split(/\r?\n/).filter(Boolean);
    if (lines.length) {
      try {
        const parsed = JSON.parse(lines[0]);
        if (parsed.passage) {
          passages.push(parsed.passage);
        }
      } catch {
        // ignore malformed lines
      }
    }
  }
  return passages.slice(0, 3).join("\n\n");
}
