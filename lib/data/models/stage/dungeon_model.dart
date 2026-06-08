import 'package:freezed_annotation/freezed_annotation.dart';

part 'dungeon_model.freezed.dart';
part 'dungeon_model.g.dart';

/// 副本数据模型（DTO）
///
/// 表示游戏中的副本配置，包含副本名称、类型、层数和奖励等信息。
@freezed
@JsonSerializable()
class DungeonModel with _$DungeonModel {
  const factory DungeonModel({
    /// 副本唯一标识
    required String id,

    /// 副本名称
    required String name,

    /// 副本类型标识
    required String type,

    /// 当前层数
    @Default(1) int currentFloor,

    /// 最大层数
    @Default(50) int maxFloor,

    /// 每日可挑战次数
    @Default(3) int dailyLimit,

    /// 今日已挑战次数
    @Default(0) int todayCount,

    /// 是否已解锁
    @Default(false) bool unlocked,
  }) = _DungeonModel;

  factory DungeonModel.fromJson(Map<String, dynamic> json) =>
      _$DungeonModelFromJson(json);
}
