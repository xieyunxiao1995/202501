import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 武将详情页
///
/// 展示单个武将的详细信息，包括属性、技能、装备和缘分。
class GeneralDetailPage extends ConsumerWidget {
  /// 武将ID
  final String generalId;

  const GeneralDetailPage({super.key, required this.generalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('武将详情')),
      body: Center(
        child: Text('武将详情 - ID: $generalId - 待实现'),
      ),
    );
  }
}
