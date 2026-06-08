import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 关于页
///
/// 关于游戏页面，包括版本信息、用户协议和隐私政策。
class AboutPage extends ConsumerWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('关于')),
      body: const Center(
        child: Text('关于 - 待实现'),
      ),
    );
  }
}
