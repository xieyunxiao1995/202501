import '../../shared/enums/tactic_type.dart' as enums;

/// 计谋实体
///
/// 表示武将可使用的计谋，如火攻、水攻、空城计等。
/// 计谋在战斗中由特定条件触发，产生持续性效果。
class Tactic {
  /// 计谋唯一标识
  final String id;

  /// 计谋名称
  final String name;

  /// 计谋类型（火攻/水攻/空城计/离间计/苦肉计/借刀杀人/诱敌深入/声东击西）
  final enums.TacticType type;

  /// 计谋描述
  final String description;

  /// 触发条件
  final String triggerCondition;

  /// 效果数值
  final double effectValue;

  /// 持续回合数
  final int duration;

  /// 冷却回合数
  final int cooldown;

  /// 计谋等级
  final int level;

  const Tactic({
    required this.id,
    required this.name,
    required this.type,
    this.description = '',
    this.triggerCondition = '',
    this.effectValue = 0.0,
    this.duration = 0,
    this.cooldown = 0,
    this.level = 1,
  });

  factory Tactic.fromJson(Map<String, dynamic> json) {
    return Tactic(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] != null
          ? enums.TacticType.fromJson(json['type'] as String)
          : enums.TacticType.fireAttack,
      description: json['description'] as String? ?? '',
      triggerCondition: json['triggerCondition'] as String? ?? json['trigger_condition'] as String? ?? '',
      effectValue: (json['effectValue'] as num? ?? json['effect_value'] as num?)?.toDouble() ?? 0.0,
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      cooldown: (json['cooldown'] as num?)?.toInt() ?? 0,
      level: (json['level'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type.toJson(),
        'description': description,
        'triggerCondition': triggerCondition,
        'effectValue': effectValue,
        'duration': duration,
        'cooldown': cooldown,
        'level': level,
      };

  Tactic copyWith({
    String? id,
    String? name,
    enums.TacticType? type,
    String? description,
    String? triggerCondition,
    double? effectValue,
    int? duration,
    int? cooldown,
    int? level,
  }) {
    return Tactic(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      triggerCondition: triggerCondition ?? this.triggerCondition,
      effectValue: effectValue ?? this.effectValue,
      duration: duration ?? this.duration,
      cooldown: cooldown ?? this.cooldown,
      level: level ?? this.level,
    );
  }
}
