import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_mail_repository.dart';

/// 获取邮件列表用例
///
/// 获取当前玩家的邮件列表，按时间倒序排列。
/// 邮件包括系统通知、战斗报告、好友赠送等类型。
@injectable
class GetMailListUseCase {
  final IMailRepository _repository;

  /// 创建获取邮件列表用例实例
  GetMailListUseCase(this._repository);

  /// 执行获取邮件列表操作
  ///
  /// 返回包含邮件列表的 [ApiResult]
  Future<ApiResult<List<Map<String, dynamic>>>> call() =>
      throw UnimplementedError();
}
