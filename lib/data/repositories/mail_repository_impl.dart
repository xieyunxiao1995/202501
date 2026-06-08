import 'package:injectable/injectable.dart';
import '../../core/network/api_result.dart';
import '../../domain/repositories/i_mail_repository.dart';
import '../datasources/remote/mail_api.dart';

/// 邮件仓库实现
///
/// 实现邮件相关业务逻辑，协调远程 API，
/// 处理邮件查询、阅读、领取奖励和删除等操作。
@LazySingleton(as: IMailRepository)
class MailRepositoryImpl implements IMailRepository {
  final MailApi _mailApi;

  MailRepositoryImpl(this._mailApi);

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getList() async {
    // TODO: 调用 _mailApi.getMails，返回邮件列表
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<void>> read(String mailId) async {
    // TODO: 调用 _mailApi.markAsRead，标记邮件为已读
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Map<String, int>>> claimReward(String mailId) async {
    // TODO: 调用 _mailApi.claimAttachments，返回领取的奖励内容
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<void>> delete(String mailId) async {
    // TODO: 调用 _mailApi.deleteMail，删除指定邮件
    throw UnimplementedError();
  }
}
