import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 好友页
///
/// 展示好友列表，支持添加、删除和查看好友信息。
class FriendPage extends ConsumerWidget {
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('好友')),
      body: const Center(
        child: Text('好友列表 - 待实现'),
      ),
    );
  }
}
