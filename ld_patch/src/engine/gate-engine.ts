export function nextTile({concept, strength}:{concept:string;strength:"low"|"medium"|"high"}) {
  if (strength==="low") return `${concept}_behavior_show`;
  if (strength==="medium") return `${concept}_strength_high`;
  return `${concept}_toolkit`;
}
