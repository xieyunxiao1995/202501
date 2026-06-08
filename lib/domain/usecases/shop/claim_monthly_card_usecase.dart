import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_shop_repository.dart';

/// 领取月卡奖励用例
///
/// 领取当日月卡奖励，需已购买月卡。
/// 月卡有效期内每日可领取一次，奖励包含元宝和道具。
@injectable
class ClaimMonthlyCardUseCase {
  final IShopRepository _repository;

  /// 创建领取月卡奖励用例实例
  ClaimMonthlyCardUseCase(this._repository);

  /// 执行领取月卡奖励操作
  ///
  /// 返回包含奖励内容的 [ApiResult]（道具 ID 到数量的映射）
  Future<ApiResult<Map<String, int>>> call() =>
      throw UnimplementedError();
}
