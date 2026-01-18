import 'package:flutter/material.dart';
import 'models/configs.dart';
import 'models/enums.dart';
import 'models/player_stats.dart';

const int gridCols = 4;
const int gridSize = gridCols * gridCols;

final PlayerStats initialPlayerStats = PlayerStats(
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
  burn: 0,
  level: 1,
  xp: 0,
  maxXp: 10,
  perks: [],
);

const List<Perk> perks = [
  Perk(id: 'might', name: '夸父之力', desc: '基础攻击 +1', icon: '💪', rarity: Rarity.common),
  Perk(id: 'thick_skin', name: '玄武神甲', desc: '精血上限 +15', icon: '🐢', rarity: Rarity.common),
  Perk(id: 'greed', name: '金蟾献宝', desc: '灵石收益 +20%', icon: '🐸', rarity: Rarity.common),
  Perk(id: 'sharpness', name: '鸣鸿断水', desc: '暴击率 +50% (1.5倍伤害)', icon: '🗡️', rarity: Rarity.rare),
  Perk(id: 'leech', name: '吞噬血脉', desc: '击败妖兽回复 1 精血', icon: '🦇', rarity: Rarity.rare),
  Perk(id: 'scavenger', name: '灵感洞悉', desc: '发现更多奇珍异宝', icon: '🔍', rarity: Rarity.rare),
  Perk(id: 'fortress', name: '不动如山', desc: '每层开始时获得 +15 护身', icon: '⛰️', rarity: Rarity.epic),
  Perk(id: 'executioner', name: '斩仙飞刀', desc: '立即击杀攻击低于 15 的妖兽', icon: '⚔️', rarity: Rarity.epic),
  Perk(id: 'divine', name: '九转金丹', desc: '突破时完全回复并清除异常状态', icon: '💊', rarity: Rarity.legendary),
];

const List<ClassConfig> classes = [
  ClassConfig(
    id: 'warrior',
    name: '荒古剑修',
    icon: '⚔️',
    hp: 110,
    power: 5,
    shield: 0,
    desc: '御剑乘风，斩妖除魔。',
    skillName: '剑气护体',
    skillDesc: '获得 +25 护身。',
    passiveName: '狂战剑意',
    passiveDesc: '每损失 20 精血 获得 +1 攻击。',
  ),
  ClassConfig(
    id: 'rogue',
    name: '大荒羽士',
    icon: '🗡️',
    hp: 80,
    power: 7,
    shield: 0,
    desc: '身轻如燕，箭无虚发。',
    skillName: '天眼通',
    skillDesc: '揭开 3 张随机卡牌。',
    passiveName: '灵动身法',
    passiveDesc: '20% 几率闪避伤害。',
  ),
  ClassConfig(
    id: 'paladin',
    name: '磐石力士',
    icon: '🛡️',
    hp: 120,
    power: 4,
    shield: 10,
    desc: '不动如山，坚如磐石。',
    skillName: '厚土之盾',
    skillDesc: '回复 +30 精血。',
    passiveName: '大荒血脉',
    passiveDesc: '击败妖兽回复 2 精血。',
  ),
  ClassConfig(
    id: 'mage',
    name: '归元真人',
    icon: '🧙',
    hp: 70,
    power: 8,
    shield: 0,
    desc: '引动雷霆，焚尽诸天。',
    skillName: '五雷正法',
    skillDesc: '对所有妖兽造成 15 点伤害。',
    passiveName: '灵力流转',
    passiveDesc: '神通充能速度提高 25%。',
  ),
];

const List<RelicConfig> relics = [
  RelicConfig(id: 'vampire', name: '狰之利牙', icon: '🧛', desc: '击败妖兽回复 3 精血。', cost: 300),
  RelicConfig(id: 'midas', name: '财神符', icon: '🪙', desc: '灵石获取量 +50%。', cost: 250),
  RelicConfig(id: 'stone', name: '玄武之心', icon: '🗿', desc: '每层开始时 +15 护身。', cost: 200),
  RelicConfig(id: 'luck', name: '青鸾之羽', icon: '🐰', desc: '神通充能速度提高 50%。', cost: 180),
  RelicConfig(id: 'sharp', name: '砥砺石', icon: '🔪', desc: '立即获得 +2 战力。', cost: 150),
  RelicConfig(id: 'vitality', name: '长生珠', icon: '🔮', desc: '立即获得 +20 精血上限。', cost: 150),
];

const List<String> monsterNames = ["狰", "狡", "蛊雕", "诸犍", "颙", "天狗", "毕方", "穷奇", "梼杌"];
const List<String> bossNames = ["夔牛", "相柳", "九尾狐", "饕餮", "混沌", "烛龙"];
const List<String> weaponNames = ["青铜剑", "鱼肠匕", "干将", "莫邪", "湛卢", "巨阙", "泰阿", "轩辕剑"];
const List<String> shieldNames = ["藤牌", "青铜盾", "精铁盾", "八卦镜", "玄武盾", "东皇钟"];
const List<String> trapNames = ["地火", "毒瘴", "捕妖索", "穿心箭"];

const Map<Rarity, Color> rarityColors = {
  Rarity.common: Color(0xFF9CA3AF), // Gray-400
  Rarity.rare: Color(0xFF60A5FA),   // Blue-400
  Rarity.epic: Color(0xFFA78BFA),   // Purple-400
  Rarity.legendary: Color(0xFFFBBF24), // Amber-400
};

const Map<Rarity, Color> rarityBgColors = {
  Rarity.common: Color(0xFF1F2937), // Gray-800
  Rarity.rare: Color(0xFF1E3A8A),   // Blue-900 (Darker)
  Rarity.epic: Color(0xFF4C1D95),   // Purple-900 (Darker)
  Rarity.legendary: Color(0xFF78350F), // Amber-900 (Darker)
};
