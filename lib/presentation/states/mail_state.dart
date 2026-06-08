import 'package:freezed_annotation/freezed_annotation.dart';

part 'mail_state.freezed.dart';

/// 邮件状态
///
/// 管理邮件系统的状态，包括邮件列表和未读数量。
@freezed
class MailState with _$MailState {
  /// 加载中
  const factory MailState.loading() = _MailLoading;

  /// 数据已加载
  const factory MailState.loaded({
    /// 邮件列表
    required List<MailItem> mails,

    /// 未读数量
    required int unreadCount,
  }) = _MailLoaded;

  /// 加载失败
  const factory MailState.error({
    required String message,
  }) = _MailError;
}

/// 邮件项
class MailItem {
  /// 邮件ID
  final String id;

  /// 邮件标题
  final String title;

  /// 是否已读
  final bool isRead;

  /// 是否已领取附件
  final bool hasAttachment;

  /// 发送时间
  final DateTime sendTime;

  const MailItem({
    required this.id,
    required this.title,
    required this.isRead,
    required this.hasAttachment,
    required this.sendTime,
  });
}
