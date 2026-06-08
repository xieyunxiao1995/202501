import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 国战排名页
///
/// 展示国战各国排名和个人功勋排名。
class KingdomRankPage extends ConsumerWidget {
  const KingdomRankPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('国战排名')),
      body: const Center(
        child: Text('国战排名 - 待实现'),
      ),
    );
  }
}
