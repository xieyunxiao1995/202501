import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/item.dart';
import '../../repositories/i_shop_repository.dart';

/// 购买商品用例
///
/// 购买商店中的指定商品，消耗对应货币。
/// 部分商品有每日限购数量，购买后扣除货币并发放道具。
@injectable
class PurchaseItemUseCase {
  final IShopRepository _repository;

  /// 创建购买商品用例实例
  PurchaseItemUseCase(this._repository);

  /// 执行购买商品操作
  ///
  /// [itemId] 商品 ID
  /// [quantity] 购买数量，默认 1
  /// 返回包含购买结果物品的 [ApiResult]
  Future<ApiResult<Item>> call(String itemId, {int quantity = 1}) =>
      throw UnimplementedError();
}
