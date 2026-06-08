import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 武将进阶页
///
/// 消耗进阶材料提升武将品阶，解锁更高等级上限。
class GeneralEvolvePage extends ConsumerWidget {
  /// 武将ID
  final String generalId;

  const GeneralEvolvePage({super.key, required this.generalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('武将进阶')),
      body: Center(
        child: Text('武将进阶 - ID: $generalId - 待实现'),
      ),
    );
  }
}
