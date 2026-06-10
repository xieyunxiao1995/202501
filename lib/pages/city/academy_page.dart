import 'package:flutter/material.dart';

/// 学堂页面
///
/// 研究战法，提升战术等级。
class AcademyPage extends StatelessWidget {
  const AcademyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('学堂'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: const Color(0xFFE2D9CD),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/city/xuetang.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Text(
            '学堂 — 即将开放',
            style: TextStyle(color: Color(0x998B7E6A), fontSize: 16),
          ),
        ),
      ),
    );
  }
}
