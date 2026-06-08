import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 新手引导页
///
/// 新手引导流程页面，分步引导玩家了解游戏基本操作。
class TutorialPage extends ConsumerStatefulWidget {
  const TutorialPage({super.key});

  @override
  ConsumerState<TutorialPage> createState() => _TutorialPageState();
}

class _TutorialPageState extends ConsumerState<TutorialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('新手引导')),
      body: const Center(
        child: Text('新手引导 - 待实现'),
      ),
    );
  }
}
