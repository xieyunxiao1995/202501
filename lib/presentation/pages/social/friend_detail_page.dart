import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 好友详情页
///
/// 展示好友的详细信息，包括等级、阵容和在线状态。
class FriendDetailPage extends ConsumerWidget {
  /// 好友ID
  final String friendId;

  const FriendDetailPage({super.key, required this.friendId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('好友详情')),
      body: Center(
        child: Text('好友详情 - ID: $friendId - 待实现'),
      ),
    );
  }
}
