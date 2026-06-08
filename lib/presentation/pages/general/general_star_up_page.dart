import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 武将升星页
///
/// 消耗同名武将或通用升星材料提升武将星级。
class GeneralStarUpPage extends ConsumerWidget {
  /// 武将ID
  final String generalId;

  const GeneralStarUpPage({super.key, required this.generalId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('武将升星')),
      body: Center(
        child: Text('武将升星 - ID: $generalId - 待实现'),
      ),
    );
  }
}
