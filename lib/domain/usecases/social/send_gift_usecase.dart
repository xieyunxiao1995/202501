import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_social_repository.dart';

/// 赠送礼物用例
///
/// 向好友赠送礼物，增加好友亲密度。
/// 每日赠送次数有上限，亲密度可解锁额外功能。
@injectable
class SendGiftUseCase {
  final ISocialRepository _repository;

  /// 创建赠送礼物用例实例
  SendGiftUseCase(this._repository);

  /// 执行赠送礼物操作
  ///
  /// [friendId] 好友 ID
  /// [giftId] 礼物 ID
  /// 返回操作结果的 [ApiResult]
  Future<ApiResult<void>> call(String friendId, String giftId) =>
      throw UnimplementedError();
}
