import 'package:flutter/material.dart';

/// 粮仓页面
///
/// 储存和管理粮食资源。
class GranaryPage extends StatelessWidget {
  const GranaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('粮仓'),
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
                  image: AssetImage('assets/images/city/liangcang.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 底部资源面板
          Positioned(left: 0, right: 0, bottom: 0, child: _GranaryPanel()),
        ],
      ),
    );
  }
}

/// 粮仓面板
class _GranaryPanel extends StatelessWidget {
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

          // ---- 资源列表 ----
          const _ResourceItem(icon: '🌾', label: '粮食', amount: '125.7万'),
          const SizedBox(height: 6),
          const _ResourceItem(icon: '🪵', label: '木材', amount: '85.3万'),
          const SizedBox(height: 6),
          const _ResourceItem(icon: '⛏️', label: '铁矿', amount: '65.2万'),
          const SizedBox(height: 6),
          const _ResourceItem(icon: '🪨', label: '石料', amount: '45.6万'),
          const SizedBox(height: 14),

          // ---- 底部提示 ----
          _BottomHint(),
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
          '粮仓',
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

/// 单个资源条目
class _ResourceItem extends StatelessWidget {
  final String icon;
  final String label;
  final String amount;

  const _ResourceItem({
    required this.icon,
    required this.label,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x10D4A84B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x18D4A84B)),
      ),
      child: Row(
        children: [
          // 资源图标
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
          // 名称
          Text(
            label,
            style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 14),
          ),
          const Spacer(),
          // 数量
          Text(
            amount,
            style: const TextStyle(
              color: Color(0xFFE8D5A3),
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 12),
          // 使用按钮
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFD4A84B), Color(0xFFB8922E)],
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              '使用',
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

/// 底部提示
class _BottomHint extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.info_outline, size: 13, color: Color(0x668B7E6A)),
        SizedBox(width: 4),
        Text(
          '升级建筑可提升资源产出与存储上限',
          style: TextStyle(color: Color(0x668B7E6A), fontSize: 12),
        ),
      ],
    );
  }
}
