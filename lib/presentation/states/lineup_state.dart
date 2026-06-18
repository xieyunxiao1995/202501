/// 阵容状态
///
/// 管理阵容配置的状态，包括武将ID列表、阵型ID和缘分信息。
sealed class LineupState {
  const LineupState();
  const factory LineupState.loading() = LineupLoading;
  const factory LineupState.loaded({required List<String> generalIds, required String formationId, required List<String> bonds, required int presetIndex}) = LineupLoaded;
  const factory LineupState.error({required String message}) = LineupError;
}

final class LineupLoading extends LineupState {
  const LineupLoading();
}

final class LineupLoaded extends LineupState {
  final List<String> generalIds;
  final String formationId;
  final List<String> bonds;
  final int presetIndex;
  const LineupLoaded({required this.generalIds, required this.formationId, required this.bonds, this.presetIndex = 0});
}

final class LineupError extends LineupState {
  final String message;
  const LineupError({required this.message});
}
