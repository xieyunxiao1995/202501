import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 竞技场商店页
///
/// 使用竞技币兑换物品的专属商店。
class ArenaShopPage extends ConsumerWidget {
  const ArenaShopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('竞技场商店')),
      body: const Center(
        child: Text('竞技场商店 - 待实现'),
      ),
    );
  }
}
