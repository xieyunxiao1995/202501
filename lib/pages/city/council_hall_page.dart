import 'package:flutter/material.dart';

/// 议事厅页面
///
/// 接取日常/周常任务，领取奖励。
class CouncilHallPage extends StatelessWidget {
  const CouncilHallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1614),
      appBar: AppBar(
        title: const Text('议事厅'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          '议事厅 — 即将开放',
          style: TextStyle(color: Color(0x998B7E6A), fontSize: 16),
        ),
      ),
    );
  }
}
