/// 城池状态
///
/// 管理城池页面的数据状态，包括城池信息、建筑列表和资源数据。
sealed class CityState {
  const CityState();
  const factory CityState.loading() = CityLoading;
  const factory CityState.loaded({required CityInfo city, required List<BuildingInfo> buildings, required Map<String, int> resources}) = CityLoaded;
  const factory CityState.error({required String message}) = CityError;
}

final class CityLoading extends CityState {
  const CityLoading();
}

final class CityLoaded extends CityState {
  final CityInfo city;
  final List<BuildingInfo> buildings;
  final Map<String, int> resources;
  const CityLoaded({required this.city, required this.buildings, required this.resources});
}

final class CityError extends CityState {
  final String message;
  const CityError({required this.message});
}

/// 城池信息
class CityInfo {
  /// 城池ID
  final String id;

  /// 城池名称
  final String name;

  /// 城池等级
  final int level;

  const CityInfo({
    required this.id,
    required this.name,
    required this.level,
  });
}

/// 建筑信息
class BuildingInfo {
  /// 建筑ID
  final String id;

  /// 建筑名称
  final String name;

  /// 建筑等级
  final int level;

  const BuildingInfo({
    required this.id,
    required this.name,
    required this.level,
  });
}
