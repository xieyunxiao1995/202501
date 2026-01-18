enum CardType {
  exit,
  empty,
  hero, // Represents the player's position
  monster,
  weapon,
  shield,
  potion,
  treasure,
  portal,
  trap,
  key,
  chest,
  shrine,
  material,
  soul,
  event,
}

enum SoulEffectType {
  lifeSteal,
  thorns,
  crit,
  dodge,
  regen,
  reflect,
  goldBonus,
}

enum EnemyType { standard, ranged, tank, summoner }

enum GameState {
  splash,
  menu,
  levelSelect,
  classSelect,
  playing,
  shop,
  metaStore,
  gameOver,
  levelUp,
  shrine,
  achievements,
  alchemy,
  compendium,
  event,
  settings,
  dailyLogin,
  cultivation,
}

enum Rarity { common, rare, epic, legendary }

enum Affix { none, heavy, sharp, toxic, burning, cursed }

enum GameElement { none, metal, wood, water, fire, earth }

enum Biome { forest, volcano, ocean, void_ }
