import 'package:freezed_annotation/freezed_annotation.dart';

part 'city_node_model.freezed.dart';
part 'city_node_model.g.dart';

/// 城池节点数据模型（DTO）
///
/// 表示国战地图上的一个城池节点，包含城池归属、防御和驻军信息。
@freezed
@JsonSerializable()
class CityNodeModel with _$CityNodeModel {
  const factory CityNodeModel({
    /// 城池唯一标识
    required String id,

    /// 城池名称
    required String name,

    /// 当前归属阵营（neutral/wei/shu/wu）
    @Default('neutral') String owner,

    /// 城池等级
    @Default(1) int level,

    /// 防御值
    @Default(100) int defense,

    /// 驻军武将 ID 列表
    @Default([]) List<String> garrisonGeneralIds,

    /// 相邻城池 ID 列表
    @Default([]) List<String> adjacentCityIds,

    /// 坐标 X
    @Default(0) int posX,

    /// 坐标 Y
    @Default(0) int posY,
  }) = _CityNodeModel;

  factory CityNodeModel.fromJson(Map<String, dynamic> json) =>
      _$CityNodeModelFromJson(json);
}
