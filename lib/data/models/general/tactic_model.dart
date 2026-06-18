/// 计谋数据模型（DTO）
///
/// 表示武将可使用的计谋配置数据，包含计谋类型、触发条件、效果值和冷却时间等。
class TacticModel {
  /// 计谋唯一标识
  final String id;

  /// 计谋名称
  final String name;

  /// 计谋类型标识
  final String type;

  /// 计谋描述
  final String? description;

  /// 触发条件描述
  final String? triggerCondition;

  /// 效果值
  final double effectValue;

  /// 冷却回合数
  final int cooldown;

  const TacticModel({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    this.triggerCondition,
    this.effectValue = 0,
    this.cooldown = 0,
  });

  factory TacticModel.fromJson(Map<String, dynamic> json) {
    return TacticModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      description: json['description'] as String?,
      triggerCondition: json['triggerCondition'] as String?,
      effectValue: (json['effectValue'] as num?)?.toDouble() ?? 0,
      cooldown: (json['cooldown'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'description': description,
      'triggerCondition': triggerCondition,
      'effectValue': effectValue,
      'cooldown': cooldown,
    };
  }

  TacticModel copyWith({
    String? id,
    String? name,
    String? type,
    String? description,
    String? triggerCondition,
    double? effectValue,
    int? cooldown,
  }) {
    return TacticModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      triggerCondition: triggerCondition ?? this.triggerCondition,
      effectValue: effectValue ?? this.effectValue,
      cooldown: cooldown ?? this.cooldown,
    );
  }
}
