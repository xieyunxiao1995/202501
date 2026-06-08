import 'package:dio/dio.dart';

/// 邮件相关 API
///
/// 提供邮件列表查询、读取、领取附件和删除接口。
abstract class MailApi {
  final Dio _dio;

  MailApi(this._dio);

  /// 获取邮件列表
  ///
  /// 返回当前用户的邮件列表。
  Future<Map<String, dynamic>> getMails() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取邮件详情
  ///
  /// 返回指定邮件的详细信息。
  Future<Map<String, dynamic>> getMailDetail(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 标记邮件已读
  ///
  /// 将指定邮件标记为已读状态。
  Future<Map<String, dynamic>> markAsRead(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 领取邮件附件
  ///
  /// 领取指定邮件中的附件奖励。
  Future<Map<String, dynamic>> claimAttachments(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 一键领取所有附件
  ///
  /// 领取所有已读邮件中的附件。
  Future<Map<String, dynamic>> claimAllAttachments() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 删除邮件
  ///
  /// 删除指定邮件。
  Future<Map<String, dynamic>> deleteMail(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }
}
