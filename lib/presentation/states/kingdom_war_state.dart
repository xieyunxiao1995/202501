/// 国战状态
///
/// 管理国战玩法的全局状态，包括地图数据、城池列表和战争状态。
sealed class KingdomWarState {
  const KingdomWarState();
  const factory KingdomWarState.loading() = KingdomWarLoading;
  const factory KingdomWarState.loaded({required Map<String, dynamic> map, required List<WarCityInfo> cities, required String status}) = KingdomWarLoaded;
  const factory KingdomWarState.error({required String message}) = KingdomWarError;
}

final class KingdomWarLoading extends KingdomWarState {
  const KingdomWarLoading();
}

final class KingdomWarLoaded extends KingdomWarState {
  final Map<String, dynamic> map;
  final List<WarCityInfo> cities;
  final String status;
  const KingdomWarLoaded({required this.map, required this.cities, required this.status});
}

final class KingdomWarError extends KingdomWarState {
  final String message;
  const KingdomWarError({required this.message});
}

/// 国战城池信息
class WarCityInfo {
  /// 城池ID
  final String id;

  /// 城池名称
  final String name;

  /// 占领国家
  final String? ownerKingdom;

  const WarCityInfo({
    required this.id,
    required this.name,
    this.ownerKingdom,
  });
}
