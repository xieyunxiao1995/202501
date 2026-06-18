/// 邮件状态
///
/// 管理邮件系统的状态，包括邮件列表和未读数量。
sealed class MailState {
  const MailState();
  const factory MailState.loading() = MailLoading;
  const factory MailState.loaded({required List<MailItem> mails, required int unreadCount}) = MailLoaded;
  const factory MailState.error({required String message}) = MailError;
}

final class MailLoading extends MailState {
  const MailLoading();
}

final class MailLoaded extends MailState {
  final List<MailItem> mails;
  final int unreadCount;
  const MailLoaded({required this.mails, required this.unreadCount});
}

final class MailError extends MailState {
  final String message;
  const MailError({required this.message});
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
