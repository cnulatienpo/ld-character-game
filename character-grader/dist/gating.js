const meetsPrecedence = (tile, unlocked) => {
  const needed = tile.precedence?.comes_after;
  if (!needed || needed.length === 0) {
    return true;
  }
  return needed.every((id) => unlocked.includes(id));
};

const withinDialect = (tile, level) => {
  return tile.language.dialect_level <= level;
};

export const suggestNextUnlocks = (input, signals, seeder) => {
  const unlocks = new Set();
  const { unlocked_signals, dialect_level } = input.player;

  if (signals.pressure && signals.follow_through) {
    for (const tile of seeder.tiles) {
      const comesAfter = tile.precedence?.comes_after || [];
      if (
        comesAfter.some((id) =>
          ["consequence_intro", "pressure_chain", "cost_followup"].includes(id)
        ) &&
        meetsPrecedence(tile, unlocked_signals) &&
        withinDialect(tile, dialect_level)
      ) {
        unlocks.add(tile.id);
      }
    }
  }

  if (signals.say && signals.show) {
    for (const tile of seeder.tiles) {
      if (
        tile.concept === input.concept &&
        tile.behaviors.includes("hide") &&
        meetsPrecedence(tile, unlocked_signals) &&
        withinDialect(tile, dialect_level)
      ) {
        unlocks.add(tile.id);
      }
    }
  }

  if (signals.field_change) {
    for (const tile of seeder.tiles) {
      if (
        tile.concept === input.concept &&
        tile.strength_tiers.includes("high") &&
        meetsPrecedence(tile, unlocked_signals) &&
        withinDialect(tile, dialect_level)
      ) {
        unlocks.add(tile.id);
      }
    }
  }

  return Array.from(unlocks);
};
