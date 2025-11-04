import { useState } from "react";
export interface IntentOption {
  id: string;
  label: string;
  description?: string;
}
export function IntentControls({ options, onSelect }:{ options:IntentOption[]; onSelect:(id:string)=>void }) {
  const [active,setActive] = useState<string | null>(null);
  return (
    <div className="space-y-2">
      {options.map(opt => (
        <button
          key={opt.id}
          onClick={() => { setActive(opt.id); onSelect(opt.id); }}
          className={`w-full text-left border rounded px-3 py-2 text-sm transition ${active===opt.id ? "bg-slate-800 text-white" : "bg-white hover:bg-slate-100"}`}
        >
          <div className="font-medium">{opt.label}</div>
          {opt.description && <p className="text-xs text-slate-600">{opt.description}</p>}
        </button>
      ))}
    </div>
  );
}
