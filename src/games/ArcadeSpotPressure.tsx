import { useState } from "react";
export interface QuizItem {
  id: string;
  stem: string;
  passage: string;
  choices: { id:string; text:string }[];
  answer: string;
  design_note: string;
  requires_vocabulary: string[];
}
export function ArcadeSpotPressure({ items }:{ items:QuizItem[] }) {
  const [index,setIndex] = useState(0);
  const [selected,setSelected] = useState<string | null>(null);
  const current = items[index];
  const check = (choice:string) => setSelected(choice);
  const next = () => { setSelected(null); setIndex((index+1) % items.length); };
  const correct = selected === current?.answer;
  return current ? (
    <div className="space-y-4 p-4">
      <article className="bg-white border rounded p-4 space-y-3">
        <p className="text-sm text-slate-700 whitespace-pre-wrap">{current.passage}</p>
        <div className="space-y-2">
          <p className="text-sm font-medium text-slate-800">{current.stem}</p>
          {current.choices.map(choice => (
            <button
              key={choice.id}
              onClick={()=>check(choice.id)}
              className={`w-full text-left border rounded px-3 py-2 text-sm ${selected===choice.id ? "bg-slate-900 text-white" : "bg-white"}`}
            >
              {choice.text}
            </button>
          ))}
        </div>
      </article>
      {selected && (
        <div className={`border rounded p-3 text-sm ${correct?"bg-emerald-100 border-emerald-300":"bg-amber-100 border-amber-300"}`}>
          <p className="font-medium text-slate-800">{correct ? "Yes, that’s where the weight sits." : "Not quite; check where the room bends."}</p>
          <p className="text-slate-700 mt-1">{current.design_note}</p>
          <button onClick={next} className="mt-2 text-xs text-indigo-600 hover:underline">Next passage</button>
        </div>
      )}
    </div>
  ) : null;
}
