import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 招募主页
///
/// 武将招募入口页面，展示当前可用卡池和招募按钮。
class RecruitMainPage extends ConsumerWidget {
  const RecruitMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('招募')),
      body: const Center(
        child: Text('招募主页 - 待实现'),
      ),
    );
  }
}
