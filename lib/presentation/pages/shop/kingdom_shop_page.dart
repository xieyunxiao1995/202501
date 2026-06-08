import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 国家商店页
///
/// 使用国家功勋兑换物品的专属商店。
class KingdomShopPage extends ConsumerWidget {
  const KingdomShopPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('国家商店')),
      body: const Center(
        child: Text('国家商店 - 待实现'),
      ),
    );
  }
}
