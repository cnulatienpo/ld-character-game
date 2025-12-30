import { useState } from "react";
export function DesignTranslationBox({ text }:{ text:string }) {
  const [open,setOpen] = useState(true);
  return (
    <aside className="border rounded bg-neutral-50">
      <button className="w-full text-left px-3 py-2 border-b text-sm" onClick={()=>setOpen(v=>!v)}>
        {open ? "Hide design translation" : "Show design translation"}
      </button>
      {open && <div className="p-3 text-sm whitespace-pre-wrap">{text}</div>}
    </aside>
  );
}
