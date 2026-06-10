import 'package:flutter/material.dart';

/// 学堂页面
///
/// 研究战法，提升战术等级。
class AcademyPage extends StatelessWidget {
  const AcademyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('学堂'),
        backgroundColor: const Color(0xFF1A1111),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/city/xuetang.png'), // 替换为您背景图的路径
            fit: BoxFit.cover, // 适应模式，根据需要选择：cover, contain, fill 等
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '学堂 — 即将开放',
                style: TextStyle(color: Color(0x998B7E6A), fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}