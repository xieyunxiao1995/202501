import 'package:freezed_annotation/freezed_annotation.dart';

part 'pity_model.freezed.dart';
part 'pity_model.g.dart';

/// 保底数据模型（DTO）
///
/// 表示玩家在某个卡池中的保底进度，包含当前计数和保底状态。
@freezed
@JsonSerializable()
class PityModel with _$PityModel {
  const factory PityModel({
    /// 卡池 ID
    required String poolId,

    /// 当前保底计数（距上次 SSR 的抽数）
    @Default(0) int currentCount,

    /// 保底阈值
    @Default(90) int threshold,

    /// 是否触发大保底（上次 SSR 非 UP 时下次必出 UP）
    @Default(false) bool guaranteed,

    /// 距上次 SR 的抽数
    @Default(0) int srCount,

    /// SR 保底阈值
    @Default(10) int srThreshold,
  }) = _PityModel;

  factory PityModel.fromJson(Map<String, dynamic> json) =>
      _$PityModelFromJson(json);
}
