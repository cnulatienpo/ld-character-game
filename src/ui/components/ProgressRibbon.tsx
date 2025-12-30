interface ProgressRibbonProps {
  progress: number;
  label?: string;
}
export function ProgressRibbon({ progress, label }:ProgressRibbonProps) {
  const pct = Math.max(0, Math.min(100, Math.round(progress)));
  return (
    <div className="space-y-1">
      {label && <div className="text-xs uppercase tracking-wide text-slate-500">{label}</div>}
      <div className="w-full bg-slate-200 rounded-full h-2">
        <div className="h-2 bg-indigo-500 rounded-full" style={{ width: `${pct}%` }} />
      </div>
      <div className="text-xs text-slate-600">{pct}% ready</div>
    </div>
  );
}
