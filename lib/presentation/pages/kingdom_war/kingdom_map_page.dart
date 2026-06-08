import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 国战地图页
///
/// 展示国战全局地图，包括各国势力范围和城池归属。
class KingdomMapPage extends ConsumerWidget {
  const KingdomMapPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('国战地图')),
      body: const Center(
        child: Text('国战地图 - 待实现'),
      ),
    );
  }
}
