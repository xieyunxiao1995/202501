/// 主城页面状态
///
/// 管理主城页面的数据状态，包括加载、已加载和错误，
/// 以及玩家信息、资源和国家等数据。
sealed class HomeState {
  const HomeState();
  const factory HomeState.loading() = HomeLoading;
  const factory HomeState.loaded({required PlayerInfo playerInfo, required Map<String, int> resources, required String kingdom}) = HomeLoaded;
  const factory HomeState.error({required String message}) = HomeError;
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  final PlayerInfo playerInfo;
  final Map<String, int> resources;
  final String kingdom;
  const HomeLoaded({required this.playerInfo, required this.resources, required this.kingdom});
}

final class HomeError extends HomeState {
  final String message;
  const HomeError({required this.message});
}

/// 玩家基础信息
class PlayerInfo {
  /// 玩家ID
  final String id;

  /// 玩家昵称
  final String name;

  /// 玩家等级
  final int level;

  /// 玩家经验值
  final int exp;

  const PlayerInfo({
    required this.id,
    required this.name,
    required this.level,
    required this.exp,
  });
}
