import 'package:flutter/material.dart';

/// 铸币司页面
///
/// 产出和收集金币。
class MintPage extends StatelessWidget {
  const MintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('铸币司'),
        backgroundColor: const Color(0xFF1A1111),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/city/zhubishi.png'), // 替换为您背景图的路径
            fit: BoxFit.cover, // 适应模式，根据需要选择：cover, contain, fill 等
          ),
        ),
        child:  Center(
        child: Text(
          '铸币司 — 即将开放',
          style: TextStyle(color: Color(0x998B7E6A), fontSize: 16),
        ),
      ),
    ),);
  }
}
