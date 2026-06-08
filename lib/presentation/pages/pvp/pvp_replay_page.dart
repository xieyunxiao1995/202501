import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// PVP回放页
///
/// 查看PVP对战的回放录像。
class PvpReplayPage extends ConsumerWidget {
  /// 录像ID
  final String replayId;

  const PvpReplayPage({super.key, required this.replayId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('对战回放')),
      body: Center(
        child: Text('对战回放 - ID: $replayId - 待实现'),
      ),
    );
  }
}
