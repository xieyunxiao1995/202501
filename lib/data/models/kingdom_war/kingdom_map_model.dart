import 'package:freezed_annotation/freezed_annotation.dart';

part 'kingdom_map_model.freezed.dart';
part 'kingdom_map_model.g.dart';

/// 国战地图数据模型（DTO）
///
/// 表示国战中的全局地图数据，包含地图节点和城池信息。
@freezed
@JsonSerializable()
class KingdomMapModel with _$KingdomMapModel {
  const factory KingdomMapModel({
    /// 地图唯一标识
    required String id,

    /// 地图名称
    required String name,

    /// 城池节点 ID 列表
    @Default([]) List<String> cityNodeIds,

    /// 赛季编号
    required int season,
  }) = _KingdomMapModel;

  factory KingdomMapModel.fromJson(Map<String, dynamic> json) =>
      _$KingdomMapModelFromJson(json);
}
