/// 招募状态
///
/// 管理武将招募流程的状态，包括空闲、招募中和出结果等阶段，
/// 以及卡池和招募结果数据。
sealed class RecruitState {
  const RecruitState();
  const factory RecruitState.idle({required String poolId, required int freeCount}) = RecruitIdle;
  const factory RecruitState.recruiting({required String recruitType, required String poolId}) = RecruitRecruiting;
  const factory RecruitState.result({required List<String> generalIds, required Map<String, int> items, required bool isTenPull}) = RecruitResult;
  const factory RecruitState.error({required String message}) = RecruitError;
}

final class RecruitIdle extends RecruitState {
  final String poolId;
  final int freeCount;
  const RecruitIdle({required this.poolId, this.freeCount = 0});
}

final class RecruitRecruiting extends RecruitState {
  final String recruitType;
  final String poolId;
  const RecruitRecruiting({required this.recruitType, required this.poolId});
}

final class RecruitResult extends RecruitState {
  final List<String> generalIds;
  final Map<String, int> items;
  final bool isTenPull;
  const RecruitResult({required this.generalIds, required this.items, this.isTenPull = false});
}

final class RecruitError extends RecruitState {
  final String message;
  const RecruitError({required this.message});
}
