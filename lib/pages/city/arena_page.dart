import 'package:flutter/material.dart';

/// 演武场页面
///
/// 竞技 PVP，与其他玩家切磋对战。
class ArenaPage extends StatelessWidget {
  const ArenaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('演武场'),
        backgroundColor: const Color(0xFF1A1111),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/city/yanwuchang.png'), // 替换为您背景图的路径
            fit: BoxFit.cover, // 适应模式，根据需要选择：cover, contain, fill 等
          ),
        ),
        child: const Center(
        child: Text(
            '演武场 — 即将开放',
            style: TextStyle(color: Color(0x998B7E6A), fontSize: 16),
          ),
        ),
      ),
    );
  }
}
