import 'package:freezed_annotation/freezed_annotation.dart';

part 'building_model.freezed.dart';
part 'building_model.g.dart';

/// 建筑数据模型（DTO）
///
/// 表示主城中的建筑配置，包含建筑类型、等级和产出信息。
@freezed
@JsonSerializable()
class BuildingModel with _$BuildingModel {
  const factory BuildingModel({
    /// 建筑唯一标识
    required String id,

    /// 建筑名称
    required String name,

    /// 建筑类型标识
    required String type,

    /// 建筑等级
    @Default(1) int level,

    /// 最大等级
    @Default(20) int maxLevel,

    /// 是否正在升级
    @Default(false) bool upgrading,

    /// 升级剩余时间（秒）
    @Default(0) int upgradeRemainingSeconds,
  }) = _BuildingModel;

  factory BuildingModel.fromJson(Map<String, dynamic> json) =>
      _$BuildingModelFromJson(json);
}
