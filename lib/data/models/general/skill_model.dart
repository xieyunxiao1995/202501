/// 技能数据模型（DTO）
///
/// 表示武将技能的配置数据，包含技能类型、描述、伤害倍率、怒气消耗和目标数量等。
class SkillModel {
  /// 技能唯一标识
  final String id;

  /// 技能名称
  final String name;

  /// 技能类型标识（normal/active/ultimate/passive）
  final String type;

  /// 技能描述
  final String? description;

  /// 伤害倍率（百分比）
  final double damageMultiplier;

  /// 怒气消耗
  final int rageCost;

  /// 目标数量
  final int targetCount;

  /// 技能等级
  final int level;

  const SkillModel({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    this.damageMultiplier = 0,
    this.rageCost = 0,
    this.targetCount = 1,
    this.level = 1,
  });

  factory SkillModel.fromJson(Map<String, dynamic> json) {
    return SkillModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String?,
      damageMultiplier: (json['damageMultiplier'] as num?)?.toDouble() ?? 0,
      rageCost: (json['rageCost'] as num?)?.toInt() ?? 0,
      targetCount: (json['targetCount'] as num?)?.toInt() ?? 1,
      level: (json['level'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'damageMultiplier': damageMultiplier,
      'rageCost': rageCost,
      'targetCount': targetCount,
      'level': level,
    };
  }

  SkillModel copyWith({
    String? id,
    String? name,
    String? type,
    String? description,
    double? damageMultiplier,
    int? rageCost,
    int? targetCount,
    int? level,
  }) {
    return SkillModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      damageMultiplier: damageMultiplier ?? this.damageMultiplier,
      rageCost: rageCost ?? this.rageCost,
      targetCount: targetCount ?? this.targetCount,
      level: level ?? this.level,
    );
  }
}
