import 'package:flutter/material.dart';

/// 观星台页面
///
/// 占卜抽奖，获取稀有道具和武将。
class ObservatoryPage extends StatelessWidget {
  const ObservatoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('观星台'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
      ),
      body: Stack(
        children: [
          // 背景图
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/city/yanxingtai.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 底部面板
          Positioned(left: 0, right: 0, bottom: 0, child: _ObservatoryPanel()),
        ],
      ),
    );
  }
}

/// 观星台面板
class _ObservatoryPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xCC1A1111), Color(0xF21A1111)],
        ),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: const Border(
          top: BorderSide(color: Color(0x40D4A84B), width: 1),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ---- 标题 ----
          _PanelTitle(),
          const SizedBox(height: 14),

          // ---- 今日运势 ----
          _FortuneRow(),
          const SizedBox(height: 14),

          // ---- 可获得奖励 ----
          _RewardsSection(),
          const SizedBox(height: 16),

          // ---- 观星按钮 & 消耗 ----
          _ObserveButton(),
        ],
      ),
    );
  }
}

/// 面板标题
class _PanelTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _goldLine(width: 40),
        const SizedBox(width: 12),
        const Text(
          '观星台',
          style: TextStyle(
            color: Color(0xFFE8D5A3),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        _goldLine(width: 40),
      ],
    );
  }

  Widget _goldLine({required double width}) {
    return Container(
      width: width,
      height: 1.5,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0x00D4A84B), Color(0xFFD4A84B), Color(0x00D4A84B)],
        ),
      ),
    );
  }
}

/// 今日运势
class _FortuneRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0x10D4A84B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x18D4A84B)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '今日运势：',
            style: TextStyle(color: Color(0x998B7E6A), fontSize: 14),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0x30FF5722),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: const Color(0x50FF5722)),
            ),
            child: const Text(
              '大吉',
              style: TextStyle(
                color: Color(0xFFFF5722),
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 可获得奖励
class _RewardsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0x10D4A84B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x18D4A84B)),
      ),
      child: Column(
        children: [
          const Text(
            '可获得奖励：',
            style: TextStyle(color: Color(0x998B7E6A), fontSize: 13),
          ),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _RewardItem(icon: '📜', value: 'x2'),
              _RewardItem(icon: '💎', value: 'x100'),
              _RewardItem(icon: '🪙', value: 'x56000'),
            ],
          ),
        ],
      ),
    );
  }
}

class _RewardItem extends StatelessWidget {
  final String icon;
  final String value;

  const _RewardItem({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: const Color(0x20D4A84B),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: const Color(0x30D4A84B)),
          ),
          child: Center(
            child: Text(icon, style: const TextStyle(fontSize: 26)),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFFE8D5A3),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// 观星按钮 & 消耗
class _ObserveButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 观星按钮
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton(
            onPressed: () {
              // TODO: 观星逻辑
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD4A84B),
              foregroundColor: const Color(0xFF1A1111),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: const Text('观  星'),
          ),
        ),
        const SizedBox(height: 8),
        // 消耗
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('📜', style: TextStyle(fontSize: 14)),
            SizedBox(width: 4),
            Text(
              '消耗：',
              style: TextStyle(color: Color(0x998B7E6A), fontSize: 13),
            ),
            Text(
              'x1',
              style: TextStyle(
                color: Color(0xFFE8D5A3),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
