export type Behavior = "say" | "show" | "hide" | string;

export type Strength = "low" | "medium" | "high";

export interface LessonTile {
  id: string;
  concept: string;
  behaviors: Behavior[];
  strength_tiers: Strength[];
  language: {
    dialect_level: 1 | 2 | 3 | 4;
    requires?: string[];
  };
  precedence?: {
    comes_after?: string[];
  };
}

export interface Seeder {
  tiles: LessonTile[];
}

export interface PlayerProfile {
  dialect_level: 1 | 2 | 3 | 4;
  unlocked_signals: string[];
}

export interface GradeInput {
  text: string;
  concept: string;
  behavior: Behavior;
  target_strength?: Strength;
  player: PlayerProfile;
}

export interface SignalReport {
  say: 0 | 1;
  show: 0 | 1;
  hide: 0 | 1;
  specificity: 0 | 1;
  pressure: 0 | 1;
  follow_through: 0 | 1;
  field_change: 0 | 1;
}

export interface GradeOutput {
  strength: Strength;
  score: number;
  signals: SignalReport;
  rationale: string[];
  feedback: string;
  maneuvers: string[];
  next_unlocks: string[];
}
