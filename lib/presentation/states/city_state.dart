import 'package:freezed_annotation/freezed_annotation.dart';

part 'city_state.freezed.dart';

/// 城池状态
///
/// 管理城池页面的数据状态，包括城池信息、建筑列表和资源数据。
@freezed
class CityState with _$CityState {
  /// 加载中
  const factory CityState.loading() = _CityLoading;

  /// 数据已加载
  const factory CityState.loaded({
    /// 城池信息
    required CityInfo city,

    /// 建筑列表
    required List<BuildingInfo> buildings,

    /// 资源数据
    required Map<String, int> resources,
  }) = _CityLoaded;

  /// 加载失败
  const factory CityState.error({
    required String message,
  }) = _CityError;
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
