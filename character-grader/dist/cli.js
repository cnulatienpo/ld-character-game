import fs from "fs";
import path from "path";
import { grade } from "./grader.js";

const parseArgs = (argv) => {
  const options = {};
  for (let i = 0; i < argv.length; i++) {
    const arg = argv[i];
    if (!arg.startsWith("--")) continue;
    const key = arg.slice(2);
    const value = argv[i + 1];
    if (value && !value.startsWith("--")) {
      options[key] = value;
      i++;
    } else {
      options[key] = "true";
    }
  }
  return options;
};

const loadSeeder = (filepath) => {
  const resolved = path.resolve(filepath);
  const raw = fs.readFileSync(resolved, "utf-8");
  return JSON.parse(raw);
};

const loadPlayerProfile = (filepath) => {
  if (!filepath) {
    return { dialect_level: 1, unlocked_signals: [] };
  }
  const resolved = path.resolve(filepath);
  const raw = fs.readFileSync(resolved, "utf-8");
  const data = JSON.parse(raw);
  return {
    dialect_level: Math.min(4, Math.max(1, data.dialect_level ?? 1)),
    unlocked_signals: Array.isArray(data.unlocked_signals)
      ? data.unlocked_signals
      : []
  };
};

const printSummary = (result) => {
  console.log("\n=== Character Grade Summary ===");
  console.log(`Strength: ${result.strength}`);
  console.log(`Score: ${result.score}`);
  console.log(`Signals: ${JSON.stringify(result.signals)}`);
  console.log(`Feedback: ${result.feedback}`);
  if (result.next_unlocks.length) {
    console.log(`Next unlocks: ${result.next_unlocks.join(", ")}`);
  }
};

export const runCli = () => {
  const args = parseArgs(process.argv.slice(2));
  if (!args.seeder) {
    console.error("Missing --seeder path");
    process.exit(1);
  }
  if (!args.concept || !args.behavior) {
    console.error("Missing --concept or --behavior");
    process.exit(1);
  }

  const text = args.text ?? "";
  if (!text.trim()) {
    console.error("Missing --text input");
    process.exit(1);
  }

  const seeder = loadSeeder(args.seeder);
  const player = loadPlayerProfile(args.unlocked);
  if (args.dialect) {
    player.dialect_level = Math.min(4, Math.max(1, Number(args.dialect)));
  }

  const input = {
    text,
    concept: args.concept,
    behavior: args.behavior,
    target_strength: args.target,
    player
  };

  const result = grade(input, seeder);

  console.log(JSON.stringify(result, null, 2));
  printSummary(result);
};
