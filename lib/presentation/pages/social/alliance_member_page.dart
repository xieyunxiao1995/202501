import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 联盟成员页
///
/// 展示联盟成员列表，包括职位、贡献和在线状态。
class AllianceMemberPage extends ConsumerWidget {
  const AllianceMemberPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('联盟成员')),
      body: const Center(
        child: Text('联盟成员 - 待实现'),
      ),
    );
  }
}
