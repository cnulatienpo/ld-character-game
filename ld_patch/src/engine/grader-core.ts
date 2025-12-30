export type Strength = "low"|"medium"|"high";
export interface GradeIn {
  text: string;
  concept: string;
  behavior?: string;
  targetStrength?: Strength;
  dialectLevel: 1|2|3|4;
  unlockedSignals: string[];
}
export interface GradeOut {
  strength: Strength;
  score: number;
  signals: Record<string,0|1>;
  summary: string;
  maneuvers: string[];
  nextHint?: string;
}
const lex = {
  say: [/i want\b/i,/i need\b/i,/\bi decide\b/i,/\bpromise\b/i,/\bconfess/i],
  show: [/grip|jaw|shoulder|breath|sweat|tremble|stare|flinch|pace/i],
  hide: [/\bmaybe\b|\bkinda\b|\bit\'?s fine\b|\bi\'?m ok/i]
};
function detect(text:string, pats:RegExp[]):0|1 { return pats.some(r=>r.test(text))?1:0; }
export function grade(input: GradeIn): GradeOut {
  const t = input.text;
  const say = detect(t, lex.say);
  const show = detect(t, lex.show);
  const hide = detect(t, lex.hide);
  const specificity:0|1 = /\b(\d+|ring|cup|door|chair|keys|receipt|hoodie|bus|knife|coffee)\b/i.test(t)?1:0;
  const pressure:0|1 = /\brisk|lose|deadline|owe|afraid|hurt|embarrass|cost\b/i.test(t)?1:0;
  const consequence:0|1 = /\bso\b|\btherefore\b|\bas a result\b|\bthen\b/i.test(t)?1:0;
  const field:0|1 = /\broom|everyone|crowd|stare|quiet|backs? off|leans?\b/i.test(t)?1:0;
  let strength:Strength = (say||show||hide)? "low":"low";
  if ((say||show||hide) && pressure && consequence) strength = "medium";
  if (strength==="medium" && field) strength = "high";
  const score = [say,show,hide,specificity,pressure,consequence,field].reduce((a,b)=>a+(b as number),0);
  const summary = `Signals: say:${say} show:${show} hide:${hide} spec:${specificity} pressure:${pressure} cons:${consequence} field:${field}. Strength:${strength}.`;
  const maneuvers = input.behavior==="show"
    ? ["Tighten one gesture.","Let an object carry the cost.","Cut one adjective; add one action."]
    : ["Let another character name the risk.","Switch a small motion from tight to loose.","End on the beat that changes the air."];
  return { strength, score, signals: {say,show,hide,specificity,pressure,consequence,field}, summary, maneuvers };
}
