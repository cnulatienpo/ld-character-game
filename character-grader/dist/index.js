#!/usr/bin/env node
import { runCli } from "./cli.js";
export * from "./types.js";
export { grade } from "./grader.js";

if (import.meta.url === `file://${process.argv[1]}`) {
  runCli();
}
