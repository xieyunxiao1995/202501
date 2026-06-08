import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 武将觉醒页
///
/// 消耗觉醒材料激活武将觉醒状态，大幅提升属性和解锁觉醒技能。
class GeneralAwakePage extends ConsumerWidget {
  /// 武将ID
  final String generalId;

  const GeneralAwakePage({super.key, required this.generalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('武将觉醒')),
      body: Center(
        child: Text('武将觉醒 - ID: $generalId - 待实现'),
      ),
    );
  }
}
