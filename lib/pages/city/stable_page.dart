import 'package:flutter/material.dart';

/// 马厩页面
///
/// 培养战马，提升坐骑属性。
class StablePage extends StatelessWidget {
  const StablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('马厩'),
        backgroundColor: const Color(0xFF1A1111),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/city/majiu.png'), // 替换为您背景图的路径
            fit: BoxFit.cover, // 适应模式，根据需要选择：cover, contain, fill 等
          ),
        ),
        child:  Center(
        child: Text(
          '马厩 — 即将开放',
          style: TextStyle(color: Color(0x998B7E6A), fontSize: 16),
        ),
      ),
    ),);
  }
}
