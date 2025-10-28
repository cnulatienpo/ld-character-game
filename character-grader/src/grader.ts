import { analyzeSignals, SignalEvidence } from "./heuristics.js";
import { speak } from "./dialect.js";
import { suggestNextUnlocks } from "./gating.js";
import { GradeInput, GradeOutput, Strength } from "./types.js";

const strengthFromSignals = (
  input: GradeInput,
  signals: ReturnType<typeof analyzeSignals>["report"]
): Strength => {
  const behaviorHit = Boolean(signals[input.behavior as keyof typeof signals]);
  if (signals.field_change && signals.pressure && signals.follow_through && behaviorHit) {
    return "high";
  }
  if (signals.pressure && signals.follow_through && behaviorHit) {
    return "medium";
  }
  if (signals.say || signals.show || signals.hide) {
    return "low";
  }
  return "low";
};

const describeEvidence = (
  key: keyof SignalEvidence,
  evidence: SignalEvidence
): string | null => {
  const items = evidence[key] || [];
  if (!items.length) {
    return null;
  }
  switch (key) {
    case "say":
      return `Intent surfaces through ${items.join(", ")}.`;
    case "show":
      return `Physical beats land via ${items.join(", ")}.`;
    case "hide":
      return `Evasion shows up in ${items.join(", ")}.`;
    case "specificity":
      return `Concrete anchors appear with ${items.join(", ")}.`;
    case "pressure":
      return `Cost language appears around ${items.join(", ")}.`;
    case "follow_through":
      return `Cause and response link through ${items.join(", ")}.`;
    case "field_change":
      return `The field shifts when ${items.join(", ")}.`;
    default:
      return null;
  }
};

const selectManeuvers = (
  behavior: string,
  target: Strength | undefined,
  computed: Strength
): string[] => {
  const focus = target ?? computed;
  const key = behavior.toLowerCase();
  const maneuvers: string[] = [];
  if (key === "say" && focus === "low") {
    maneuvers.push("let another character name the want");
    maneuvers.push("turn a vow into a deadline");
  } else if (key === "show" && (focus === "medium" || focus === "high")) {
    maneuvers.push("use object wear/tear to imply cost");
    maneuvers.push("switch a gesture from small to big");
  } else if (key === "hide" && (focus === "medium" || focus === "high")) {
    maneuvers.push("answer a question with an action");
    maneuvers.push("swap truth for humor then let the humor fail");
  } else {
    maneuvers.push("echo the choice with a textured detail");
    maneuvers.push("let a small reaction hint at the next beat");
  }
  return maneuvers;
};

const buildFeedback = (
  input: GradeInput,
  strength: Strength,
  signals: ReturnType<typeof analyzeSignals>["report"],
  maneuvers: string[],
  nextUnlocks: string[]
): string => {
  const textLength = input.text.trim().length;
  const desiredSentences = Math.min(6, Math.max(2, Math.ceil(textLength / 80)));
  const sentences: string[] = [];
  const behavior = input.behavior.toLowerCase();
  const observedSignals = Object.entries(signals)
    .filter(([, value]) => value === 1)
    .map(([name]) => name)
    .join(", ");

  sentences.push(
    `This moment lands in the ${strength} tier after checking ${observedSignals || "no core"} signals.`
  );

  if (!signals.pressure || !signals.follow_through) {
    sentences.push(
      "Keep tracing the cost and response so the consequence line reads clearly."
    );
  } else if (!signals.field_change) {
    sentences.push("You can still hint at how the room shifts after the move.");
  }

  if (maneuvers.length) {
    sentences.push(
      `Try a maneuver like ${maneuvers
        .slice(0, 2)
        .join(" or ")} to keep pushing this ${behavior} beat.`
    );
  }

  if (nextUnlocks.length) {
    sentences.push(`This run tees up unlocks: ${nextUnlocks.join(", ")}.`);
  }

  while (sentences.length < desiredSentences) {
    sentences.push("Notice how your choice already sets the next move in motion.");
  }

  return sentences.slice(0, desiredSentences).join(" ");
};

export const grade = (input: GradeInput, seeder: ReturnType<typeof JSON.parse>): GradeOutput => {
  const { report, evidence } = analyzeSignals(input.text);
  const score =
    report.say +
    report.show +
    report.hide +
    report.specificity +
    report.pressure +
    report.follow_through +
    report.field_change;

  const strength = strengthFromSignals(input, report);

  const rationaleRaw: string[] = [];
  (Object.keys(report) as (keyof typeof report)[]).forEach((key) => {
    if (report[key] === 1) {
      const line = describeEvidence(key as keyof SignalEvidence, evidence);
      if (line) {
        rationaleRaw.push(line);
      }
    }
  });

  const maneuversRaw = selectManeuvers(input.behavior, input.target_strength, strength);
  const nextUnlocks = suggestNextUnlocks(input, report, seeder as any);

  const feedbackRaw = buildFeedback(input, strength, report, maneuversRaw, nextUnlocks);

  const dialectLevel = input.player.dialect_level;
  const rationale = rationaleRaw.map((line) => speak(line, dialectLevel));
  const maneuvers = maneuversRaw.map((line) => speak(line, dialectLevel));
  const feedback = speak(feedbackRaw, dialectLevel);

  return {
    strength,
    score,
    signals: report,
    rationale,
    feedback,
    maneuvers,
    next_unlocks: nextUnlocks
  };
};
