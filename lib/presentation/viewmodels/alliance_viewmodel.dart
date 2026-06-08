import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/chat_state.dart';

/// 联盟 ViewModel Provider
final allianceViewModelProvider =
    NotifierProvider<AllianceViewModel, ChatState>(
  AllianceViewModel.new,
);

/// 联盟 ViewModel
///
/// 管理联盟相关功能，包括联盟信息、成员管理和联盟战斗。
class AllianceViewModel extends Notifier<ChatState> {
  @override
  ChatState build() => const ChatState.loaded(messages: [], channels: []);

  /// 加载联盟信息
  Future<void> loadAllianceInfo() async {
    // TODO: 实现加载联盟信息逻辑
  }

  /// 创建联盟
  Future<void> createAlliance({
    required String name,
    required String emblem,
  }) async {
    // TODO: 实现创建联盟逻辑
  }

  /// 加入联盟
  Future<void> joinAlliance(String allianceId) async {
    // TODO: 实现加入联盟逻辑
  }

  /// 退出联盟
  Future<void> leaveAlliance() async {
    // TODO: 实现退出联盟逻辑
  }

  /// 踢出成员
  Future<void> kickMember(String memberId) async {
    // TODO: 实现踢出成员逻辑
  }

  /// 修改联盟公告
  Future<void> updateAnnouncement(String content) async {
    // TODO: 实现修改公告逻辑
  }
}
