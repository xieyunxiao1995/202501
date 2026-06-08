import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/chat_state.dart';

/// 聊天 ViewModel Provider
final chatViewModelProvider =
    NotifierProvider<ChatViewModel, ChatState>(
  ChatViewModel.new,
);

/// 聊天 ViewModel
///
/// 管理聊天系统，包括发送消息、频道切换和消息历史。
class ChatViewModel extends Notifier<ChatState> {
  @override
  ChatState build() => const ChatState.loaded(messages: [], channels: []);

  /// 加载聊天数据
  Future<void> loadChatData() async {
    // TODO: 实现加载聊天数据逻辑
  }

  /// 发送消息
  Future<void> sendMessage({
    required String channelId,
    required String content,
  }) async {
    // TODO: 实现发送消息逻辑
  }

  /// 切换频道
  void switchChannel(String channelId) {
    // TODO: 实现切换频道逻辑
  }

  /// 加载更多历史消息
  Future<void> loadMoreMessages() async {
    // TODO: 实现加载更多消息逻辑
  }

  /// 屏蔽玩家
  void blockPlayer(String playerId) {
    // TODO: 实现屏蔽逻辑
  }
}
