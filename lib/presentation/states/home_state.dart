import 'package:freezed_annotation/freezed_annotation.dart';

part 'home_state.freezed.dart';

/// 主城页面状态
///
/// 管理主城页面的数据状态，包括加载、已加载和错误，
/// 以及玩家信息、资源和国家等数据。
@freezed
class HomeState with _$HomeState {
  /// 加载中
  const factory HomeState.loading() = _HomeLoading;

  /// 数据已加载
  const factory HomeState.loaded({
    /// 玩家信息
    required PlayerInfo playerInfo,

    /// 资源列表
    required Map<String, int> resources,

    /// 所属国家
    required String kingdom,
  }) = _HomeLoaded;

  /// 加载失败
  const factory HomeState.error({
    required String message,
  }) = _HomeError;
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
