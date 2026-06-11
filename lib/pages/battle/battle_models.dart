import 'dart:math';

/// 卡牌类型
enum CardType { attack, skill, power }

/// 卡牌数据
class CardData {
  const CardData({
    required this.id,
    required this.name,
    required this.type,
    required this.cost,
    this.damage = 0,
    this.block = 0,
  });

  final String id;
  final String name;
  final CardType type;
  final int cost;
  final int damage;
  final int block;
}

/// 初始牌组
const starterCards = <CardData>[
  CardData(id: 'slash', name: '斩击', type: CardType.attack, cost: 1, damage: 6),
  CardData(id: 'heavy', name: '重击', type: CardType.attack, cost: 2, damage: 12),
  CardData(id: 'defend', name: '防御', type: CardType.skill, cost: 1, block: 5),
  CardData(id: 'shield', name: '铁壁', type: CardType.skill, cost: 2, block: 10),
  CardData(id: 'warcry', name: '战吼', type: CardType.power, cost: 1),
];

/// 敌人模板数据
class EnemyData {
  const EnemyData({required this.name, required this.maxHealth});

  final String name;
  final int maxHealth;
}

/// 初始敌人池
const starterEnemies = <EnemyData>[
  EnemyData(name: '黄巾贼', maxHealth: 30),
  EnemyData(name: '山贼', maxHealth: 28),
  EnemyData(name: '西凉兵', maxHealth: 35),
  EnemyData(name: '水贼', maxHealth: 26),
  EnemyData(name: '盗匪', maxHealth: 32),
  EnemyData(name: '蛮族兵', maxHealth: 38),
  EnemyData(name: '流寇', maxHealth: 24),
  EnemyData(name: '叛军', maxHealth: 34),
];

/// 英雄战斗数据（运行时状态）
class HeroData {
  HeroData({required this.name, required this.maxHp})
    : hp = maxHp;

  final String name;
  final int maxHp;
  int hp;
  int block = 0;
  int strength = 0;

  bool get isAlive => hp > 0;

  int attackPower(int baseDamage) => baseDamage + strength;

  void takeDamage(int amount) {
    if (amount <= 0) return;
    if (block > 0) {
      final absorbed = min(block, amount);
      block -= absorbed;
      amount -= absorbed;
    }
    hp = max(0, hp - amount);
  }

  void addBlock(int amount) {
    block += amount;
  }

  void addStrength(int amount) {
    strength += amount;
  }

  void resetBlock() {
    block = 0;
  }

  void onTurnStart() {
    // 回合开始时重置（strength 保持）
  }
}

/// 敌方战斗数据（运行时状态）
class BattleEnemy {
  BattleEnemy({required this.name, required this.maxHp})
    : hp = maxHp;

  final String name;
  final int maxHp;
  int hp;
  int block = 0;
  int intendedDamage = 0;
  int strength = 0;

  bool get isAlive => hp > 0;

  void setIntent({required int damage}) {
    intendedDamage = damage + strength;
  }

  int attackPower(int base) => base + strength;

  void takeDamage(int amount) {
    if (amount <= 0) return;
    if (block > 0) {
      final absorbed = min(block, amount);
      block -= absorbed;
      amount -= absorbed;
    }
    hp = max(0, hp - amount);
  }

  void resetBlock() {
    block = 0;
  }
}
