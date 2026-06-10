import 'package:flutter/material.dart';

/// 议事厅页面
///
/// 接取日常/周常任务，领取奖励。
class CouncilHallPage extends StatelessWidget {
  const CouncilHallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('议事厅'),
        backgroundColor: const Color(0xFF1A1111),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/city/yishitin.png'), // 替换为您背景图的路径
            fit: BoxFit.cover, // 适应模式，根据需要选择：cover, contain, fill 等
          ),
        ),
        child:  Center(
        child: Text(
          '议事厅 — 即将开放',
          style: TextStyle(color: Color(0x998B7E6A), fontSize: 16),
        ),
      ),
    ),);
  }
}
