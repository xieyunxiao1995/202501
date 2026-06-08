import 'package:freezed_annotation/freezed_annotation.dart';

part 'kingdom_war_state.freezed.dart';

/// 国战状态
///
/// 管理国战玩法的全局状态，包括地图数据、城池列表和战争状态。
@freezed
class KingdomWarState with _$KingdomWarState {
  /// 加载中
  const factory KingdomWarState.loading() = _KingdomWarLoading;

  /// 数据已加载
  const factory KingdomWarState.loaded({
    /// 地图数据
    required Map<String, dynamic> map,

    /// 城池列表
    required List<WarCityInfo> cities,

    /// 战争状态
    required String status,
  }) = _KingdomWarLoaded;

  /// 加载失败
  const factory KingdomWarState.error({
    required String message,
  }) = _KingdomWarError;
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
