import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/app_state.dart';

/// 商店 ViewModel Provider
final shopViewModelProvider =
    NotifierProvider<ShopViewModel, AppState>(
  ShopViewModel.new,
);

/// 商店 ViewModel
///
/// 管理商店功能，包括商品列表、购买和充值。
class ShopViewModel extends Notifier<AppState> {
  @override
  AppState build() => const AppState.initialized();

  /// 加载商店数据
  Future<void> loadShopData() async {
    // TODO: 实现加载商店数据逻辑
  }

  /// 购买商品
  Future<void> purchaseItem({
    required String itemId,
    required int quantity,
  }) async {
    // TODO: 实现购买逻辑
  }

  /// 刷新商店
  Future<void> refreshShop() async {
    // TODO: 实现刷新商店逻辑
  }
}
