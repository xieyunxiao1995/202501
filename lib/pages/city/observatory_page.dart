import 'package:flutter/material.dart';

/// 观星台页面
///
/// 占卜抽奖，获取稀有道具和武将。
class ObservatoryPage extends StatelessWidget {
  const ObservatoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1614),
      appBar: AppBar(
        title: const Text('观星台'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          '观星台 — 即将开放',
          style: TextStyle(color: Color(0x998B7E6A), fontSize: 16),
        ),
      ),
    );
  }
}
