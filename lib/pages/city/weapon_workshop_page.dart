import 'package:flutter/material.dart';

/// 武器坊页面
///
/// 打造、强化、精炼武将装备。
class WeaponWorkshopPage extends StatelessWidget {
  const WeaponWorkshopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1614),
      appBar: AppBar(
        title: const Text('武器坊'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          '武器坊 — 即将开放',
          style: TextStyle(color: Color(0x998B7E6A), fontSize: 16),
        ),
      ),
    );
  }
}
