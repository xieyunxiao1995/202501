/// 武将列表状态
///
/// 管理武将列表页面的数据状态，包括加载、已加载和错误，
/// 以及武将列表数据和筛选条件。
sealed class GeneralListState {
  const GeneralListState();
  const factory GeneralListState.loading() = GeneralListLoading;
  const factory GeneralListState.loaded({required List<GeneralItem> generals, String? filterKingdom, String? sortBy}) = GeneralListLoaded;
  const factory GeneralListState.error({required String message}) = GeneralListError;
}

final class GeneralListLoading extends GeneralListState {
  const GeneralListLoading();
}

final class GeneralListLoaded extends GeneralListState {
  final List<GeneralItem> generals;
  final String? filterKingdom;
  final String? sortBy;
  const GeneralListLoaded({required this.generals, this.filterKingdom, this.sortBy});
}

final class GeneralListError extends GeneralListState {
  final String message;
  const GeneralListError({required this.message});
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
