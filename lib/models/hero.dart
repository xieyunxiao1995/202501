import 'faction.dart';
import 'rarity.dart';

/// 英雄职业枚举
enum HeroClass {
  warrior,
  mage,
  assassin,
  guardian,
  archer,
  support,
}

/// 英雄模板数据类（卡池中的原始数据）
class HeroTemplate {
  final String id;
  final String name;
  final String title;
  final RarityType rarity;
  final FactionType faction;
  final HeroClass heroClass;
  final int baseHp;
  final int baseAtk;
  final int baseDef;
  final int baseSpd;
  final List<String> skills;
  final String image; // 英雄图片路径

  const HeroTemplate({
    required this.id,
    required this.name,
    required this.title,
    required this.rarity,
    required this.faction,
    required this.heroClass,
    required this.baseHp,
    required this.baseAtk,
    required this.baseDef,
    required this.baseSpd,
    required this.skills,
    this.image = '', // 默认空字符串
  });

  /// 从 JSON 创建英雄模板
  factory HeroTemplate.fromJson(Map<String, dynamic> json) {
    return HeroTemplate(
      id: json['id'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      rarity: RarityType.values.firstWhere(
        (e) => e.name == json['rarity'],
        orElse: () => RarityType.R,
      ),
      faction: FactionType.values.firstWhere(
        (e) => e.name == json['faction'],
        orElse: () => FactionType.fire,
      ),
      heroClass: HeroClass.values.firstWhere(
        (e) => e.name == json['class'],
        orElse: () => HeroClass.warrior,
      ),
      baseHp: json['baseHp'] as int,
      baseAtk: json['baseAtk'] as int,
      baseDef: json['baseDef'] as int,
      baseSpd: json['baseSpd'] as int,
      skills: (json['skills'] as List).cast<String>(),
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'title': title,
      'rarity': rarity.name,
      'faction': faction.name,
      'class': heroClass.name,
      'baseHp': baseHp,
      'baseAtk': baseAtk,
      'baseDef': baseDef,
      'baseSpd': baseSpd,
      'skills': skills,
    };
  }

  /// 创建初始属性的英雄实例
  Hero createInstance({
    required String uid,
    int level = 1,
    int stars = 3,
    String image = '',
  }) {
    return Hero(
      uid: uid,
      templateId: id,
      name: name,
      title: title,
      rarity: rarity,
      faction: faction,
      heroClass: heroClass,
      level: level,
      stars: stars,
      hp: baseHp,
      atk: baseAtk,
      def: baseDef,
      spd: baseSpd,
      skills: skills,
      image: image.isEmpty ? this.image : image,
    );
  }
}

/// 英雄实例数据类（玩家库存中的英雄）
class Hero {
  final String uid;
  final String templateId;
  final String name;
  final String title;
  final RarityType rarity;
  final FactionType faction;
  final HeroClass heroClass;
  int level;
  int stars;
  int hp;
  int atk;
  int def;
  int spd;
  final List<String> skills;
  final String image; // 英雄图片路径

  Hero({
    required this.uid,
    required this.templateId,
    required this.name,
    required this.title,
    required this.rarity,
    required this.faction,
    required this.heroClass,
    required this.level,
    required this.stars,
    required this.hp,
    required this.atk,
    required this.def,
    required this.spd,
    required this.skills,
    this.image = '', // 默认空字符串
  });

  /// 计算战斗力
  int get combatPower {
    return (hp * 0.5 + atk * 2 + def * 2 + spd * 5).floor();
  }

  /// 从 JSON 创建英雄实例
  factory Hero.fromJson(Map<String, dynamic> json) {
    return Hero(
      uid: json['uid'] as String,
      templateId: json['templateId'] as String,
      name: json['name'] as String,
      title: json['title'] as String,
      rarity: RarityType.values.firstWhere(
        (e) => e.name == json['rarity'],
        orElse: () => RarityType.R,
      ),
      faction: FactionType.values.firstWhere(
        (e) => e.name == json['faction'],
        orElse: () => FactionType.fire,
      ),
      heroClass: HeroClass.values.firstWhere(
        (e) => e.name == json['heroClass'],
        orElse: () => HeroClass.warrior,
      ),
      level: json['level'] as int,
      stars: json['stars'] as int,
      hp: json['hp'] as int,
      atk: json['atk'] as int,
      def: json['def'] as int,
      spd: json['spd'] as int,
      skills: (json['skills'] as List).cast<String>(),
      image: json['image'] as String? ?? '',
    );
  }

  /// 转换为 JSON
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'templateId': templateId,
      'name': name,
      'title': title,
      'rarity': rarity.name,
      'faction': faction.name,
      'heroClass': heroClass.name,
      'level': level,
      'stars': stars,
      'hp': hp,
      'atk': atk,
      'def': def,
      'spd': spd,
      'skills': skills,
      'image': image,
    };
  }

  /// 复制并修改英雄
  Hero copyWith({
    String? uid,
    String? templateId,
    String? name,
    String? title,
    RarityType? rarity,
    FactionType? faction,
    HeroClass? heroClass,
    int? level,
    int? stars,
    int? hp,
    int? atk,
    int? def,
    int? spd,
    List<String>? skills,
    String? image,
  }) {
    return Hero(
      uid: uid ?? this.uid,
      templateId: templateId ?? this.templateId,
      name: name ?? this.name,
      title: title ?? this.title,
      rarity: rarity ?? this.rarity,
      faction: faction ?? this.faction,
      heroClass: heroClass ?? this.heroClass,
      level: level ?? this.level,
      stars: stars ?? this.stars,
      hp: hp ?? this.hp,
      atk: atk ?? this.atk,
      def: def ?? this.def,
      spd: spd ?? this.spd,
      skills: skills ?? this.skills,
      image: image ?? this.image,
    );
  }
}
