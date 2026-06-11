import 'dart:math';

import 'package:flutter/material.dart';

/// 演武场页面
///
/// 竞技 PVP，与其他玩家切磋对战。
class ArenaPage extends StatefulWidget {
  const ArenaPage({super.key});

  @override
  State<ArenaPage> createState() => _ArenaPageState();
}

class _ArenaPageState extends State<ArenaPage> {
  final Random _rng = Random();
  int _rank = 1250;
  int _arenaChances = 5;
  static const _maxArenaChances = 5;

  // 模拟对手池
  static const _opponents = [
    {'name': '常山赵子龙', 'power': 28500, 'rank': 892},
    {'name': '武圣关羽', 'power': 27800, 'rank': 950},
    {'name': '虎痴许褚', 'power': 26200, 'rank': 1020},
    {'name': '小霸王孙策', 'power': 25500, 'rank': 1100},
    {'name': '弓腰姬孙尚香', 'power': 24800, 'rank': 1180},
    {'name': '西凉马孟起', 'power': 24000, 'rank': 1235},
    {'name': '河北颜良', 'power': 23200, 'rank': 1300},
    {'name': '江东周郎', 'power': 22500, 'rank': 1380},
  ];

  String get _rankTitle {
    if (_rank <= 100) return '王者';
    if (_rank <= 500) return '钻石';
    if (_rank <= 1000) return '黄金';
    if (_rank <= 2000) return '白银';
    return '青铜';
  }

  void _enterArena() {
    if (_arenaChances <= 0) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('今日挑战次数已用完'), duration: Duration(seconds: 1)));
      return;
    }

    // 选 3 个对手
    final pool = List<Map<String, dynamic>>.from(_opponents)..shuffle(_rng);
    final candidates = pool.take(3).toList();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.sports_kabaddi, color: Color(0xFFD4A84B), size: 22),
            SizedBox(width: 8),
            Text('选择对手', style: TextStyle(color: Color(0xFFE8D5A3))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: candidates.map((opp) {
            final rankDiff = _rank - (opp['rank'] as int);
            final icon = rankDiff > 0 ? '🟢' : '🔴';
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  _doBattle(opp);
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0x10D4A84B),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0x18D4A84B)),
                  ),
                  child: Row(
                    children: [
                      Text(icon, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(opp['name'] as String, style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 14, fontWeight: FontWeight.bold)),
                            Text('战力 ${opp['power']} · 排名 ${opp['rank']}', style: const TextStyle(color: Color(0x668B7E6A), fontSize: 11)),
                          ],
                        ),
                      ),
                      Icon(Icons.chevron_right, color: const Color(0xFFD4A84B).withAlpha(80)),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消', style: TextStyle(color: Color(0x668B7E6A)))),
        ],
      ),
    );
  }

  void _doBattle(Map<String, dynamic> opponent) {
    setState(() => _arenaChances--);

    // 模拟战力比拼：玩家战力约 26000 + 随机波动
    final playerPower = 26000 + _rng.nextInt(5000);
    final oppPower = (opponent['power'] as int) + _rng.nextInt(3000);
    final won = playerPower >= oppPower;

    // 显示战斗结果
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              won ? Icons.emoji_events : Icons.sentiment_dissatisfied,
              color: won ? const Color(0xFFD4A84B) : const Color(0xFFA11717),
              size: 48,
            ),
            const SizedBox(height: 12),
            Text(
              won ? '挑战成功！' : '挑战失败',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: won ? const Color(0xFFD4A84B) : const Color(0xFFA11717)),
            ),
            const SizedBox(height: 8),
            Text(
              'vs ${opponent['name']}',
              style: const TextStyle(color: Color(0x998B7E6A), fontSize: 14),
            ),
            const SizedBox(height: 4),
            Text(
              won ? '排名 ↑ ${_rng.nextInt(30) + 10}' : '排名 ↓ ${_rng.nextInt(20) + 5}',
              style: TextStyle(color: won ? const Color(0xFF4CAF50) : const Color(0xFFA11717), fontSize: 13),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: won ? const Color(0xFFD4A84B) : const Color(0xFFA11717),
              foregroundColor: const Color(0xFFE2D9CD),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                if (won) {
                  _rank = max(1, _rank - _rng.nextInt(30) - 10);
                } else {
                  _rank += _rng.nextInt(20) + 5;
                }
              });
            },
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(String title) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.schedule, color: Color(0xFFD4A84B), size: 48),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('敬请期待', style: TextStyle(color: Color(0x668B7E6A), fontSize: 14)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('知道了', style: TextStyle(color: Color(0xFFD4A84B)))),
        ],
      ),
    );
  }

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
        actions: [_RankChip(rank: _rank, title: _rankTitle), const SizedBox(width: 16)],
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/city/yanwuchang.png'), fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: _ArenaPanel(
              arenaChances: _arenaChances,
              maxArenaChances: _maxArenaChances,
              onEnterArena: _enterArena,
              onComingSoon: _showComingSoon,
            ),
          ),
        ],
      ),
    );
  }
}

