import 'package:freezed_annotation/freezed_annotation.dart';

part 'upgrade_requirement_model.freezed.dart';
part 'upgrade_requirement_model.g.dart';

/// 升级需求数据模型（DTO）
///
/// 表示建筑升级所需的资源和前置条件。
@freezed
@JsonSerializable()
class UpgradeRequirementModel with _$UpgradeRequirementModel {
  const factory UpgradeRequirementModel({
    /// 目标建筑 ID
    required String buildingId,

    /// 目标等级
    required int targetLevel,

    /// 所需资源（资源类型 -> 数量）
    @Default({}) Map<String, int> resources,

    /// 所需主城最低等级
    @Default(1) int requiredCityLevel,

    /// 升级耗时（秒）
    @Default(0) int durationSeconds,

    /// 前置建筑条件（建筑ID -> 最低等级）
    @Default({}) Map<String, int> prerequisiteBuildings,
  }) = _UpgradeRequirementModel;

  factory UpgradeRequirementModel.fromJson(Map<String, dynamic> json) =>
      _$UpgradeRequirementModelFromJson(json);
}
