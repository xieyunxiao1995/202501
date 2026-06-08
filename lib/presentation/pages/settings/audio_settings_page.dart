import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 音频设置页
///
/// 音频设置页面，包括背景音乐、音效和语音的音量调节。
class AudioSettingsPage extends ConsumerStatefulWidget {
  const AudioSettingsPage({super.key});

  @override
  ConsumerState<AudioSettingsPage> createState() => _AudioSettingsPageState();
}

class _AudioSettingsPageState extends ConsumerState<AudioSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('音频设置')),
      body: const Center(
        child: Text('音频设置 - 待实现'),
      ),
    );
  }
}
