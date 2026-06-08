import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 开场CG页
///
/// 新玩家首次进入游戏时的开场剧情动画页面。
class OpeningCgPage extends ConsumerStatefulWidget {
  const OpeningCgPage({super.key});

  @override
  ConsumerState<OpeningCgPage> createState() => _OpeningCgPageState();
}

class _OpeningCgPageState extends ConsumerState<OpeningCgPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: const Center(
        child: Text(
          '开场CG - 待实现',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
