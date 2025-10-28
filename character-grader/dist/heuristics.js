const SAY_PATTERNS = [
  /"[^"]+"/,
  /\bI (?:want|need|decide|promise|swear|admit|confess)\b/i,
  /\bI(?:'m| am) going to\b/i,
  /\bmy goal\b/i,
  /\bI will\b/i,
  /\bdecide(?:d)?\b/i,
  /\bchoose(?:s|n)?\b/i,
  /\bpromise(?:s|d)?\b/i
];

const SHOW_VERBS = [
  "push",
  "grab",
  "slam",
  "shove",
  "pace",
  "nod",
  "glance",
  "stare",
  "clench",
  "tremble",
  "flinch",
  "fidget",
  "shrug",
  "smirk",
  "smile",
  "grin",
  "grimace",
  "sigh",
  "huff",
  "storm",
  "step",
  "lean",
  "fold"
];

const SENSORY_TERMS = [
  "smell",
  "sweat",
  "heartbeat",
  "pulse",
  "taste",
  "sound",
  "echo",
  "heat",
  "cold",
  "chill",
  "buzz",
  "sting"
];

const OBJECT_CUES = [
  "keys",
  "door",
  "phone",
  "screen",
  "hoodie",
  "ring",
  "knife",
  "coffee",
  "table",
  "receipt",
  "bus",
  "train",
  "stairs",
  "locker"
];

const HIDE_PATTERNS = [
  /\bmaybe\b/i,
  /\bkinda\b/i,
  /\bsort of\b/i,
  /\bwhatever\b/i,
  /\bit'?s fine\b/i,
  /\bI'?m ok(?:ay)?\b/i,
  /\bchange[s]? the subject\b/i,
  /\bdoesn'?t answer\b/i,
  /\blaughs it off\b/i,
  /\bshrug(?:s|ged)?\b.*\b(off|it)\b/i
];

const SPECIFIC_NOUNS = [
  "door",
  "keys",
  "table",
  "receipt",
  "hoodie",
  "bus",
  "knife",
  "ring",
  "coffee",
  "locker",
  "alley",
  "cashier",
  "subway",
  "poster",
  "stairs",
  "bench",
  "notebook",
  "badge",
  "mirror",
  "couch"
];

const PRESSURE_TERMS = [
  /\brisk\b/i,
  /\blose\b/i,
  /\bif I don'?t\b/i,
  /\bdeadline\b/i,
  /\bshe'?ll leave\b/i,
  /\bget fired\b/i,
  /\bowe\b/i,
  /\bcaught\b/i,
  /\bafraid\b/i,
  /\bhurt\b/i,
  /\bembarrassed\b/i,
  /\bhumiliated\b/i,
  /\bstakes\b/i,
  /\bpressure\b/i
];

const CONSEQUENCE_LINKERS = [
  /\bso\b/i,
  /\btherefore\b/i,
  /\bwhich means\b/i,
  /\bafter\b/i,
  /\bthen I\b/i,
  /\bas a result\b/i,
  /\bleading to\b/i
];

const FIELD_CHANGE_MARKERS = [
  /\bthey (?:stare|glare|laugh|gasp)\b/i,
  /\bthe room (?:goes|falls) quiet\b/i,
  /\bcrowd\b/i,
  /\bmanager\b/i,
  /\beveryone\b/i,
  /\bhe (?:backs off|laughs)\b/i,
  /\bshe (?:backs off|nods)\b/i,
  /\bI can'?t anymore\b/i,
  /\bI finally\b/i,
  /\bI won'?t\b/i,
  /\bI'?m done\b/i
];

