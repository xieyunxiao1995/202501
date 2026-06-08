import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 联盟主页
///
/// 展示联盟信息、成员列表和联盟功能入口。
class AllianceMainPage extends ConsumerWidget {
  const AllianceMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('联盟')),
      body: const Center(
        child: Text('联盟主页 - 待实现'),
      ),
    );
  }
}
