/// 阵法数据模型（DTO）
///
/// 表示战斗阵法配置，包含阵法类型、名称、站位和属性加成。
class FormationModel {
  /// 阵法唯一标识
  final String id;

  /// 阵法类型标识
  final String type;

  /// 阵法名称
  final String name;

  /// 站位配置（位置索引 -> 武将ID）
  final Map<int, String> positions;

  /// 属性加成列表
  final Map<String, double> bonuses;

  const FormationModel({
    required this.id,
    required this.type,
    required this.name,
    this.positions = const {},
    this.bonuses = const {},
  });

  factory FormationModel.fromJson(Map<String, dynamic> json) {
    return FormationModel(
      id: json['id'] as String,
      type: json['type'] as String,
      name: json['name'] as String,
      positions: (json['positions'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(int.parse(k), v as String)) ??
          const {},
      bonuses: (json['bonuses'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toDouble())) ??
          const {},
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'name': name,
        'positions': positions.map((k, v) => MapEntry(k.toString(), v)),
        'bonuses': bonuses,
      };

  FormationModel copyWith({
    String? id,
    String? type,
    String? name,
    Map<int, String>? positions,
    Map<String, double>? bonuses,
  }) {
    return FormationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      positions: positions ?? this.positions,
      bonuses: bonuses ?? this.bonuses,
    );
  }
}
