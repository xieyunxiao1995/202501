
import { ClassConfig, Perk, PlayerStats, RelicConfig } from './types';

export const GRID_COLS = 4;
export const GRID_SIZE = GRID_COLS * GRID_COLS; // 16

export const INITIAL_PLAYER_STATS: PlayerStats = {
  hp: 100,
  maxHp: 100,
  shield: 0,
  power: 5,
  gold: 0,
  score: 0,
  highScore: 0,
  floor: 1,
  classId: 'warrior',
  relics: [],
  skillCharge: 0,
  combo: 0,
  keys: 0,
  poison: 0,
  weak: 0,
  level: 1,
  xp: 0,
  maxXp: 10,
  perks: []
};

export const PERKS: Perk[] = [
    { id: 'might', name: 'Might', desc: '+1 Base Power', icon: '💪', rarity: 'common' },
    { id: 'thick_skin', name: 'Thick Skin', desc: '+15 Max HP', icon: '🦏', rarity: 'common' },
    { id: 'greed', name: 'Greed', desc: '+20% Gold Gain', icon: '🤑', rarity: 'common' },
    { id: 'sharpness', name: 'Sharpness', desc: '+50% Crit Chance (x1.5 Dmg)', icon: '🎯', rarity: 'rare' },
    { id: 'leech', name: 'Leech', desc: 'Heal 1 HP on kill', icon: '🦇', rarity: 'rare' },
    { id: 'scavenger', name: 'Scavenger', desc: 'Find more items', icon: '🎒', rarity: 'rare' },
    { id: 'fortress', name: 'Fortress', desc: 'Start floor with +15 Shield', icon: '🏰', rarity: 'epic' },
    { id: 'executioner', name: 'Executioner', desc: 'Instantly kill enemies under 15 Power', icon: '☠️', rarity: 'epic' },
    { id: 'divine', name: 'Divine Blessing', desc: 'Full Heal + Remove Statuses on Level Up', icon: '✨', rarity: 'legendary' }
];

export const CLASSES: ClassConfig[] = [
    { 
      id: 'warrior', 
      name: 'Warrior', 
      icon: '⚔️', 
      hp: 110, 
      power: 5, 
      shield: 0, 
      desc: 'High risk, high reward.',
      skillName: 'Fortify',
      skillDesc: 'Gain +25 Shield.',
      passiveName: 'Rage',
      passiveDesc: '+1 ATK per 20 missing HP.'
    },
    { 
      id: 'rogue', 
      name: 'Rogue', 
      icon: '🗡️', 
      hp: 80, 
      power: 7, 
      shield: 0, 
      desc: 'Tricky and evasive.',
      skillName: 'Scout',
      skillDesc: 'Reveal 3 random cards.',
      passiveName: 'Evasion',
      passiveDesc: '20% chance to dodge damage.'
    },
    { 
      id: 'paladin', 
      name: 'Paladin', 
      icon: '🛡️', 
      hp: 120, 
      power: 4, 
      shield: 10, 
      desc: 'Sustainable tank.',
      skillName: 'Holy Light',
      skillDesc: 'Heal +30 HP.',
      passiveName: 'Devotion',
      passiveDesc: 'Heal 2 HP on kill.'
    },
];

export const RELICS: RelicConfig[] = [
    { id: 'vampire', name: 'Vampire Fang', icon: '🧛', desc: 'Heal 3 HP on kill.', cost: 300 },
    { id: 'midas', name: 'Midas Coin', icon: '🪙', desc: '+50% Gold found.', cost: 250 },
    { id: 'stone', name: 'Stone Heart', icon: '🗿', desc: '+15 Shield per floor.', cost: 200 },
    { id: 'luck', name: 'Rabbit Foot', icon: '🐰', desc: 'Skills charge 50% faster.', cost: 180 },
    { id: 'sharp', name: 'Whetstone', icon: '🔪', desc: '+2 ATK immediately.', cost: 150 },
    { id: 'vitality', name: 'Life Orb', icon: '🔮', desc: '+20 Max HP immediately.', cost: 150 },
];

export const MONSTER_NAMES = ["Slime", "Rat", "Goblin", "Skeleton", "Orc", "Ghost", "Golem", "Demon", "Dragon"];
export const BOSS_NAMES = ["King Slime", "Goblin Warlord", "Lich King", "Orc Chieftain", "Void Demon", "Ancient Dragon"];
export const WEAPON_NAMES = ["Stick", "Dagger", "Shortsword", "Axe", "Mace", "Longsword", "Halberd", "Excalibur"];
export const SHIELD_NAMES = ["Lid", "Buckler", "Round Shield", "Kite Shield", "Tower Shield", "Aegis"];
export const TRAP_NAMES = ["Spikes", "Poison Gas", "Bear Trap", "Dart Trap"];

export const RARITY_BG = {
  common: 'border-gray-600 bg-gray-800',
  rare: 'border-blue-500 bg-gray-800 shadow-[0_0_10px_rgba(59,130,246,0.3)]',
  epic: 'border-purple-500 bg-gray-800 shadow-[0_0_10px_rgba(168,85,247,0.3)]',
  legendary: 'border-yellow-500 bg-gray-900 shadow-[0_0_15px_rgba(234,179,8,0.5)]'
};
