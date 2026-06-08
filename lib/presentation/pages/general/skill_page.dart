import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 技能页
///
/// 展示武将技能列表，包括战法、兵种技能和觉醒技能。
class SkillPage extends ConsumerWidget {
  /// 武将ID
  final String generalId;

  const SkillPage({super.key, required this.generalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('技能')),
      body: Center(
        child: Text('技能 - 武将ID: $generalId - 待实现'),
      ),
    );
  }
}
