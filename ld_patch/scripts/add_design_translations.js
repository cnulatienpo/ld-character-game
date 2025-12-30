const fs = require("fs");
const path = require("path");

const CONCEPT_TO_LANGUAGE = {
  Description: "weight/balance",
  Presence: "field/pressure",
  Identity: "pattern/contradiction",
  Conflict: "opposition/force",
  Stakes: "weight/cost",
  Outcome: "equilibrium/landing"
};

const CONCEPT_ANALOGIES = {
  Description: [
    "Architecture: a lintel that carries weight without ornament.",
    "Music: a bass line holding the measure steady.",
    "Cooking: a sauce reduced until the texture tells the story."
  ],
  Presence: [
    "Architecture: a hallway that narrows to redirect flow.",
    "Music: the bridge that softens before the chorus hits.",
    "Cooking: steam rising when the lid tilts just enough."
  ],
  Identity: [
    "Architecture: a façade that hides and reveals structure.",
    "Music: a melody twisting against its own motif.",
    "Cooking: plating that pairs opposites on the same dish."
  ],
  Conflict: [
    "Architecture: a cantilever fighting gravity with invisible anchors.",
    "Music: a drum fill that pushes against the tempo.",
    "Cooking: a pan sizzling when cold stock hits the heat."
  ],
  Stakes: [
    "Architecture: a load-bearing wall marked in red pencil.",
    "Music: a crescendo that tells the audience to hold breath.",
    "Cooking: the timer blinking as sugar nears the burn point."
  ],
  Outcome: [
    "Architecture: a staircase that resolves on a landing with light.",
    "Music: the final chord that settles the air.",
    "Cooking: the resting moment before slicing into a roast."
  ]
};

function selectAnalogies(concept, index) {
  const pool = CONCEPT_ANALOGIES[concept] || [];
  if (!pool.length) {
    return "";
  }
  const first = pool[index % pool.length];
  const second = pool[(index + 2) % pool.length];
  return `${first} ${second}`.trim();
}

function fillTranslations(entries) {
  return entries.map((entry, index)=>{
    if (entry.design_translation && entry.design_translation.trim().length > 0) {
      return entry;
    }
    const concept = entry.concept;
    const analogies = selectAnalogies(concept, index);
    const language = CONCEPT_TO_LANGUAGE[concept] || "design balance";
    const note = `${analogies} Design note: keep the ${language} visible in motion.`.trim();
    return { ...entry, design_translation: note };
  });
}

function run() {
  const targetPath = path.join(process.cwd(), "dataset", "character_full_master.seeder.json");
  const raw = fs.readFileSync(targetPath, "utf8");
  const entries = JSON.parse(raw);
  const updated = fillTranslations(entries);
  const tempPath = `${targetPath}.tmp`;
  fs.writeFileSync(tempPath, JSON.stringify(updated, null, 2) + "\n", "utf8");
  fs.renameSync(tempPath, targetPath);
}

if (require.main === module) {
  run();
}

module.exports = {
  fillTranslations,
  CONCEPT_TO_LANGUAGE
};
