import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/general_list_state.dart';

/// 武将详情 ViewModel Provider
final generalDetailViewModelProvider =
    NotifierProvider<GeneralDetailViewModel, GeneralListState>(
  GeneralDetailViewModel.new,
);

/// 武将详情 ViewModel
///
/// 管理单个武将的详细信息，包括属性、技能、装备和缘分。
class GeneralDetailViewModel extends Notifier<GeneralListState> {
  @override
  GeneralListState build() => const GeneralListState.loading();

  /// 加载武将详情
  Future<void> loadGeneralDetail(String generalId) async {
    // TODO: 实现加载武将详情逻辑
  }

  /// 升级武将
  Future<void> upgradeGeneral(String generalId) async {
    // TODO: 实现升级逻辑
  }

  /// 进阶武将
  Future<void> evolveGeneral(String generalId) async {
    // TODO: 实现进阶逻辑
  }

  /// 觉醒武将
  Future<void> awakeGeneral(String generalId) async {
    // TODO: 实现觉醒逻辑
  }

  /// 升星武将
  Future<void> starUpGeneral(String generalId) async {
    // TODO: 实现升星逻辑
  }
}
