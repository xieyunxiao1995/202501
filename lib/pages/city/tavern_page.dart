import 'package:flutter/material.dart';

/// 酒馆页面
///
/// 招募武将，使用招募令或元宝抽取。
class TavernPage extends StatelessWidget {
  const TavernPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1614),
      appBar: AppBar(
        title: const Text('酒馆'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          '酒馆 — 即将开放',
          style: TextStyle(color: Color(0x998B7E6A), fontSize: 16),
        ),
      ),
    );
  }
}
