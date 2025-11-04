import { useState } from "react";
import { DesignTranslationBox } from "../components/DesignTranslationBox";
import { IntentControls, IntentOption } from "../components/IntentControls";
import { ExampleRotator } from "../components/ExampleRotator";
import { FeedbackCard } from "../components/FeedbackCard";
import { ProgressRibbon } from "../components/ProgressRibbon";
import { grade } from "../../engine/grader-core";

const DEFAULT_INTENTS:IntentOption[] = [
  { id: "show", label: "Show the signal", description: "Let the room carry the idea." },
  { id: "say", label: "Say the cost", description: "Name the weight once, cleanly." },
  { id: "hide", label: "Hide in plain view", description: "Cover the risk while hinting at it." }
];

export function LessonView({ seed }:{ seed:{ original_text:string; design_translation:string; examples:string[]; concept:string; prompt:string; requires_vocabulary:string[]; } }) {
  const [intent,setIntent] = useState<string>(DEFAULT_INTENTS[0].id);
  const [draft,setDraft] = useState("\n\n");
  const [feedback,setFeedback] = useState<ReturnType<typeof grade> | null>(null);

  const runGrade = () => {
    const result = grade({
      text: draft,
      concept: seed.concept,
      behavior: intent,
      dialectLevel: 1,
      unlockedSignals: seed.requires_vocabulary
    });
    setFeedback(result);
  };

  return (
    <div className="max-w-3xl mx-auto space-y-6 p-4">
      <div className="space-y-3">
        <p className="text-base text-slate-800 whitespace-pre-wrap">{seed.original_text}</p>
        <DesignTranslationBox text={seed.design_translation} />
        <ExampleRotator examples={seed.examples} />
      </div>
      <div className="space-y-2">
        <p className="text-sm text-slate-700">{seed.prompt}</p>
        <textarea
          className="w-full border rounded p-3 text-sm min-h-[160px]"
          value={draft}
          onChange={(e)=>setDraft(e.target.value)}
          placeholder="Write your attempt here."
        />
      </div>
      <div className="space-y-4">
        <IntentControls options={DEFAULT_INTENTS} onSelect={setIntent} />
        <button onClick={runGrade} className="bg-slate-900 text-white px-4 py-2 rounded text-sm">Check my writing</button>
        <ProgressRibbon progress={feedback ? Math.min(100, feedback.score * 10) : 0} label="Signals" />
      </div>
      {feedback && <FeedbackCard summary={feedback.summary} maneuvers={feedback.maneuvers} strength={feedback.strength} />}
    </div>
  );
}
