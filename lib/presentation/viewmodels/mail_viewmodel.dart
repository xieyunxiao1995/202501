import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/mail_state.dart';

/// 邮件 ViewModel Provider
final mailViewModelProvider =
    NotifierProvider<MailViewModel, MailState>(
  MailViewModel.new,
);

/// 邮件 ViewModel
///
/// 管理邮件系统，包括邮件列表、已读标记和附件领取。
class MailViewModel extends Notifier<MailState> {
  @override
  MailState build() => const MailState.loading();

  /// 加载邮件列表
  Future<void> loadMails() async {
    // TODO: 实现加载邮件列表逻辑
  }

  /// 标记邮件已读
  Future<void> markAsRead(String mailId) async {
    // TODO: 实现标记已读逻辑
  }

  /// 领取邮件附件
  Future<void> claimAttachment(String mailId) async {
    // TODO: 实现领取附件逻辑
  }

  /// 一键领取所有附件
  Future<void> claimAllAttachments() async {
    // TODO: 实现一键领取逻辑
  }

  /// 删除邮件
  Future<void> deleteMail(String mailId) async {
    // TODO: 实现删除邮件逻辑
  }
}
