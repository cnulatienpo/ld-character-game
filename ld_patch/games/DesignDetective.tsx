interface Clue {
  id: string;
  text: string;
  signal: string;
}
export function DesignDetective({ clues, onReveal }:{ clues:Clue[]; onReveal:(signal:string)=>void }) {
  return (
    <div className="space-y-3 p-4">
      <p className="text-sm text-slate-700">Trace how the scene holds together. Tap a clue when you can name the signal it points to.</p>
      <ul className="space-y-2">
        {clues.map(clue => (
          <li key={clue.id} className="border rounded p-3 bg-white text-sm flex justify-between items-center">
            <span className="text-slate-700">{clue.text}</span>
            <button className="text-xs text-indigo-600 hover:underline" onClick={()=>onReveal(clue.signal)}>Mark signal</button>
          </li>
        ))}
      </ul>
    </div>
  );
}
