import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 武器页
///
/// 展示武器详情，包括武器属性、强化和精炼。
class WeaponPage extends ConsumerWidget {
  /// 武器ID
  final String weaponId;

  const WeaponPage({super.key, required this.weaponId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('武器')),
      body: Center(
        child: Text('武器 - ID: $weaponId - 待实现'),
      ),
    );
  }
}
