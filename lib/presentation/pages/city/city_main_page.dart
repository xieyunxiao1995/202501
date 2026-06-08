import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 城池主页
///
/// 展示城池全景视图，包含所有建筑入口和资源信息。
class CityMainPage extends ConsumerWidget {
  const CityMainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('城池')),
      body: const Center(
        child: Text('城池主页 - 待实现'),
      ),
    );
  }
}
