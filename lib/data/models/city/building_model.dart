/// 建筑数据模型（DTO）
///
/// 表示主城中的建筑配置，包含建筑类型、等级和产出信息。
class BuildingModel {
  /// 建筑唯一标识
  final String id;

  /// 建筑名称
  final String name;

  /// 建筑类型标识
  final String type;

  /// 建筑等级
  final int level;

  /// 最大等级
  final int maxLevel;

  /// 是否正在升级
  final bool upgrading;

  /// 升级剩余时间（秒）
  final int upgradeRemainingSeconds;

  const BuildingModel({
    required this.id,
    required this.name,
    required this.type,
    this.level = 1,
    this.maxLevel = 20,
    this.upgrading = false,
    this.upgradeRemainingSeconds = 0,
  });

  factory BuildingModel.fromJson(Map<String, dynamic> json) {
    return BuildingModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      level: (json['level'] as num?)?.toInt() ?? 1,
      maxLevel: (json['maxLevel'] as num?)?.toInt() ?? 20,
      upgrading: json['upgrading'] as bool? ?? false,
      upgradeRemainingSeconds: (json['upgradeRemainingSeconds'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'level': level,
        'maxLevel': maxLevel,
        'upgrading': upgrading,
        'upgradeRemainingSeconds': upgradeRemainingSeconds,
      };

  BuildingModel copyWith({
    String? id,
    String? name,
    String? type,
    int? level,
    int? maxLevel,
    bool? upgrading,
    int? upgradeRemainingSeconds,
  }) {
    return BuildingModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      level: level ?? this.level,
      maxLevel: maxLevel ?? this.maxLevel,
      upgrading: upgrading ?? this.upgrading,
      upgradeRemainingSeconds: upgradeRemainingSeconds ?? this.upgradeRemainingSeconds,
    );
  }
}
