import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 资源采集页
///
/// 展示各建筑产出的资源，支持一键收集。
class ResourceCollectPage extends ConsumerWidget {
  const ResourceCollectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('资源采集')),
      body: const Center(
        child: Text('资源采集 - 待实现'),
      ),
    );
  }
}
