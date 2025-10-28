#!/usr/bin/env node
import { runCli } from "./cli.js";
import { grade } from "./grader.js";
export * from "./types.js";
export { grade } from "./grader.js";

if (import.meta.url === `file://${process.argv[1]}`) {
  runCli();
}
