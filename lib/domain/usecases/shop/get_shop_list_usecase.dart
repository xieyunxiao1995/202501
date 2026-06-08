import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_shop_repository.dart';

/// 获取商店列表用例
///
/// 获取商店中可购买的商品列表，按分类展示。
/// 包括限时商品、常驻商品和活动商品。
@injectable
class GetShopListUseCase {
  final IShopRepository _repository;

  /// 创建获取商店列表用例实例
  GetShopListUseCase(this._repository);

  /// 执行获取商店列表操作
  ///
  /// 返回包含商品列表的 [ApiResult]
  Future<ApiResult<List<Map<String, dynamic>>>> call() =>
      throw UnimplementedError();
}
