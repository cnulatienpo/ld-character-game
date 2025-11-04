export function aliasLabel(concept:string, aliases:Record<string,string>):string {
  return aliases[concept] ?? concept;
}
