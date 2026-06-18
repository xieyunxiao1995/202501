/// 战斗行动数据模型（DTO）
///
/// 表示战斗中一个武将的单次行动，包含行动类型、目标、伤害和使用的技能/计谋。
class BattleActionModel {
  /// 执行行动的武将 ID
  final String generalId;

  /// 行动类型（attack/skill/tactic/buff/debuff）
  final String actionType;

  /// 目标武将 ID 列表
  final List<String> targetIds;

  /// 造成伤害值
  final int damage;

  /// 使用的技能 ID
  final String? skillId;

  /// 使用的计谋 ID
  final String? tacticId;

  const BattleActionModel({
    required this.generalId,
    required this.actionType,
    this.targetIds = const [],
    this.damage = 0,
    this.skillId,
    this.tacticId,
  });

  factory BattleActionModel.fromJson(Map<String, dynamic> json) {
    return BattleActionModel(
      generalId: json['generalId'] as String,
      actionType: json['actionType'] as String,
      targetIds: (json['targetIds'] as List<dynamic>?)
              ?.map((e) => e as String).toList() ??
          const [],
      damage: (json['damage'] as num?)?.toInt() ?? 0,
      skillId: json['skillId'] as String?,
      tacticId: json['tacticId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'generalId': generalId,
        'actionType': actionType,
        'targetIds': targetIds,
        'damage': damage,
        if (skillId != null) 'skillId': skillId,
        if (tacticId != null) 'tacticId': tacticId,
      };

  BattleActionModel copyWith({
    String? generalId,
    String? actionType,
    List<String>? targetIds,
    int? damage,
    String? skillId,
    String? tacticId,
  }) {
    return BattleActionModel(
      generalId: generalId ?? this.generalId,
      actionType: actionType ?? this.actionType,
      targetIds: targetIds ?? this.targetIds,
      damage: damage ?? this.damage,
      skillId: skillId ?? this.skillId,
      tacticId: tacticId ?? this.tacticId,
    );
  }
}
