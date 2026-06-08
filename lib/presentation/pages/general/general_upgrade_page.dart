import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 武将升级页
///
/// 消耗经验道具提升武将等级。
class GeneralUpgradePage extends ConsumerWidget {
  /// 武将ID
  final String generalId;

  const GeneralUpgradePage({super.key, required this.generalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('武将升级')),
      body: Center(
        child: Text('武将升级 - ID: $generalId - 待实现'),
      ),
    );
  }
}
