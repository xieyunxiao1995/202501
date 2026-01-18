import '../models/enums.dart';
import '../models/soul_model.dart';

final List<Soul> allSouls = [
  // Common
  Soul(
    id: 'soul_slime',
    name: '驳之魂',
    icon: '🐎',
    description: '战斗结束后回复 1 精血。',
    effectType: SoulEffectType.regen,
    effectValue: 1.0,
    rarity: Rarity.common,
  ),
  Soul(
    id: 'soul_rat',
    name: '狌狌之魂',
    icon: '🐒',
    description: '所有来源的灵石收益 +20%。',
    effectType: SoulEffectType.goldBonus,
    effectValue: 0.2,
    rarity: Rarity.common,
  ),
  
  // Rare
  Soul(
    id: 'soul_wolf',
    name: '獓狠之魂',
    icon: '🐂',
    description: '暴击率 +15%。',
    effectType: SoulEffectType.crit,
    effectValue: 0.15,
    rarity: Rarity.rare,
  ),
  Soul(
    id: 'soul_turtle',
    name: '旋龟之魂',
    icon: '🐢',
    description: '反弹 20% 受到的伤害。',
    effectType: SoulEffectType.thorns,
    effectValue: 0.2,
    rarity: Rarity.rare,
  ),
  
  // Epic
  Soul(
    id: 'soul_vampire',
    name: '旱魃之魂',
    icon: '🔥',
    description: '吸取造成伤害的 10% 回复精血。',
    effectType: SoulEffectType.lifeSteal,
    effectValue: 0.1,
    rarity: Rarity.epic,
  ),
  Soul(
    id: 'soul_ghost',
    name: '魅影之魂',
    icon: '👻',
    description: '15% 几率闪避攻击。',
    effectType: SoulEffectType.dodge,
    effectValue: 0.15,
    rarity: Rarity.epic,
  ),

  // Legendary
  Soul(
    id: 'soul_dragon',
    name: '应龙之魂',
    icon: '🐉',
    description: '反弹 50% 伤害且暴击率 +20%。',
    effectType: SoulEffectType.reflect, // Custom complex logic might be needed, or just high reflect
    effectValue: 0.5,
    rarity: Rarity.legendary,
  ),
];
