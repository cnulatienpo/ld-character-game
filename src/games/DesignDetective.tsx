import { useMemo, useState } from "react";

interface DesignDetectiveScene {
  id: string;
  passage: string;
  pushback: "character" | "society" | "nature" | "self";
  stakes: "personal" | "external";
}

interface DesignDetectiveProps {
  scenes?: DesignDetectiveScene[];
}

const PUSHBACK_CHOICES:DesignDetectiveScene["pushback"][] = ["character","society","nature","self"];
const STAKES_CHOICES:DesignDetectiveScene["stakes"][] = ["personal","external"];

const PUSHBACK_NOTES:Record<DesignDetectiveScene["pushback"],string> = {
  character: "Another person stands in the way.",
  society: "Systems or rules apply pressure.",
  nature: "The world or environment resists.",
  self: "The character’s own mind pushes back."
};

const STAKE_NOTES:Record<DesignDetectiveScene["stakes"],string> = {
  personal: "The cost lands squarely on the character.",
  external: "The fallout reaches beyond the character."
};

export function DesignDetective({ scenes }:DesignDetectiveProps) {
  const data = scenes && scenes.length ? scenes : getDesignDetectiveScenes();
  const [index,setIndex] = useState(0);
  const [pushChoice,setPushChoice] = useState<DesignDetectiveScene["pushback"] | "">("");
  const [stakeChoice,setStakeChoice] = useState<DesignDetectiveScene["stakes"] | "">("");
  const scene = data[index % data.length];

  const pushExplanation = useMemo(()=>{
    if (!pushChoice) return "";
    const correct = scene.pushback === pushChoice;
    const suffix = correct ? "(right)" : ` (correct: ${scene.pushback})`;
    return `${PUSHBACK_NOTES[scene.pushback]} ${suffix}`;
  }, [pushChoice, scene]);

  const stakeExplanation = useMemo(()=>{
    if (!stakeChoice) return "";
    const correct = scene.stakes === stakeChoice;
    const suffix = correct ? "(right)" : ` (correct: ${scene.stakes})`;
    return `${STAKE_NOTES[scene.stakes]} ${suffix}`;
  }, [stakeChoice, scene]);

  const nextScene = () => {
    setIndex((prev)=>prev + 1);
    setPushChoice("");
    setStakeChoice("");
  };

  return (
    <div className="space-y-4">
      <div className="border rounded p-4 bg-white whitespace-pre-wrap leading-relaxed">
        {scene.passage}
      </div>
      <div className="space-y-3">
        <section className="space-y-2">
          <p className="font-semibold text-slate-800">What’s pushing back?</p>
          <div className="flex flex-wrap gap-2">
            {PUSHBACK_CHOICES.map((option)=>(
              <button
                key={option}
                className={`px-3 py-1 text-sm rounded border ${pushChoice === option ? "border-indigo-500 bg-indigo-50" : "border-slate-300 bg-white"}`}
                onClick={()=>setPushChoice(option)}
              >
                {option}
              </button>
            ))}
          </div>
          {pushChoice && <p className="text-xs text-slate-600">{pushExplanation}</p>}
        </section>
        <section className="space-y-2">
          <p className="font-semibold text-slate-800">Which stakes rise?</p>
          <div className="flex flex-wrap gap-2">
            {STAKES_CHOICES.map((option)=>(
              <button
                key={option}
                className={`px-3 py-1 text-sm rounded border ${stakeChoice === option ? "border-indigo-500 bg-indigo-50" : "border-slate-300 bg-white"}`}
                onClick={()=>setStakeChoice(option)}
              >
                {option}
              </button>
            ))}
          </div>
          {stakeChoice && <p className="text-xs text-slate-600">{stakeExplanation}</p>}
        </section>
        <button className="bg-slate-900 text-white px-4 py-2 rounded text-sm" onClick={nextScene}>
          Next scene
        </button>
      </div>
    </div>
  );
}

let fsModule: typeof import("fs") | null = null;
let pathModule: typeof import("path") | null = null;
if (typeof process !== "undefined" && process.versions?.node) {
  // eslint-disable-next-line @typescript-eslint/no-var-requires
  fsModule = require("fs");
  // eslint-disable-next-line @typescript-eslint/no-var-requires
  pathModule = require("path");
}

export function getDesignDetectiveScenes(): DesignDetectiveScene[] {
  if (!fsModule || !pathModule) {
    return [
      {
        id: "demo",
        passage: "A placeholder hallway waits.\n\nTwo figures face each other, testing the tension.",
        pushback: "character",
        stakes: "personal"
      }
    ];
  }
  const filePath = pathModule.join(process.cwd(), "dataset", "quizzes", "friction_check.jsonl");
  const lines = fsModule.readFileSync(filePath, "utf8").split(/\r?\n/).filter(Boolean);
  const scenes:DesignDetectiveScene[] = [];
  lines.forEach((line, index)=>{
    try {
      const parsed = JSON.parse(line) as { id:string; passage:string; };
      const pushback = PUSHBACK_CHOICES[index % PUSHBACK_CHOICES.length];
      const stakes = STAKES_CHOICES[index % STAKES_CHOICES.length];
      scenes.push({ id: parsed.id, passage: parsed.passage, pushback, stakes });
    } catch {
      // ignore malformed lines
    }
  });
  return scenes;
}
