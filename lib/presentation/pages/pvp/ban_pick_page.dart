import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Ban/Pick页
///
/// 巅峰竞技场的武将禁选界面，双方轮流禁用和选择武将。
class BanPickPage extends ConsumerStatefulWidget {
  const BanPickPage({super.key});

  @override
  ConsumerState<BanPickPage> createState() => _BanPickPageState();
}

class _BanPickPageState extends ConsumerState<BanPickPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ban/Pick')),
      body: const Center(
        child: Text('武将禁选 - 待实现'),
      ),
    );
  }
}
