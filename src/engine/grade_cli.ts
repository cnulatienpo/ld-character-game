import { grade, GradeOut } from "./grader-core";

export function gradeLocal(text:string, intent:string, concept?:string, unlockedSignals:string[] = []): GradeOut {
  const effectiveConcept = concept || intent;
  return grade({
    text,
    concept: effectiveConcept,
    behavior: intent,
    dialectLevel: 1,
    unlockedSignals
  });
}
