import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 匹配页
///
/// PVP匹配等待界面，展示匹配进度和预计等待时间。
class MatchingPage extends ConsumerStatefulWidget {
  const MatchingPage({super.key});

  @override
  ConsumerState<MatchingPage> createState() => _MatchingPageState();
}

class _MatchingPageState extends ConsumerState<MatchingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('匹配中')),
      body: const Center(
        child: Text('匹配等待 - 待实现'),
      ),
    );
  }
}
