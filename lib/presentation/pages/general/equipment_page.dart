import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 装备页
///
/// 展示和管理武将的装备槽位，包括装备穿戴、卸下和强化。
class EquipmentPage extends ConsumerWidget {
  /// 武将ID
  final String generalId;

  const EquipmentPage({super.key, required this.generalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('装备')),
      body: Center(
        child: Text('装备 - 武将ID: $generalId - 待实现'),
      ),
    );
  }
}
