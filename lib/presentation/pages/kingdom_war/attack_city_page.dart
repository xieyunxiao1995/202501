import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 攻城页
///
/// 国战攻城界面，选择出战队形并发起攻城战。
class AttackCityPage extends ConsumerWidget {
  /// 目标城池ID
  final String cityId;

  const AttackCityPage({super.key, required this.cityId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('攻城')),
      body: Center(
        child: Text('攻城 - 目标: $cityId - 待实现'),
      ),
    );
  }
}
