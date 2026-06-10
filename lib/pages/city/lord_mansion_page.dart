import 'package:flutter/material.dart';

/// 主公府页面
///
/// 查看主公等级、属性、称号等信息。
class LordMansionPage extends StatelessWidget {
  const LordMansionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1614),
      appBar: AppBar(
        title: const Text('主公府'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          '主公府 — 即将开放',
          style: TextStyle(color: Color(0x998B7E6A), fontSize: 16),
        ),
      ),
    );
  }
}
