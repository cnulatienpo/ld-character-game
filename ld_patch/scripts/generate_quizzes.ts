import fs from "fs";
import path from "path";
import crypto from "crypto";

interface TropesEntry {
  trope_name?: string;
  name?: string;
  description?: string;
}

interface Choice { id: string; text: string; }

interface QuizItem {
  id: string;
  stem: string;
  concept: string;
  passage: string;
  choices: Choice[];
  answer: string;
  design_note: string;
  requires_vocabulary: string[];
}

const QUIZ_FILES = [
  "spot_the_pressure.jsonl",
  "tilt_the_room.jsonl",
  "say_show_hide.jsonl",
  "pattern_and_break.jsonl",
  "friction_check.jsonl",
  "outcome_dial.jsonl"
];

const CONCEPTS = ["Description","Presence","Identity","Conflict","Stakes","Outcome"] as const;
type Concept = typeof CONCEPTS[number];

const VOCABULARY: Record<Concept, string[]> = {
  Description: ["texture","balance","detail"],
  Presence: ["field","pressure","attention"],
  Identity: ["pattern","contradiction","signal"],
  Conflict: ["force","pushback","motion"],
  Stakes: ["cost","risk","weight"],
  Outcome: ["landing","equilibrium","change"]
};

const STEMS: Record<Concept,string> = {
  Description: "Which line pins the physical detail?",
  Presence: "Where does the room shift?",
  Identity: "Which beat reveals the persona?",
  Conflict: "What force pushes back here?",
  Stakes: "Where do the stakes rise?",
  Outcome: "Which moment lands the change?"
};

const NOTES: Record<Concept,string> = {
  Description: "Detail in motion lets the reader feel the weight and balance.",
  Presence: "Small field changes make the room tilt toward intention.",
  Identity: "Patterns and contradiction keep a persona legible.",
  Conflict: "Opposition must be felt through contact, not summary.",
  Stakes: "Name or imply the cost so the risk sits in the open.",
  Outcome: "Let the last beat land like a new equilibrium."
};

function readTropeEntries(datasetDir:string): TropesEntry[] {
  const primary = path.join(datasetDir, "tvtropes_character_slice.jsonl");
  let fileToRead = primary;
  if (!fs.existsSync(fileToRead)) {
    const fallback = fs.readdirSync(datasetDir).find((name)=>name.startsWith("tvtropes_"));
    if (!fallback) {
      throw new Error("Unable to locate a tvtropes slice in dataset/");
    }
    fileToRead = path.join(datasetDir, fallback);
  }
  const data = fs.readFileSync(fileToRead,"utf8");
  return data
    .split(/\r?\n/)
    .map((line)=>line.trim())
    .filter(Boolean)
    .map((line)=>{
      try {
        return JSON.parse(line) as TropesEntry;
      } catch {
        return {} as TropesEntry;
      }
    })
    .filter((entry)=>entry && (entry.name || entry.trope_name));
}

function buildPassage(entry:TropesEntry, concept:Concept, index:number): string {
  const name = entry.name || entry.trope_name || `Figure ${index}`;
  const trope = entry.trope_name && entry.trope_name !== entry.name ? entry.trope_name : `${name}'s story`;
  const first = `${name} studies the ${concept.toLowerCase()} in the hall, fingers grazing the frame where the paint has worn.`;
  const second = `In ${trope}, a small motion reroutes the moment; the air carries a hint of what shifts next.`;
  return `${first}\n\n${second}`;
}

function makeChoices(concept:Concept): Choice[] {
  const vocab = VOCABULARY[concept];
  return [
    { id: "a", text: `In the throwaway description of the weather.` },
    { id: "b", text: `In the line that leans on ${vocab[0]}.` },
    { id: "c", text: `In a detail about background noise only.` },
    { id: "d", text: `Nowhere; it stays abstract.` }
  ];
}

function answerId(): string {
  return "b";
}

function hashPassage(text:string): string {
  const normalized = text.replace(/\s+/g," ").trim().toLowerCase();
  return crypto.createHash("sha1").update(normalized).digest("hex");
}

function generateQuizItems(entries:TropesEntry[], limit:number, fileIndex:number): QuizItem[] {
  const items:QuizItem[] = [];
  const usedNames = new Set<string>();
  const seenPassages = new Set<string>();
  let globalIndex = 0;
  const perConcept = Math.floor(limit / CONCEPTS.length);
  CONCEPTS.forEach(()=>{});
  for (const concept of CONCEPTS) {
    let created = 0;
    while (created < perConcept && globalIndex < entries.length) {
      const entry = entries[globalIndex++ % entries.length];
      const key = `${entry.name || ""}|${entry.trope_name || ""}`;
      if (usedNames.has(key)) {
        continue;
      }
      const passage = buildPassage(entry, concept, items.length + 1);
      const passageHash = hashPassage(passage);
      if (seenPassages.has(passageHash)) {
        continue;
      }
      usedNames.add(key);
      seenPassages.add(passageHash);
      const id = `${QUIZ_FILES[fileIndex].split(".")[0]}-${String(items.length + 1).padStart(3,"0")}`;
      items.push({
        id,
        stem: STEMS[concept],
        concept,
        passage,
        choices: makeChoices(concept),
        answer: answerId(),
        design_note: NOTES[concept],
        requires_vocabulary: VOCABULARY[concept]
      });
      created += 1;
    }
  }
  return items.slice(0, limit);
}

function writeQuizFile(datasetDir:string, filename:string, items:QuizItem[]) {
  const targetDir = path.join(datasetDir, "quizzes");
  if (!fs.existsSync(targetDir)) {
    fs.mkdirSync(targetDir, { recursive: true });
  }
  const content = items.map((item)=>JSON.stringify(item)).join("\n") + "\n";
  fs.writeFileSync(path.join(targetDir, filename), content, "utf8");
}

function run(limitArg?:string) {
  const limit = limitArg ? Number(limitArg) : 60;
  const datasetDir = path.join(process.cwd(), "dataset");
  const entries = readTropeEntries(datasetDir);
  if (!entries.length) {
    throw new Error("No entries available to generate quizzes.");
  }
  QUIZ_FILES.forEach((filename, index)=>{
    const items = generateQuizItems(entries, limit, index);
    writeQuizFile(datasetDir, filename, items);
  });
}

if (require.main === module) {
  const limitFlagIndex = process.argv.indexOf("--limit");
  const limitValue = limitFlagIndex >= 0 ? process.argv[limitFlagIndex + 1] : undefined;
  run(limitValue);
}

export { generateQuizItems, readTropeEntries };
