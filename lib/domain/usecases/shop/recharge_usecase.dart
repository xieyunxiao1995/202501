import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_shop_repository.dart';

/// 充值用例
///
/// 发起充值请求，购买游戏内货币或礼包。
/// 充值通过应用商店支付，成功后发放对应物品。
@injectable
class RechargeUseCase {
  final IShopRepository _repository;

  /// 创建充值用例实例
  RechargeUseCase(this._repository);

  /// 执行充值操作
  ///
  /// [productId] 充值商品 ID
  /// 返回包含充值结果的 [ApiResult]
  Future<ApiResult<Map<String, dynamic>>> call(String productId) =>
      throw UnimplementedError();
}
