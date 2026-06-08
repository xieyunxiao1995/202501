import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 资源副本页
///
/// 专属资源获取副本，包括经验、金币和材料关卡。
class ResourceDungeonPage extends ConsumerWidget {
  const ResourceDungeonPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('资源副本')),
      body: const Center(
        child: Text('资源副本 - 待实现'),
      ),
    );
  }
}
