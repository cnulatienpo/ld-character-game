import fs from "fs";
import path from "path";

interface TropesEntry {
  trope_name?: string;
  name?: string;
  description?: string;
}

interface SeederEntry {
  id: string;
  concept: string;
}

interface ExampleSnippet {
  text: string;
  source: string;
}

function readLines(filePath:string): string[] {
  return fs.readFileSync(filePath, "utf8").split(/\r?\n/).filter(Boolean);
}

function loadTropeEntries(datasetDir:string): TropesEntry[] {
  const primary = path.join(datasetDir, "tvtropes_character_slice.jsonl");
  let fileToRead = primary;
  if (!fs.existsSync(primary)) {
    const fallback = fs.readdirSync(datasetDir).find((file)=>file.startsWith("tvtropes_"));
    if (!fallback) {
      throw new Error("No tvtropes slice available in dataset/");
    }
    fileToRead = path.join(datasetDir, fallback);
  }
  return readLines(fileToRead)
    .map((line)=>{
      try {
        return JSON.parse(line) as TropesEntry;
      } catch {
        return {} as TropesEntry;
      }
    })
    .filter((entry)=>entry && (entry.name || entry.trope_name));
}

function loadSeeds(datasetDir:string): SeederEntry[] {
  const seederPath = path.join(datasetDir, "character_full_master.seeder.json");
  const seeds = JSON.parse(fs.readFileSync(seederPath, "utf8")) as SeederEntry[];
  return seeds;
}

function makeSnippet(entry:TropesEntry, conceptIndex:number): ExampleSnippet {
  const display = entry.name || entry.trope_name || "The character";
  const work = entry.trope_name && entry.trope_name !== entry.name ? entry.trope_name : `${display}'s arc`;
  const lineA = `${display} holds the moment on the threshold, letting the ${work} breathe.`;
  const lineB = `The beat tilts toward ${conceptIndex % 2 === 0 ? "balance" : "risk"}, quiet but steady.`;
  return { text: `${lineA}\n${lineB}`, source: work };
}

function buildExamplesBySeed(datasetDir:string, desiredCount = 12) {
  const entries = loadTropeEntries(datasetDir);
  const seeds = loadSeeds(datasetDir);
  const result: Record<string, ExampleSnippet[]> = {};
  let cursor = 0;
  seeds.forEach((seed, seedIndex)=>{
    const snippets:ExampleSnippet[] = [];
    const used = new Set<string>();
    while (snippets.length < desiredCount && entries.length) {
      const entry = entries[cursor % entries.length];
      cursor += 1;
      const key = `${entry.trope_name || ""}|${entry.name || ""}`;
      if (used.has(key)) {
        continue;
      }
      used.add(key);
      snippets.push(makeSnippet(entry, seedIndex));
    }
    result[seed.id] = snippets;
  });
  return result;
}

function run() {
  const datasetDir = path.join(process.cwd(), "dataset");
  const examples = buildExamplesBySeed(datasetDir);
  const targetPath = path.join(datasetDir, "examples_by_seed.json");
  fs.writeFileSync(targetPath, JSON.stringify(examples, null, 2) + "\n", "utf8");
}

if (require.main === module) {
  run();
}

export { buildExamplesBySeed };
