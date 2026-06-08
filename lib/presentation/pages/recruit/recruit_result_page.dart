import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 招募结果页
///
/// 展示招募获得的武将和物品。
class RecruitResultPage extends ConsumerWidget {
  const RecruitResultPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('招募结果')),
      body: const Center(
        child: Text('招募结果 - 待实现'),
      ),
    );
  }
}
