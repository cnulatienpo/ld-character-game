import { GradeOut } from "./grader-core";

export interface TileLike {
  id: string;
  concept: string;
  requires_vocabulary?: string[];
  kind?: "behavior" | "strength" | "toolkit" | "quiz";
}

export interface UserState {
  currentConcept: string;
  unlockedVocabulary: string[];
  toolkitComplete: Record<string, boolean>;
  quizProgress: Record<string, number>;
  history: { tileId: string; strength: GradeOut["strength"]; }[];
}

function isSubset(requirements:string[] = [], vocab:string[]): boolean {
  const vocabSet = new Set(vocab);
  return requirements.every((word)=>vocabSet.has(word));
}

export function filterByVocabulary<T extends TileLike>(tiles:T[], userVocab:string[]): T[] {
  return tiles.filter((tile)=>isSubset(tile.requires_vocabulary, userVocab));
}

export function chooseNext(
  currentConcept:string,
  lastStrength:GradeOut["strength"],
  options?:{ toolkitCompleted?:boolean; nextQuizIndex?:number }
): string {
  if (lastStrength === "low") {
    return `${currentConcept}_behavior`;
  }
  if (lastStrength === "medium") {
    return `${currentConcept}_strength_high`;
  }
  if (!options?.toolkitCompleted) {
    return `${currentConcept}_toolkit`;
  }
  const quizNumber = (options?.nextQuizIndex ?? 0) + 1;
  return `${currentConcept}_quiz_${quizNumber}`;
}

export function advance(userState:UserState, gradeOut:GradeOut) {
  const vocabulary = new Set(userState.unlockedVocabulary);
  Object.entries(gradeOut.signals).forEach(([signal, value])=>{
    if (value) {
      vocabulary.add(signal);
    }
  });
  const concept = userState.currentConcept;
  const toolkitCompleted = !!userState.toolkitComplete[concept];
  const nextQuizIndex = userState.quizProgress[concept] ?? 0;

  const nextTileId = chooseNext(concept, gradeOut.strength, {
    toolkitCompleted,
    nextQuizIndex
  });

  const updatedState:UserState = {
    ...userState,
    unlockedVocabulary: Array.from(vocabulary),
    history: [...userState.history, { tileId: nextTileId, strength: gradeOut.strength }],
    toolkitComplete: { ...userState.toolkitComplete },
    quizProgress: { ...userState.quizProgress }
  };

  if (gradeOut.strength === "high") {
    if (!toolkitCompleted) {
      updatedState.toolkitComplete[concept] = true;
    } else {
      updatedState.quizProgress[concept] = nextQuizIndex + 1;
    }
  }

  return { nextTileId, updatedUserState: updatedState };
}
