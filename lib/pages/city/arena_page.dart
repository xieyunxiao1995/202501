import 'package:flutter/material.dart';

/// 演武场页面
///
/// 竞技 PVP，与其他玩家切磋对战。
class ArenaPage extends StatelessWidget {
  const ArenaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('演武场'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        actions: const [_RankChip(), SizedBox(width: 16)],
      ),
      body: Stack(
        children: [
          // 背景图
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/city/yanwuchang.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 底部面板
          Positioned(left: 0, right: 0, bottom: 0, child: _ArenaPanel()),
        ],
      ),
    );
  }
}

/// 排名标签
class _RankChip extends StatelessWidget {
  const _RankChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0x30D4A84B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x50D4A84B)),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.emoji_events, size: 14, color: Color(0xFFD4A84B)),
          SizedBox(width: 4),
          Text(
            '排名:1250',
            style: TextStyle(
              color: Color(0xFFE8D5A3),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// 演武场面板
class _ArenaPanel extends StatelessWidget {
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

          // ---- 竞技场 ----
          _ArenaCard(
            icon: '⚔️',
            title: '竞技场',
            subtitle: '与武馆主公一战高下',
            footer: '当前场次: 5/5',
            buttonLabel: '进入',
            buttonActive: true,
          ),
          const SizedBox(height: 10),

          // ---- 巅峰赛 ----
          _ArenaCard(
            icon: '👑',
            title: '巅峰赛',
            subtitle: '赛事排名，赢取丰厚奖励',
            buttonLabel: '未开启',
            buttonActive: false,
          ),
          const SizedBox(height: 10),

          // ---- 比武大会 ----
          _ArenaCard(
            icon: '🏆',
            title: '比武大会',
            subtitle: '定期开启，争夺最强主公',
            buttonLabel: '周六 20:00 开启',
            buttonActive: false,
          ),
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
          '演武场',
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

/// 竞技卡片
class _ArenaCard extends StatelessWidget {
  final String icon;
  final String title;
  final String subtitle;
  final String? footer;
  final String buttonLabel;
  final bool buttonActive;

  const _ArenaCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.footer,
    required this.buttonLabel,
    required this.buttonActive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x10D4A84B),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0x18D4A84B)),
      ),
      child: Row(
        children: [
          // 图标
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0x20D4A84B),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 12),
          // 标题 & 副标题
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFFE8D5A3),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0x998B7E6A),
                    fontSize: 12,
                  ),
                ),
                if (footer != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    footer!,
                    style: const TextStyle(
                      color: Color(0xFFD4A84B),
                      fontSize: 11,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 10),
          // 按钮
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: buttonActive
                  ? const LinearGradient(
                      colors: [Color(0xFFD4A84B), Color(0xFFB8922E)],
                    )
                  : null,
              color: buttonActive ? null : const Color(0x18FFFFFF),
              borderRadius: BorderRadius.circular(6),
              border: buttonActive
                  ? null
                  : Border.all(color: const Color(0x20FFFFFF)),
            ),
            child: Text(
              buttonLabel,
              style: TextStyle(
                color: buttonActive
                    ? const Color(0xFF1A1111)
                    : const Color(0x668B7E6A),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
