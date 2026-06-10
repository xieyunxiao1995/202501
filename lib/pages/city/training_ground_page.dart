import 'package:flutter/material.dart';

/// 校场页面
///
/// 训练士兵、提升兵种等级。
class TrainingGroundPage extends StatelessWidget {
  const TrainingGroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1614),
      appBar: AppBar(
        title: const Text('校场'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          '校场 — 即将开放',
          style: TextStyle(color: Color(0x998B7E6A), fontSize: 16),
        ),
      ),
    );
  }
}
