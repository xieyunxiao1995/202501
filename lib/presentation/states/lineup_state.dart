import 'package:freezed_annotation/freezed_annotation.dart';

part 'lineup_state.freezed.dart';

/// 阵容状态
///
/// 管理阵容配置的状态，包括武将ID列表、阵型ID和缘分信息。
@freezed
class LineupState with _$LineupState {
  /// 加载中
  const factory LineupState.loading() = _LineupLoading;

  /// 数据已加载
  const factory LineupState.loaded({
    /// 上阵武将ID列表
    required List<String> generalIds,

    /// 阵型ID
    required String formationId,

    /// 已激活的缘分列表
    required List<String> bonds,

    /// 预设阵容索引（0-2）
    @Default(0) int presetIndex,
  }) = _LineupLoaded;

  /// 加载失败
  const factory LineupState.error({
    required String message,
  }) = _LineupError;
}
