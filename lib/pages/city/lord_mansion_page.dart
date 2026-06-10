import 'package:flutter/material.dart';

/// 主公府页面
///
/// 查看主公等级、属性、称号等信息。
class LordMansionPage extends StatelessWidget {
  const LordMansionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('主公府'),
        backgroundColor: const Color(0xFF1A1111),
        elevation: 0,
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/city/zhugongfu.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Text(
            '主公府 — 即将开放',
            style: TextStyle(color: Color(0x998B7E6A), fontSize: 16),
          ),
        ),
      ),
    );
  }
}
