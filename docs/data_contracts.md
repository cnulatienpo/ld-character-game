Seeder: { id, concept, original_text, design_translation, examples[], prompt, requires_vocabulary[] }
Quiz item (MCQ): { id, stem, passage, choices[], answer, design_note, requires_vocabulary[] }
Grader I/O: grade({ text, concept, behavior?, targetStrength?, dialectLevel, unlockedSignals[] }) -> { strength, score, signals, summary, maneuvers, nextHint? }
