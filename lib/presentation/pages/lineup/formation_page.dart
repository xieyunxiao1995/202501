import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 阵型页
///
/// 选择和切换战斗阵型，不同阵型提供不同属性加成。
class FormationPage extends ConsumerWidget {
  const FormationPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('阵型')),
      body: const Center(
        child: Text('阵型选择 - 待实现'),
      ),
    );
  }
}
