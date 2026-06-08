import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 城池节点页
///
/// 展示国战地图上某个城池的详细信息，包括守军和驻防。
class CityNodePage extends ConsumerWidget {
  /// 城池ID
  final String cityId;

  const CityNodePage({super.key, required this.cityId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('城池')),
      body: Center(
        child: Text('城池节点 - ID: $cityId - 待实现'),
      ),
    );
  }
}
