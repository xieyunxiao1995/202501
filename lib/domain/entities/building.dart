import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/enums/building_type.dart' as enums;

part 'building.freezed.dart';
part 'building.g.dart';

/// 建筑实体
///
/// 表示主城中的建筑，如主公殿、演武场、兵器坊等。
/// 建筑可升级，升级后产出率和属性提升。
@freezed
class Building with _$Building {
  const factory Building({
    /// 建筑唯一标识
    required String id,

    /// 建筑类型（主公殿/演武场/议事厅/兵器坊/马厩/酒馆/粮仓/铸币厂/书院/观星台/校场）
    required enums.BuildingType type,

    /// 建筑名称
    required String name,

    /// 建筑等级
    @Default(1) int level,

    /// 产出速率（每小时）
    @Default(0.0) double productionRate,

    /// 升级消耗（资源类型 -> 数量）
    @Default({}) Map<String, int> upgradeCost,

    /// 是否正在升级
    @Default(false) bool isUpgrading,

    /// 升级结束时间（时间戳），不在升级中时为空
    int? upgradeEndTime,
  }) = _Building;

  factory Building.fromJson(Map<String, dynamic> json) =>
      _$BuildingFromJson(json);
}
