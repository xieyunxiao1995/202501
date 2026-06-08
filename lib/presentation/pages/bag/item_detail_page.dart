import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 物品详情页
///
/// 展示物品详细信息，包括描述、来源和使用操作。
class ItemDetailPage extends ConsumerWidget {
  /// 物品ID
  final String itemId;

  const ItemDetailPage({super.key, required this.itemId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('物品详情')),
      body: Center(
        child: Text('物品详情 - ID: $itemId - 待实现'),
      ),
    );
  }
}
