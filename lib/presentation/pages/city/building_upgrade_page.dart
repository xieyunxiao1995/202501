import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 建筑升级页
///
/// 建筑升级界面，展示升级所需资源和升级后效果预览。
class BuildingUpgradePage extends ConsumerWidget {
  /// 建筑ID
  final String buildingId;

  const BuildingUpgradePage({super.key, required this.buildingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('建筑升级')),
      body: Center(
        child: Text('建筑升级 - ID: $buildingId - 待实现'),
      ),
    );
  }
}
