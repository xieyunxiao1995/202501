import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_mail_repository.dart';

/// 领取邮件奖励用例
///
/// 领取邮件中附带的奖励道具。
/// 领取后邮件标记为已领取，可删除。
@injectable
class ClaimMailRewardUseCase {
  final IMailRepository _repository;

  /// 创建领取邮件奖励用例实例
  ClaimMailRewardUseCase(this._repository);

  /// 执行领取邮件奖励操作
  ///
  /// [mailId] 邮件 ID
  /// 返回包含奖励内容的 [ApiResult]（道具 ID 到数量的映射）
  Future<ApiResult<Map<String, int>>> call(String mailId) =>
      throw UnimplementedError();
}
