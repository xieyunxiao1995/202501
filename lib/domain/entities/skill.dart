import '../../shared/enums/skill_type.dart' as enums;
import '../../shared/enums/buff_type.dart' as enums;

/// 技能实体
///
/// 表示武将所拥有的技能，包括普攻、战法、大招和被动技能。
/// 技能可附带 Buff 效果，并具有伤害倍率、怒气消耗等属性。
class Skill {
  /// 技能唯一标识
  final String id;

  /// 技能名称
  final String name;

  /// 技能类型（普攻/战法/大招/被动）
  final enums.SkillType type;

  /// 技能描述
  final String description;

  /// 伤害倍率
  final double damageMultiplier;

  /// 怒气消耗
  final int rageCost;

  /// 目标数量
  final int targetCount;

  /// 附带 Buff 类型，可为空
  final enums.BuffType? buffType;

  /// Buff 持续回合数
  final int buffDuration;

  /// 技能等级
  final int level;

  /// 技能最大等级
  final int maxLevel;

  const Skill({
    required this.id,
    required this.name,
    required this.type,
    this.description = '',
    this.damageMultiplier = 0.0,
    this.rageCost = 0,
    this.targetCount = 1,
    this.buffType,
    this.buffDuration = 0,
    this.level = 1,
    this.maxLevel = 10,
  });

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] != null
          ? enums.SkillType.fromJson(json['type'] as String)
          : enums.SkillType.normal,
      description: json['description'] as String? ?? '',
      damageMultiplier: (json['damageMultiplier'] as num? ?? json['damage_multiplier'] as num?)?.toDouble() ?? 0.0,
      rageCost: (json['rageCost'] as num? ?? json['rage_cost'] as num?)?.toInt() ?? 0,
      targetCount: (json['targetCount'] as num? ?? json['target_count'] as num?)?.toInt() ?? 1,
      buffType: json['buffType'] != null
          ? enums.BuffType.fromJson(json['buffType'] as String)
          : (json['buff_type'] != null
              ? enums.BuffType.fromJson(json['buff_type'] as String)
              : null),
      buffDuration: (json['buffDuration'] as num? ?? json['buff_duration'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
      maxLevel: (json['maxLevel'] as num? ?? json['max_level'] as num?)?.toInt() ?? 10,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.toJson(),
        'description': description,
        'damageMultiplier': damageMultiplier,
        'rageCost': rageCost,
        'targetCount': targetCount,
        'buffType': buffType?.toJson(),
        'buffDuration': buffDuration,
        'level': level,
        'maxLevel': maxLevel,
      };

  Skill copyWith({
    String? id,
    String? name,
    enums.SkillType? type,
    String? description,
    double? damageMultiplier,
    int? rageCost,
    int? targetCount,
    enums.BuffType? buffType,
    int? buffDuration,
    int? level,
    int? maxLevel,
  }) {
    return Skill(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      damageMultiplier: damageMultiplier ?? this.damageMultiplier,
      rageCost: rageCost ?? this.rageCost,
      targetCount: targetCount ?? this.targetCount,
      buffType: buffType ?? this.buffType,
      buffDuration: buffDuration ?? this.buffDuration,
      level: level ?? this.level,
      maxLevel: maxLevel ?? this.maxLevel,
    );
  }
}
