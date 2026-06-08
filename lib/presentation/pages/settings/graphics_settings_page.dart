import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 画面设置页
///
/// 画面设置页面，包括画质、特效和帧率调节。
class GraphicsSettingsPage extends ConsumerStatefulWidget {
  const GraphicsSettingsPage({super.key});

  @override
  ConsumerState<GraphicsSettingsPage> createState() =>
      _GraphicsSettingsPageState();
}

class _GraphicsSettingsPageState extends ConsumerState<GraphicsSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('画面设置')),
      body: const Center(
        child: Text('画面设置 - 待实现'),
      ),
    );
  }
}
