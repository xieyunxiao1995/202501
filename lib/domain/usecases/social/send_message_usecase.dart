import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_mail_repository.dart';

/// 发送邮件用例
///
/// 向其他玩家发送邮件，可附带道具赠送。
/// 邮件发送有每日次数限制。
@injectable
class SendMessageUseCase {
  final IMailRepository _repository;

  /// 创建发送邮件用例实例
  SendMessageUseCase(this._repository);

  /// 执行发送邮件操作
  ///
  /// [recipientId] 收件人 ID
  /// [content] 邮件内容
  /// 返回操作结果的 [ApiResult]
  Future<ApiResult<void>> call({
    required String recipientId,
    required String content,
  }) =>
      throw UnimplementedError();
}