const tokenize = (text) =>
  text
    .toLowerCase()
    .replace(/[^a-z0-9\s']/g, " ")
    .split(/\s+/)
    .filter(Boolean);

const unique = (items) => Array.from(new Set(items));

const findMatches = (patterns, text) => {
  const matches = [];
  for (const pattern of patterns) {
    if (typeof pattern === "string") {
      if (text.toLowerCase().includes(pattern.toLowerCase())) {
        matches.push(pattern);
      }
    } else {
      const match = text.match(pattern);
      if (match) {
        matches.push(match[0]);
      }
    }
  }
  return unique(matches);
};

const countSpecificNouns = (tokens) => {
  const set = new Set(SPECIFIC_NOUNS);
  const matches = tokens.filter((token) => set.has(token));
  return unique(matches).length;
};

const hasNumbersOrProperNouns = (text) => {
  if (/\b\d+\b/.test(text)) {
    return true;
  }
  return /(\.|!|\?)\s+[A-Z][a-z]+/.test(text);
};

const detectSay = (text, evidence) => {
  const matches = findMatches(SAY_PATTERNS, text);
  if (matches.length > 0) {
    evidence.say = matches;
    return 1;
  }
  evidence.say = [];
  return 0;
};

const detectShow = (text, tokens, evidence) => {
  const matches = [];
  for (const verb of SHOW_VERBS) {
    if (tokens.includes(verb)) {
      matches.push(verb);
    }
  }
  for (const term of SENSORY_TERMS) {
    if (tokens.includes(term)) {
      matches.push(term);
    }
  }
  for (const cue of OBJECT_CUES) {
    if (tokens.includes(cue)) {
      matches.push(cue);
    }
  }
  if (matches.length > 0) {
    evidence.show = unique(matches);
    return 1;
  }
  evidence.show = [];
  return 0;
};

const detectHide = (text, evidence) => {
  const matches = findMatches(HIDE_PATTERNS, text);
  if (matches.length > 0) {
    evidence.hide = matches;
    return 1;
  }
  evidence.hide = [];
  return 0;
};

const detectSpecificity = (text, tokens, evidence) => {
  const concreteCount = countSpecificNouns(tokens);
  const hasSpecificity = concreteCount >= 2 || hasNumbersOrProperNouns(text);
  if (hasSpecificity) {
    evidence.specificity = unique([
      ...tokens.filter((token) => SPECIFIC_NOUNS.includes(token))
    ]);
    if (hasNumbersOrProperNouns(text)) {
      evidence.specificity.push("number/proper noun");
    }
    evidence.specificity = unique(evidence.specificity);
    return 1;
  }
  evidence.specificity = [];
  return 0;
};

const detectPressure = (text, evidence) => {
  const matches = findMatches(PRESSURE_TERMS, text);
  if (matches.length > 0) {
    evidence.pressure = matches;
    return 1;
  }
  evidence.pressure = [];
  return 0;
};

const detectFollowThrough = (text, tokens, evidence) => {
  const matches = findMatches(CONSEQUENCE_LINKERS, text);
  let actionShift = 0;
  if (/\bthen I\b.+\b(ed|ing)\b/i.test(text) || /\bas a result\b.+\b(ed|ing)\b/i.test(text)) {
    actionShift = 1;
  }
  if (matches.length > 0 && actionShift) {
    evidence.follow_through = matches;
    return 1;
  }
  const verbCount = tokens.filter((token) => token.endsWith("ed")).length;
  if (matches.length > 0 && verbCount >= 2) {
    evidence.follow_through = matches;
    return 1;
  }
  evidence.follow_through = [];
  return 0;
};

const detectFieldChange = (text, evidence) => {
  const matches = findMatches(FIELD_CHANGE_MARKERS, text);
  if (matches.length > 0) {
    evidence.field_change = matches;
    return 1;
  }
  evidence.field_change = [];
  return 0;
};

export const analyzeSignals = (text) => {
  const evidence = {};
  const tokens = tokenize(text);
  const report = {
    say: detectSay(text, evidence),
    show: detectShow(text, tokens, evidence),
    hide: detectHide(text, evidence),
    specificity: detectSpecificity(text, tokens, evidence),
    pressure: detectPressure(text, evidence),
    follow_through: detectFollowThrough(text, tokens, evidence),
    field_change: detectFieldChange(text, evidence)
  };
  return { report, evidence };
};
