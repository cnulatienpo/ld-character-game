import { useMemo, useState } from "react";

interface MixMatchExample {
  id: string;
  text: string;
  explanation: string;
}

interface MixMatchPair {
  token: string;
  example: MixMatchExample;
}

interface MixMatchRound {
  id: string;
  pairs: MixMatchPair[];
}

interface MixMatchTableProps {
  round?: MixMatchRound;
}

const TOKENS = ["balance","rhythm","tension","contrast","flow"];

export function MixMatchTable({ round }:MixMatchTableProps) {
  const activeRound = round || getMixMatchRound();
  const [assignments,setAssignments] = useState<Record<string,string>>({});
  const [submitted,setSubmitted] = useState(false);
  const trueMap = useMemo(()=>{
    const map:Record<string,string> = {};
    activeRound.pairs.forEach((pair)=>{ map[pair.example.id] = pair.token; });
    return map;
  }, [activeRound]);

  const handleDrop = (exampleId:string, token?:string) => {
    if (!token) return;
    setAssignments((prev)=>({ ...prev, [exampleId]: token }));
  };

  const renderToken = (token:string) => (
    <div
      key={token}
      className="border rounded px-3 py-2 text-sm bg-slate-50 shadow-sm cursor-grab"
      draggable
      onDragStart={(event)=>{
        event.dataTransfer?.setData("text/plain", token);
      }}
    >
      {token}
    </div>
  );

  return (
    <div className="grid md:grid-cols-2 gap-6">
      <div className="space-y-3">
        <p className="text-xs uppercase tracking-wide text-slate-500">Tokens</p>
        <div className="grid grid-cols-1 gap-2">
          {TOKENS.map(renderToken)}
        </div>
      </div>
      <div className="space-y-3">
        <p className="text-xs uppercase tracking-wide text-slate-500">Examples</p>
        <div className="space-y-3">
          {activeRound.pairs.map((pair)=>{
            const assigned = assignments[pair.example.id];
            const correct = submitted ? trueMap[pair.example.id] === assigned : null;
            return (
              <div
                key={pair.example.id}
                className={`border rounded p-3 bg-white space-y-2 ${submitted ? (correct ? "border-emerald-500" : "border-rose-400") : "border-slate-300"}`}
                onDragOver={(event)=>event.preventDefault()}
                onDrop={(event)=>{
                  event.preventDefault();
                  const token = event.dataTransfer?.getData("text/plain") || "";
                  handleDrop(pair.example.id, token);
                }}
              >
                <p className="text-sm text-slate-800 whitespace-pre-line">{pair.example.text}</p>
                <div className="text-xs text-slate-500 flex items-center justify-between">
                  <span>Assigned: {assigned || "—"}</span>
                  {submitted && <span>True: {trueMap[pair.example.id]}</span>}
                </div>
                {submitted && (
                  <p className="text-xs text-slate-600">{pair.example.explanation}</p>
                )}
              </div>
            );
          })}
        </div>
        <button
          className="bg-slate-900 text-white px-4 py-2 rounded text-sm"
          onClick={()=>setSubmitted(true)}
          disabled={Object.keys(assignments).length < activeRound.pairs.length}
        >
          Check pairs
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

export function getMixMatchRound(): MixMatchRound {
  if (!fsModule || !pathModule) {
    return {
      id: "demo",
      pairs: TOKENS.map((token, index)=>({
        token,
        example: {
          id: `demo-${token}`,
          text: `Placeholder example ${index + 1} for ${token}.`,
          explanation: "Real data loads in a Node environment."
        }
      }))
    };
  }
  const datasetPath = pathModule.join(process.cwd(), "dataset", "match_items.json");
  if (!fsModule.existsSync(datasetPath)) {
    return {
      id: "fallback",
      pairs: TOKENS.map((token, index)=>({
        token,
        example: {
          id: `fallback-${token}`,
          text: `Pair ${index + 1} keeps the player focused on ${token}.`,
          explanation: "Dataset missing; using inline fallback."
        }
      }))
    };
  }
  const raw = fsModule.readFileSync(datasetPath, "utf8");
  const parsed = JSON.parse(raw) as { rounds: MixMatchRound[] };
  return parsed.rounds[0];
}
