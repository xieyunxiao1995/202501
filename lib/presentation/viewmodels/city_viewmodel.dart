import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/city_state.dart';

/// 城池 ViewModel Provider
final cityViewModelProvider =
    NotifierProvider<CityViewModel, CityState>(
  CityViewModel.new,
);

/// 城池 ViewModel
///
/// 管理城池页面的数据和交互，包括建筑操作、资源采集和科技研究。
class CityViewModel extends Notifier<CityState> {
  @override
  CityState build() => const CityState.loading();

  /// 加载城池数据
  Future<void> loadCityData() async {
    // TODO: 实现加载城池数据逻辑
  }

  /// 升级建筑
  Future<void> upgradeBuilding(String buildingId) async {
    // TODO: 实现升级建筑逻辑
  }

  /// 收集资源
  Future<void> collectResources(String buildingId) async {
    // TODO: 实现收集资源逻辑
  }

  /// 一键收集所有资源
  Future<void> collectAllResources() async {
    // TODO: 实现一键收集逻辑
  }

  /// 研究科技
  Future<void> researchTech(String techId) async {
    // TODO: 实现研究科技逻辑
  }
}
