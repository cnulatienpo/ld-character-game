interface ReadingRoomProps {
  passage: string;
  highlights?: { start:number; end:number; label:string }[];
  onHighlight?: (start:number,end:number)=>void;
}
export function ReadingRoom({ passage, highlights = [], onHighlight }:ReadingRoomProps) {
  return (
    <section className="space-y-3 p-4">
      <p className="text-sm text-slate-700">Glide through the excerpt. Mark where the design signal alters the space.</p>
      <pre className="whitespace-pre-wrap text-sm bg-white border rounded p-4 text-slate-800">{passage}</pre>
      {highlights.length > 0 && (
        <ul className="text-xs text-slate-600 space-y-1">
          {highlights.map((h,idx)=>(
            <li key={idx}>[{h.start}–{h.end}] {h.label}</li>
          ))}
        </ul>
      )}
      {onHighlight && <button className="text-xs text-indigo-600 hover:underline" onClick={()=>onHighlight(0,0)}>Add highlight</button>}
    </section>
  );
}
