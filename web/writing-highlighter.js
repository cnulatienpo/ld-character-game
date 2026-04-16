const highlightStyles = {
  has_action: "has_action",
  has_reaction: "has_reaction",
  has_repetition: "has_repetition",
  has_sequence: "has_sequence",
  has_other_person: "has_other_person"
};

const SIGNAL_PATTERNS = {
  has_action: /\b(?:walks?|walked|walking|runs?|ran|running|turns?|turned|turning|looks?|looked|looking|taps?|tapped|tapping|grabs?|grabbed|grabbing|opens?|opened|opening|closes?|closed|closing|moves?|moved|moving)\b/gi,
  has_reaction: /\b(?:stops?|stopped|stopping|freezes?|froze|frozen|jumps?|jumped|jumping|gasps?|gasped|gasping|flinches?|flinched|flinching|smiles?|smiled|smiling|laughs?|laughed|laughing|cries?|cried|crying|sighs?|sighed|sighing)\b/gi,
  has_repetition: /\b(?:again|repeatedly|twice|thrice|keeps|kept|still|always)\b/gi,
  has_sequence: /\b(?:then|next|after|before|finally|meanwhile|suddenly|later|first|second)\b/gi,
  has_other_person: /\b(?:he|she|they|him|her|them|his|hers|their|friend|teacher|mother|father|brother|sister)\b/gi
};

function analyzeText(text) {
  const source = String(text || "");
  const matches = {};
  const signals = {};

  for (const signal of Object.keys(highlightStyles)) {
    const found = collectUniqueMatches(source, SIGNAL_PATTERNS[signal]);
    matches[signal] = found;
    signals[signal] = found.length > 0;
  }

  return { signals, matches };
}

function highlightText(text, analysis) {
  const source = String(text || "");
  if (!source) return "";

  const safeAnalysis = analysis && analysis.matches ? analysis : { matches: {} };
  const styleLookup = buildStyleLookup(safeAnalysis.matches, highlightStyles);
  if (styleLookup.size === 0) {
    return escapeHtml(source);
  }

  const tokenRegex = /\b[\w']+\b/g;
  const chunks = [];
  let cursor = 0;
  let tokenMatch;

  while ((tokenMatch = tokenRegex.exec(source)) !== null) {
    const token = tokenMatch[0];
    const start = tokenMatch.index;
    const end = start + token.length;
    const normalized = normalizeToken(token);
    const cssClass = styleLookup.get(normalized);

    if (!cssClass) continue;

    if (start > cursor) {
      chunks.push(escapeHtml(source.slice(cursor, start)));
    }

    chunks.push(`<span class="${escapeHtmlAttribute(cssClass)}">${escapeHtml(token)}</span>`);
    cursor = end;
  }

  if (cursor < source.length) {
    chunks.push(escapeHtml(source.slice(cursor)));
  }

  return chunks.join("");
}

function collectUniqueMatches(text, regex) {
  if (!regex) return [];
  const found = [];
  const seen = new Set();
  regex.lastIndex = 0;

  let match;
  while ((match = regex.exec(text)) !== null) {
    const value = match[0];
    const key = normalizeToken(value);
    if (!key || seen.has(key)) continue;
    seen.add(key);
    found.push(value);
  }

  return found;
}

function buildStyleLookup(matches, classMap) {
  const lookup = new Map();

  for (const signal of Object.keys(classMap)) {
    const cssClass = classMap[signal];
    const words = Array.isArray(matches[signal]) ? matches[signal] : [];

    for (const word of words) {
      const normalized = normalizeToken(word);
      if (!normalized || lookup.has(normalized)) continue;
      lookup.set(normalized, cssClass);
    }
  }

  return lookup;
}

function normalizeToken(value) {
  return String(value || "").toLowerCase().trim();
}

function escapeHtml(value) {
  return String(value)
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/\"/g, "&quot;")
    .replace(/'/g, "&#39;");
}

function escapeHtmlAttribute(value) {
  return String(value)
    .replace(/&/g, "&amp;")
    .replace(/\"/g, "&quot;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;");
}

if (typeof window !== "undefined") {
  window.highlightStyles = highlightStyles;
  window.analyzeText = analyzeText;
  window.highlightText = highlightText;
}

if (typeof module !== "undefined" && module.exports) {
  module.exports = { highlightStyles, analyzeText, highlightText };
}
