import { useState } from "react";
export function ExampleRotator({ examples }:{ examples:string[] }) {
  const [index,setIndex] = useState(0);
  if (!examples.length) return null;
  const next = () => setIndex((index+1)%examples.length);
  return (
    <div className="border rounded p-3 bg-white space-y-2">
      <div className="text-xs uppercase tracking-wide text-slate-500">Example</div>
      <p className="text-sm text-slate-700">{examples[index]}</p>
      <button onClick={next} className="text-xs text-indigo-600 hover:underline">See another</button>
    </div>
  );
}
