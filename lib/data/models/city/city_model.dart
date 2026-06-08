import 'package:freezed_annotation/freezed_annotation.dart';

part 'city_model.freezed.dart';
part 'city_model.g.dart';

/// 主城数据模型（DTO）
///
/// 表示玩家主城的整体数据，包含主城名称、等级和建筑列表。
@freezed
@JsonSerializable()
class CityModel with _$CityModel {
  const factory CityModel({
    /// 主城唯一标识
    required String id,

    /// 主城名称
    required String name,

    /// 主城等级
    @Default(1) int level,

    /// 建筑 ID 列表
    @Default([]) List<String> buildingIds,
  }) = _CityModel;

  factory CityModel.fromJson(Map<String, dynamic> json) =>
      _$CityModelFromJson(json);
}
