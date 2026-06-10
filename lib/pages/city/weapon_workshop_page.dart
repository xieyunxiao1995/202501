import 'package:flutter/material.dart';

/// 武器坊页面
///
/// 打造、强化、精炼武将装备。
class WeaponWorkshopPage extends StatelessWidget {
  const WeaponWorkshopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('武器坊'),
        backgroundColor: const Color(0xFF1A1111),
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/city/wuqifang.png'), // 替换为您背景图的路径
            fit: BoxFit.cover, // 适应模式，根据需要选择：cover, contain, fill 等
          ),
        ),
        child:  Center(
        child: Text(
          '武器坊 — 即将开放',
          style: TextStyle(color: Color(0x998B7E6A), fontSize: 16),
        ),
      ),
    ),);
  }
}
