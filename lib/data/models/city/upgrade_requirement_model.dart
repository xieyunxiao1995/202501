/// 升级需求数据模型（DTO）
///
/// 表示建筑升级所需的资源和前置条件。
class UpgradeRequirementModel {
  /// 目标建筑 ID
  final String buildingId;

  /// 目标等级
  final int targetLevel;

  /// 所需资源（资源类型 -> 数量）
  final Map<String, int> resources;

  /// 所需主城最低等级
  final int requiredCityLevel;

  /// 升级耗时（秒）
  final int durationSeconds;

  /// 前置建筑条件（建筑ID -> 最低等级）
  final Map<String, int> prerequisiteBuildings;

  const UpgradeRequirementModel({
    required this.buildingId,
    required this.targetLevel,
    this.resources = const {},
    this.requiredCityLevel = 1,
    this.durationSeconds = 0,
    this.prerequisiteBuildings = const {},
  });

  factory UpgradeRequirementModel.fromJson(Map<String, dynamic> json) {
    return UpgradeRequirementModel(
      buildingId: json['buildingId'] as String,
      targetLevel: (json['targetLevel'] as num?)?.toInt() ?? 1,
      resources: (json['resources'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toInt())) ??
          const {},
      requiredCityLevel: (json['requiredCityLevel'] as num?)?.toInt() ?? 1,
      durationSeconds: (json['durationSeconds'] as num?)?.toInt() ?? 0,
      prerequisiteBuildings: (json['prerequisiteBuildings'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toInt())) ??
          const {},
    );
  }

  Map<String, dynamic> toJson() => {
        'buildingId': buildingId,
        'targetLevel': targetLevel,
        'resources': resources,
        'requiredCityLevel': requiredCityLevel,
        'durationSeconds': durationSeconds,
        'prerequisiteBuildings': prerequisiteBuildings,
      };

  UpgradeRequirementModel copyWith({
    String? buildingId,
    int? targetLevel,
    Map<String, int>? resources,
    int? requiredCityLevel,
    int? durationSeconds,
    Map<String, int>? prerequisiteBuildings,
  }) {
    return UpgradeRequirementModel(
      buildingId: buildingId ?? this.buildingId,
      targetLevel: targetLevel ?? this.targetLevel,
      resources: resources ?? this.resources,
      requiredCityLevel: requiredCityLevel ?? this.requiredCityLevel,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      prerequisiteBuildings: prerequisiteBuildings ?? this.prerequisiteBuildings,
    );
  }
}
