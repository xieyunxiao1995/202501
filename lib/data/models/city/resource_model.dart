import 'package:freezed_annotation/freezed_annotation.dart';

part 'resource_model.freezed.dart';
part 'resource_model.g.dart';

/// 资源数据模型（DTO）
///
/// 表示玩家拥有的各类资源数量，如粮食、金币、木材、铁矿等。
@freezed
@JsonSerializable()
class ResourceModel with _$ResourceModel {
  const factory ResourceModel({
    /// 资源类型标识
    required String type,

    /// 当前数量
    @Default(0) int amount,

    /// 上限（0表示无上限）
    @Default(0) int capacity,

    /// 每小时产量
    @Default(0) int productionPerHour,
  }) = _ResourceModel;

  factory ResourceModel.fromJson(Map<String, dynamic> json) =>
      _$ResourceModelFromJson(json);
}
