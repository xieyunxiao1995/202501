import '../../core/network/api_result.dart';
import '../entities/item.dart';

/// 商店仓库接口
///
/// 提供商店相关操作，包括商品查询、购买、充值和月卡领取。
abstract class IShopRepository {
  /// 获取商品列表
  ///
  /// 获取商店中可购买的商品列表，按分类展示。
  Future<ApiResult<List<Map<String, dynamic>>>> getShopList();

  /// 购买商品
  ///
  /// 购买指定 [itemId] 的商品，[quantity] 为购买数量。
  Future<ApiResult<Item>> purchaseItem(String itemId, {int quantity = 1});

  /// 充值
  ///
  /// 发起充值请求，[productId] 为充值商品 ID。
  Future<ApiResult<Map<String, dynamic>>> recharge(String productId);

  /// 领取月卡奖励
  ///
  /// 领取当日月卡奖励，需已购买月卡。
  Future<ApiResult<Map<String, int>>> claimMonthlyCard();
}
