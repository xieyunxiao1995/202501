import 'package:freezed_annotation/freezed_annotation.dart';

part 'tower_floor_model.freezed.dart';
part 'tower_floor_model.g.dart';

/// 试炼之塔层数据模型（DTO）
///
/// 表示试炼之塔中某一层的配置，包含层数、敌人和奖励信息。
@freezed
@JsonSerializable()
class TowerFloorModel with _$TowerFloorModel {
  const factory TowerFloorModel({
    /// 层唯一标识
    required String id,

    /// 层数
    required int floor,

    /// 敌方武将 ID 列表
    @Default([]) List<String> enemyGeneralIds,

    /// 推荐战力
    @Default(0) int recommendedPower,

    /// 通关奖励（物品ID -> 数量）
    @Default({}) Map<String, int> rewards,

    /// 是否已通关
    @Default(false) bool cleared,
  }) = _TowerFloorModel;

  factory TowerFloorModel.fromJson(Map<String, dynamic> json) =>
      _$TowerFloorModelFromJson(json);
}
