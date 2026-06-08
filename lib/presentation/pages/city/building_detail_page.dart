import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 建筑详情页
///
/// 展示建筑详细信息，包括当前等级效果、升级预览和功能入口。
class BuildingDetailPage extends ConsumerWidget {
  /// 建筑ID
  final String buildingId;

  const BuildingDetailPage({super.key, required this.buildingId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('建筑详情')),
      body: Center(
        child: Text('建筑详情 - ID: $buildingId - 待实现'),
      ),
    );
  }
}