/// 排名标签
class _RankChip extends StatelessWidget {
  const _RankChip({required this.rank, required this.title});
  final int rank;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0x30D4A84B),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0x50D4A84B)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.emoji_events, size: 14, color: Color(0xFFD4A84B)),
          const SizedBox(width: 4),
          Text(title, style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(width: 4),
          Text('#$rank', style: const TextStyle(color: Color(0xCCD4A84B), fontSize: 11)),
        ],
      ),
    );
  }
}

/// 演武场面板
class _ArenaPanel extends StatelessWidget {
  const _ArenaPanel({required this.arenaChances, required this.maxArenaChances, required this.onEnterArena, required this.onComingSoon});

  final int arenaChances;
  final int maxArenaChances;
  final VoidCallback onEnterArena;
  final ValueChanged<String> onComingSoon;

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
        border: const Border(top: BorderSide(color: Color(0x40D4A84B), width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PanelTitle(),
          const SizedBox(height: 14),
          _ArenaCard(
            icon: '⚔️',
            title: '竞技场',
            subtitle: '与武馆主公一较高下',
            footer: '当前场次: $arenaChances/$maxArenaChances',
            buttonLabel: '进入',
            buttonActive: arenaChances > 0,
            onTap: onEnterArena,
          ),
          const SizedBox(height: 10),
          _ArenaCard(
            icon: '👑',
            title: '巅峰赛',
            subtitle: '赛事排名，赢取丰厚奖励',
            buttonLabel: '未开启',
            buttonActive: false,
            onTap: () => onComingSoon('巅峰赛'),
          ),
          const SizedBox(height: 10),
          _ArenaCard(
            icon: '🏆',
            title: '比武大会',
            subtitle: '定期开启，争夺最强主公',
            buttonLabel: '周六 20:00 开启',
            buttonActive: false,
            onTap: () => onComingSoon('比武大会'),
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
        const Text('演武场', style: TextStyle(color: Color(0xFFE8D5A3), fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(width: 12),
        _goldLine(width: 40),
      ],
    );
  }

  Widget _goldLine({required double width}) {
    return Container(
      width: width, height: 1.5,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0x00D4A84B), Color(0xFFD4A84B), Color(0x00D4A84B)]),
      ),
    );
  }
}

/// 竞技卡片
class _ArenaCard extends StatelessWidget {
  const _ArenaCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.footer,
    required this.buttonLabel,
    required this.buttonActive,
    required this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final String? footer;
  final String buttonLabel;
  final bool buttonActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0x10D4A84B),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0x18D4A84B)),
        ),
        child: Row(
          children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(color: const Color(0x20D4A84B), borderRadius: BorderRadius.circular(8)),
              child: Center(child: Text(icon, style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 15, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 3),
                  Text(subtitle, style: const TextStyle(color: Color(0x998B7E6A), fontSize: 12)),
                  if (footer != null) ...[
                    const SizedBox(height: 4),
                    Text(footer!, style: TextStyle(
                      color: buttonActive ? const Color(0xFFD4A84B) : const Color(0x668B7E6A),
                      fontSize: 11,
                    )),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: buttonActive ? const LinearGradient(colors: [Color(0xFFD4A84B), Color(0xFFB8922E)]) : null,
                color: buttonActive ? null : const Color(0x18FFFFFF),
                borderRadius: BorderRadius.circular(6),
                border: buttonActive ? null : Border.all(color: const Color(0x20FFFFFF)),
              ),
              child: Text(
                buttonLabel,
                style: TextStyle(
                  color: buttonActive ? const Color(0xFF1A1111) : const Color(0x668B7E6A),
                  fontSize: 12, fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
