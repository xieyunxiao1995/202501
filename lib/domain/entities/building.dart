import '../../shared/enums/building_type.dart' as enums;

/// 建筑实体
///
/// 表示主城中的建筑，如主公殿、演武场、兵器坊等。
/// 建筑可升级，升级后产出率和属性提升。
class Building {
  /// 建筑唯一标识
  final String id;

  /// 建筑类型（主公殿/演武场/议事厅/兵器坊/马厩/酒馆/粮仓/铸币厂/书院/观星台/校场）
  final enums.BuildingType type;

  /// 建筑名称
  final String name;

  /// 建筑等级
  final int level;

  /// 产出速率（每小时）
  final double productionRate;

  /// 升级消耗（资源类型 -> 数量）
  final Map<String, int> upgradeCost;

  /// 是否正在升级
  final bool isUpgrading;

  /// 升级结束时间（时间戳），不在升级中时为空
  final int? upgradeEndTime;

  const Building({
    required this.id,
    required this.type,
    required this.name,
    this.level = 1,
    this.productionRate = 0.0,
    this.upgradeCost = const {},
    this.isUpgrading = false,
    this.upgradeEndTime,
  });

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      id: json['id'] as String,
      type: json['type'] != null
          ? enums.BuildingType.fromJson(json['type'] as String)
          : enums.BuildingType.lordHall,
      name: json['name'] as String,
      level: (json['level'] as num?)?.toInt() ?? 1,
      productionRate: (json['productionRate'] as num? ?? json['production_rate'] as num?)?.toDouble() ?? 0.0,
      upgradeCost: (json['upgradeCost'] as Map<String, dynamic>? ?? json['upgrade_cost'] as Map<String, dynamic>?)
              ?.map((k, v) => MapEntry(k, (v as num).toInt())) ??
          const {},
      isUpgrading: json['isUpgrading'] as bool? ?? json['is_upgrading'] as bool? ?? false,
      upgradeEndTime: (json['upgradeEndTime'] as num? ?? json['upgrade_end_time'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.toJson(),
        'name': name,
        'level': level,
        'productionRate': productionRate,
        'upgradeCost': upgradeCost,
        'isUpgrading': isUpgrading,
        'upgradeEndTime': upgradeEndTime,
      };

  Building copyWith({
    String? id,
    enums.BuildingType? type,
    String? name,
    int? level,
    double? productionRate,
    Map<String, int>? upgradeCost,
    bool? isUpgrading,
    int? upgradeEndTime,
  }) {
    return Building(
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      level: level ?? this.level,
      productionRate: productionRate ?? this.productionRate,
      upgradeCost: upgradeCost ?? this.upgradeCost,
      isUpgrading: isUpgrading ?? this.isUpgrading,
      upgradeEndTime: upgradeEndTime ?? this.upgradeEndTime,
    );
  }
}

