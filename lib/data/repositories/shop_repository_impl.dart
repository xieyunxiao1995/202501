import 'package:injectable/injectable.dart';
import '../../core/network/api_result.dart';
import '../../domain/entities/item.dart';
import '../../domain/repositories/i_shop_repository.dart';
import '../datasources/remote/shop_api.dart';

/// 商店仓库实现
///
/// 实现商店相关业务逻辑，协调远程 API，
/// 处理商品查询、购买、充值和月卡领取等操作。
@LazySingleton(as: IShopRepository)
class ShopRepositoryImpl implements IShopRepository {
  final ShopApi _shopApi;

  ShopRepositoryImpl(this._shopApi);

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getShopList() async {
    // TODO: 调用 _shopApi.getShops，返回商店及商品列表
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Item>> purchaseItem(String itemId, {int quantity = 1}) async {
    // TODO: 调用 _shopApi.buyItem，转换为 Item 实体
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> recharge(String productId) async {
    // TODO: 调用 _shopApi.createOrder，发起充值请求
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Map<String, int>>> claimMonthlyCard() async {
    // TODO: 调用 API 领取月卡每日奖励
    throw UnimplementedError();
  }
}
