
export enum CardType {
  EMPTY = 'EMPTY',
  MONSTER = 'MONSTER',
  WEAPON = 'WEAPON',
  SHIELD = 'SHIELD',
  POTION = 'POTION',
  TREASURE = 'TREASURE',
  PORTAL = 'PORTAL',
  TRAP = 'TRAP',
  KEY = 'KEY',
  CHEST = 'CHEST',
  SHRINE = 'SHRINE'
}

export interface CardData {
  id: string;
  type: CardType;
  value: number; 
  isFlipped: boolean;
  isRevealed?: boolean;
  name: string;
  icon: string;
  rarity: 'common' | 'rare' | 'epic' | 'legendary';
  isBoss?: boolean;
  affix?: 'heavy' | 'sharp' | 'toxic' | 'cursed' | 'none'; // New: Monster traits
}

export interface PlayerStats {
  hp: number;
  maxHp: number;
  shield: number;
  power: number;
  gold: number;
  score: number;
  highScore: number;
  floor: number;
  classId: string;
  relics: string[];
  skillCharge: number;
  combo: number;
  keys: number;
  poison: number;
  weak: number;
  level: number; // New
  xp: number;    // New
  maxXp: number; // New
  perks: string[]; // New: List of perk IDs
}

export interface Perk {
    id: string;
    name: string;
    desc: string;
    icon: string;
    rarity: 'common' | 'rare' | 'epic' | 'legendary';
}

export interface FloatingText {
  id: number;
  x: number;
  y: number;
  text: string;
  color: string;
}

export enum GameState {
  MENU = 'MENU',
  CLASS_SELECT = 'CLASS_SELECT',
  PLAYING = 'PLAYING',
  SHOP = 'SHOP',
  GAME_OVER = 'GAME_OVER',
  LEVEL_UP = 'LEVEL_UP', // New
}

export interface ClassConfig {
    id: string;
    name: string;
    icon: string;
    hp: number;
    power: number;
    shield: number;
    desc: string;
    skillName: string;
    skillDesc: string;
    passiveName: string;
    passiveDesc: string;
}

export interface ShopItem {
    id: string;
    name: string;
    type: 'stat' | 'heal' | 'relic' | 'key';
    value: number;
    cost: number;
    icon: string;
    desc: string;
    isSold?: boolean;
}

export interface RelicConfig {
    id: string;
    name: string;
    icon: string;
    desc: string;
    cost: number;
}
