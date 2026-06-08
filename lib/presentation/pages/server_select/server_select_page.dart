import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 服务器选择页
///
/// 选择游戏服务器页面，展示服务器列表和状态。
class ServerSelectPage extends ConsumerWidget {
  const ServerSelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('选择服务器')),
      body: const Center(
        child: Text('服务器选择 - 待实现'),
      ),
    );
  }
}
