import 'package:freezed_annotation/freezed_annotation.dart';

part 'recruit_state.freezed.dart';

/// 招募状态
///
/// 管理武将招募流程的状态，包括空闲、招募中和出结果等阶段，
/// 以及卡池和招募结果数据。
@freezed
class RecruitState with _$RecruitState {
  /// 空闲状态
  const factory RecruitState.idle({
    /// 当前卡池ID
    required String poolId,

    /// 免费次数剩余
    @Default(0) int freeCount,
  }) = _RecruitIdle;

  /// 招募进行中
  const factory RecruitState.recruiting({
    /// 招募类型（单抽/十连）
    required String recruitType,

    /// 卡池ID
    required String poolId,
  }) = _Recruiting;

  /// 招募结果
  const factory RecruitState.result({
    /// 获得的武将ID列表
    required List<String> generalIds,

    /// 获得的物品列表
    required Map<String, int> items,

    /// 是否为十连结果
    @Default(false) bool isTenPull,
  }) = _RecruitResult;

  /// 招募失败
  const factory RecruitState.error({
    required String message,
  }) = _RecruitError;
}
