import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../viewmodels/general_list_viewmodel.dart';

/// 武将列表页
///
/// 展示玩家拥有的所有武将，支持按阵营筛选和按稀有度/等级排序。
class GeneralListPage extends ConsumerWidget {
  const GeneralListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('武将列表')),
      body: const Center(
        child: Text('武将列表 - 待实现'),
      ),
    );
  }
}
