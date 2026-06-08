import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/general_list_state.dart';

/// 武将列表 ViewModel Provider
final generalListViewModelProvider =
    NotifierProvider<GeneralListViewModel, GeneralListState>(
  GeneralListViewModel.new,
);

/// 武将列表 ViewModel
///
/// 管理武将列表的数据加载、筛选和排序功能。
class GeneralListViewModel extends Notifier<GeneralListState> {
  @override
  GeneralListState build() => const GeneralListState.loading();

  /// 加载武将列表
  Future<void> loadGenerals() async {
    // TODO: 实现加载逻辑
  }

  /// 按阵营筛选
  void filterByKingdom(String kingdom) {
    // TODO: 实现筛选逻辑
  }

  /// 按稀有度排序
  void sortByRarity() {
    // TODO: 实现排序逻辑
  }

  /// 按等级排序
  void sortByLevel() {
    // TODO: 实现排序逻辑
  }

  /// 清除筛选条件
  void clearFilter() {
    // TODO: 实现清除筛选逻辑
  }
}
