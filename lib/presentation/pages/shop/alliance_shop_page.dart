import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 联盟商店页
///
/// 使用联盟贡献兑换物品的专属商店。
class AllianceShopPage extends ConsumerWidget {
  const AllianceShopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('联盟商店')),
      body: const Center(
        child: Text('联盟商店 - 待实现'),
      ),
    );
  }
}
