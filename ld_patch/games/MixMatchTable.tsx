interface MixMatchTableProps {
  prompts: { id:string; cue:string; response:string }[];
  onPair: (id:string)=>void;
}
export function MixMatchTable({ prompts, onPair }:MixMatchTableProps) {
  return (
    <div className="p-4 space-y-3">
      <p className="text-sm text-slate-700">Match the cue to the response that keeps the design weight steady.</p>
      <div className="grid gap-2 md:grid-cols-2">
        {prompts.map(item => (
          <button
            key={item.id}
            onClick={()=>onPair(item.id)}
            className="border rounded px-3 py-2 text-sm text-left bg-white hover:bg-slate-100"
          >
            <div className="font-medium text-slate-800">{item.cue}</div>
            <div className="text-xs text-slate-600">{item.response}</div>
          </button>
        ))}
      </div>
    </div>
  );
}
