interface FeedbackCardProps {
  summary: string;
  maneuvers: string[];
  strength: "low"|"medium"|"high";
}
export function FeedbackCard({ summary, maneuvers, strength }:FeedbackCardProps) {
  const tone = strength === "high" ? "bg-emerald-100 border-emerald-300" : strength === "medium" ? "bg-amber-100 border-amber-300" : "bg-rose-100 border-rose-300";
  return (
    <section className={`border ${tone} rounded p-4 space-y-2 text-sm`}>
      <header className="font-semibold text-slate-800">Feedback</header>
      <p className="text-slate-700 whitespace-pre-wrap">{summary}</p>
      <ul className="list-disc list-inside text-slate-700">
        {maneuvers.map((line,idx)=>(<li key={idx}>{line}</li>))}
      </ul>
    </section>
  );
}
