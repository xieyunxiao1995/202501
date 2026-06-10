import 'package:flutter/material.dart';

/// 武器坊页面
///
/// 打造、强化、精炼武将装备。
class WeaponWorkshopPage extends StatelessWidget {
  const WeaponWorkshopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('武器坊'),
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
                  image: AssetImage('assets/images/city/wuqifang.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 底部面板
          Positioned(left: 0, right: 0, bottom: 0, child: _WorkshopPanel()),
        ],
      ),
    );
  }
}

/// 武器坊面板
class _WorkshopPanel extends StatelessWidget {
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
          // ---- 标题 + 规则说明 ----
          _PanelHeader(),
          const SizedBox(height: 12),

          // ---- 锻造/强化 Tab ----
          const _TabBar(),
          const SizedBox(height: 12),

          // ---- 武器列表 ----
          const _WeaponItem(icon: '🗡️', name: '审虑剑', attack: 120),
          const SizedBox(height: 6),
          const _WeaponItem(icon: '🐍', name: '丈八蛇矛', attack: 150),
          const SizedBox(height: 6),
          const _WeaponItem(icon: '🔱', name: '方天画戟', attack: 190),
          const SizedBox(height: 6),
          const _WeaponItem(icon: '⚔️', name: '诡刺逐野', attack: 100),
          const SizedBox(height: 12),

          // ---- 底部资源 ----
          const _ResourceBar(),
        ],
      ),
    );
  }
}

/// 面板标题 + 规则说明
class _PanelHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _goldLine(width: 30),
            const SizedBox(width: 10),
            const Text(
              '武器坊',
              style: TextStyle(
                color: Color(0xFFE8D5A3),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 10),
            _goldLine(width: 30),
          ],
        ),
        GestureDetector(
          onTap: () {
            // TODO: 打开规则说明
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0x60D4A84B)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              '规则说明',
              style: TextStyle(color: Color(0xCCD4A84B), fontSize: 12),
            ),
          ),
        ),
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

/// 锻造 / 强化 Tab
class _TabBar extends StatelessWidget {
  const _TabBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0x30D4A84B),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0x60D4A84B)),
            ),
            child: const Center(
              child: Text(
                '锻造',
                style: TextStyle(
                  color: Color(0xFFE8D5A3),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0x20FFFFFF)),
            ),
            child: const Center(
              child: Text(
                '强化',
                style: TextStyle(color: Color(0x668B7E6A), fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// 单个武器条目
class _WeaponItem extends StatelessWidget {
  final String icon;
  final String name;
  final int attack;

  const _WeaponItem({
    required this.icon,
    required this.name,
    required this.attack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0x10D4A84B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x18D4A84B)),
      ),
      child: Row(
        children: [
          // 武器图标
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: const Color(0x20D4A84B),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 10),
          // 名称 & 攻击
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    color: Color(0xFFE8D5A3),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '攻击 +$attack',
                  style: const TextStyle(
                    color: Color(0xFF4CAF50),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          // 锻造按钮
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD4A84B), Color(0xFFB8922E)],
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              '锻造',
              style: TextStyle(
                color: Color(0xFF1A1111),
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 底部资源消耗
class _ResourceBar extends StatelessWidget {
  const _ResourceBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: const [
        _ResourceItem(
          icon: '🪙',
          current: '12.5万',
          required: '/5万',
          isMet: true,
        ),
        _ResourceItem(
          icon: '🔩',
          current: '1250',
          required: '/500',
          isMet: true,
        ),
        _ResourceItem(
          icon: '💎',
          current: '300',
          required: '/200',
          isMet: true,
        ),
      ],
    );
  }
}

class _ResourceItem extends StatelessWidget {
  final String icon;
  final String current;
  final String required;
  final bool isMet;

  const _ResourceItem({
    required this.icon,
    required this.current,
    required this.required,
    required this.isMet,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 4),
        Text(
          current,
          style: TextStyle(
            color: isMet ? const Color(0xFF4CAF50) : const Color(0xFFD32F2F),
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          required,
          style: const TextStyle(color: Color(0x668B7E6A), fontSize: 11),
        ),
      ],
    );
  }
}
