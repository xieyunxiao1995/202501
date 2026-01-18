
import { CardData, CardType } from '../types';
import { GRID_SIZE, MONSTER_NAMES, BOSS_NAMES, WEAPON_NAMES, SHIELD_NAMES, TRAP_NAMES } from '../constants';

const uid = () => Math.random().toString(36).substr(2, 9);

export const generateLevel = (floor: number): CardData[] => {
  const cards: CardData[] = [];
  
  const isBossFloor = floor % 5 === 0;
  
  // Difficulty Scaling
  const tier = Math.floor((floor - 1) / 5); 
  const basePower = 3 + (floor * 1.5) + (tier * 2);
  const powerVariance = Math.floor(floor + (tier * 3));

  // 1. Portal
  cards.push({
    id: uid(),
    type: CardType.PORTAL,
    value: 0,
    isFlipped: false,
    name: isBossFloor ? "BOSS PORTAL" : "Portal",
    icon: "🌀",
    rarity: 'epic'
  });

  // 2. Boss
  if (isBossFloor) {
      const bossIdx = Math.min(Math.floor(floor / 5) - 1, BOSS_NAMES.length - 1);
      cards.push({
          id: uid(),
          type: CardType.MONSTER,
          value: Math.floor(basePower * 3.5),
          isFlipped: false,
          name: BOSS_NAMES[Math.max(0, bossIdx)],
          icon: "👹",
          rarity: 'legendary',
          isBoss: true,
          affix: 'none'
      });
  }

  // 3. Fill Grid
  const cardsToGen = GRID_SIZE - cards.length;
  
  // Feature: Guaranteed Pair logic? 
  // For simplicity, we use probabilistic generation but boost keys if chests exist?
  // Let's just stick to weighted random for the grid.
  
  for (let i = 0; i < cardsToGen; i++) {
    const rand = Math.random();
    let card: CardData;

    if (rand < 0.05) {
        // Special Objects: Key, Chest, Shrine
        const subRand = Math.random();
        if (subRand < 0.4) {
             card = { id: uid(), type: CardType.KEY, value: 1, isFlipped: false, name: "Rusty Key", icon: "🗝️", rarity: 'rare' };
        } else if (subRand < 0.7) {
             const val = 100 + (floor * 20);
             card = { id: uid(), type: CardType.CHEST, value: val, isFlipped: false, name: "Locked Chest", icon: "🔒", rarity: 'epic' };
        } else {
             card = { id: uid(), type: CardType.SHRINE, value: 0, isFlipped: false, name: "Mystic Shrine", icon: "⛩️", rarity: 'rare' };
        }
    } else if (rand < 0.12) {
        // TRAP
        const damage = 10 + Math.floor(floor * 2);
        card = {
            id: uid(),
            type: CardType.TRAP,
            value: damage,
            isFlipped: false,
            name: TRAP_NAMES[Math.floor(Math.random() * TRAP_NAMES.length)],
            icon: "⚠️",
            rarity: 'common'
        };
    } else if (rand < 0.25) {
      // Weapon
      const rarityRoll = Math.random();
      const isRare = rarityRoll > 0.85;
      const val = Math.max(1, Math.floor((basePower * 0.4) * (isRare ? 1.5 : 0.8)));
      card = {
        id: uid(),
        type: CardType.WEAPON,
        value: val,
        isFlipped: false,
        name: WEAPON_NAMES[Math.min(Math.floor(floor/2) + (isRare?2:0), WEAPON_NAMES.length-1)],
        icon: "⚔️",
        rarity: isRare ? 'rare' : 'common'
      };
    } else if (rand < 0.35) {
        // Shield
        const val = 10 + (floor * 5);
        card = {
            id: uid(),
            type: CardType.SHIELD,
            value: val,
            isFlipped: false,
            name: SHIELD_NAMES[Math.min(Math.floor(floor/3), SHIELD_NAMES.length-1)],
            icon: "🛡️",
            rarity: 'common'
        };
    } else if (rand < 0.48) {
      // Potion
      const isLarge = Math.random() > 0.8;
      card = {
        id: uid(),
        type: CardType.POTION,
        value: isLarge ? 50 + (floor * 5) : 20 + (floor * 2),
        isFlipped: false,
        name: isLarge ? "Big Potion" : "Potion",
        icon: isLarge ? "🍷" : "🧪",
        rarity: isLarge ? 'rare' : 'common'
      };
    } else if (rand < 0.58) {
      // Treasure
      const val = 25 + (floor * 10);
      card = {
        id: uid(),
        type: CardType.TREASURE,
        value: val,
        isFlipped: false,
        name: "Gold",
        icon: "💰",
        rarity: 'common'
      };
    } else {
      // Monster
      const isElite = Math.random() > 0.85;
      let monsterPower = Math.floor(basePower + (Math.random() * powerVariance));
      
      let affix: 'none' | 'heavy' | 'sharp' | 'toxic' | 'cursed' = 'none';
      let namePrefix = "";

      // Affix Logic (Floor 3+)
      if (floor >= 2 && Math.random() > 0.65) {
          const roll = Math.random();
          if (roll < 0.3) {
              affix = 'heavy';
              monsterPower = Math.floor(monsterPower * 1.3);
              namePrefix = "Heavy ";
          } else if (roll < 0.6) {
              affix = 'sharp';
              namePrefix = "Sharp ";
          } else if (roll < 0.8) {
              affix = 'toxic';
              namePrefix = "Toxic ";
          } else {
              affix = 'cursed';
              namePrefix = "Cursed ";
          }
      }

      if (isElite) {
          monsterPower = Math.floor(monsterPower * 1.5);
          namePrefix = "Elite " + namePrefix;
      }
      
      card = {
        id: uid(),
        type: CardType.MONSTER,
        value: monsterPower,
        isFlipped: false,
        name: namePrefix + MONSTER_NAMES[Math.min(Math.floor(floor/2), MONSTER_NAMES.length-1)],
        icon: isElite ? "💀" : "👿",
        rarity: isElite ? 'rare' : 'common',
        affix: affix
      };
    }
    cards.push(card);
  }

  // 4. Shuffle
  for (let i = cards.length - 1; i > 0; i--) {
    const j = Math.floor(Math.random() * (i + 1));
    [cards[i], cards[j]] = [cards[j], cards[i]];
  }

  // 5. Safe Start
  let startIndex = cards.findIndex(c => c.type !== CardType.MONSTER && c.type !== CardType.PORTAL && c.type !== CardType.TRAP && c.type !== CardType.SHRINE && !c.isBoss);
  if (startIndex === -1) {
      startIndex = 0;
      cards[0] = {
        id: uid(),
        type: CardType.POTION,
        value: 15,
        isFlipped: false,
        name: "Starter Potion",
        icon: "🧪",
        rarity: 'common'
      };
  }
  cards[startIndex].isFlipped = true;

  return cards;
};
