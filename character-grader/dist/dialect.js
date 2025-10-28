const DIALECT_LEXICON = {
  1: new Set(["moment", "feeling", "choice", "want", "cost", "move"]),
  2: new Set([
    "moment",
    "feeling",
    "choice",
    "want",
    "cost",
    "move",
    "pattern",
    "pressure",
    "signal"
  ]),
  3: new Set([
    "moment",
    "feeling",
    "choice",
    "want",
    "cost",
    "move",
    "pattern",
    "pressure",
    "signal",
    "scene",
    "beat",
    "status"
  ]),
  4: new Set([
    "moment",
    "feeling",
    "choice",
    "want",
    "cost",
    "move",
    "pattern",
    "pressure",
    "signal",
    "scene",
    "beat",
    "status",
    "archetype",
    "resonance",
    "mythic"
  ])
};

const TERM_REWRITES = {
  pressure: "cost",
  scene: "moment",
  beat: "moment",
  status: "standing",
  archetype: "role",
  resonance: "echo",
  mythic: "legend",
  signal: "cue",
  pattern: "track"
};

export const simplifyTerm = (term, level) => {
  const allowed = DIALECT_LEXICON[level];
  if (allowed && allowed.has(term)) {
    return term;
  }
  const lower = term.toLowerCase();
  const replacement = TERM_REWRITES[lower];
  if (replacement) {
    return level === 1 ? replacement : simplifyTerm(replacement, level);
  }
  if (level === 1) {
    if (lower.includes("pressure")) return "cost";
    if (lower.includes("scene")) return "moment";
    if (lower.includes("signal")) return "cue";
  }
  return term;
};

const tokenizeFeedback = (text) => text.split(/(\W+)/);

export const speak = (text, level) => {
  const tokens = tokenizeFeedback(text);
  const transformed = tokens.map((token) => {
    if (/^[A-Za-z]+$/.test(token)) {
      const lower = token.toLowerCase();
      const simplified = simplifyTerm(lower, level);
      if (lower === simplified) {
        return token;
      }
      if (token[0] === token[0].toUpperCase()) {
        return simplified.charAt(0).toUpperCase() + simplified.slice(1);
      }
      return simplified;
    }
    return token;
  });
  return transformed.join("");
};
