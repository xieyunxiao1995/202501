import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 招募动画页
///
/// 招募时的特效展示页面，包括抽卡动画和结果揭晓。
class RecruitAnimationPage extends ConsumerStatefulWidget {
  const RecruitAnimationPage({super.key});

  @override
  ConsumerState<RecruitAnimationPage> createState() =>
      _RecruitAnimationPageState();
}

class _RecruitAnimationPageState extends ConsumerState<RecruitAnimationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('招募')),
      body: const Center(
        child: Text('招募动画 - 待实现'),
      ),
    );
  }
}
