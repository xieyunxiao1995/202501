import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 缘分页
///
/// 查看武将之间的缘分组合，激活缘分可获得属性加成。
class BondPage extends ConsumerWidget {
  const BondPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('缘分')),
      body: const Center(
        child: Text('缘分系统 - 待实现'),
      ),
    );
  }
}
