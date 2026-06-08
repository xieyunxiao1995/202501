import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 坐骑页
///
/// 展示坐骑详情，包括坐骑属性、升级和培养。
class HorsePage extends ConsumerWidget {
  /// 坐骑ID
  final String horseId;

  const HorsePage({super.key, required this.horseId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('坐骑')),
      body: Center(
        child: Text('坐骑 - ID: $horseId - 待实现'),
      ),
    );
  }
}
