import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 商店主页
///
/// 游戏内商店入口，展示各类商品和限时优惠。
class ShopMainPage extends ConsumerWidget {
  const ShopMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('商店')),
      body: const Center(
        child: Text('商店主页 - 待实现'),
      ),
    );
  }
}
