import 'package:freezed_annotation/freezed_annotation.dart';

part 'general_list_state.freezed.dart';

/// 武将列表状态
///
/// 管理武将列表页面的数据状态，包括加载、已加载和错误，
/// 以及武将列表数据和筛选条件。
@freezed
class GeneralListState with _$GeneralListState {
  /// 加载中
  const factory GeneralListState.loading() = _GeneralListLoading;

  /// 数据已加载
  const factory GeneralListState.loaded({
    /// 武将列表
    required List<GeneralItem> generals,

    /// 当前筛选阵营
    String? filterKingdom,

    /// 当前排序方式
    String? sortBy,
  }) = _GeneralListLoaded;

  /// 加载失败
  const factory GeneralListState.error({
    required String message,
  }) = _GeneralListError;
}

/// 武将列表项
class GeneralItem {
  /// 武将ID
  final String id;

  /// 武将名称
  final String name;

  /// 稀有度
  final int rarity;

  /// 阵营
  final String kingdom;

  /// 等级
  final int level;

  const GeneralItem({
    required this.id,
    required this.name,
    required this.rarity,
    required this.kingdom,
    required this.level,
  });
}
