export function suggestions({concept,behavior,strength}:{concept:string;behavior?:string;strength:"low"|"medium"|"high"}):string[] {
  if (behavior==="show") return ["Let a small action tilt the room.","Use one concrete noun to carry weight."];
  if (behavior==="say") return ["Let someone speak the cost once.","Trim explanation; keep the vow."];
  return ["Shift one detail from visible to hidden.","Let silence do a beat of work."];
}
