import 'dart:math';

import 'package:flutter/material.dart';

/// 观星台页面
///
/// 占卜抽奖，获取稀有道具和武将。
class ObservatoryPage extends StatefulWidget {
  const ObservatoryPage({super.key});

  @override
  State<ObservatoryPage> createState() => _ObservatoryPageState();
}

class _ObservatoryPageState extends State<ObservatoryPage> with SingleTickerProviderStateMixin {
  final Random _rng = Random();
  int _freeDrawsLeft = 1;
  int _gems = 500; // 元宝
  String _fortune = '大吉';
  Color _fortuneColor = const Color(0xFFFF5722);
  bool _isDrawing = false;

  // 奖池
  static const _prizePool = [
    {'name': '招贤令', 'icon': '📜', 'rarity': 'rare', 'value': 'x2'},
    {'name': '元宝', 'icon': 'assets/UI/icon_0009.png', 'rarity': 'common', 'value': 'x100'},
    {'name': '铜钱', 'icon': '🪙', 'rarity': 'common', 'value': 'x56000'},
    {'name': '强化石', 'icon': '🔩', 'rarity': 'common', 'value': 'x5'},
    {'name': '武将碎片', 'icon': '🎴', 'rarity': 'rare', 'value': 'x3'},
    {'name': '经验书', 'icon': '📘', 'rarity': 'common', 'value': 'x10'},
    {'name': '金色武将', 'icon': '🌟', 'rarity': 'legend', 'value': '关羽'},
    {'name': '紫色武将', 'icon': '💜', 'rarity': 'epic', 'value': '黄忠'},
    {'name': '粮草', 'icon': '🌾', 'rarity': 'common', 'value': 'x20000'},
    {'name': '木材', 'icon': '🪵', 'rarity': 'common', 'value': 'x10000'},
    {'name': 'SSR碎片', 'icon': '✨', 'rarity': 'epic', 'value': 'x1'},
    {'name': '锦囊', 'icon': '🎁', 'rarity': 'rare', 'value': 'x1'},
  ];

  @override
  void initState() {
    super.initState();
    _rollFortune();
  }

  void _rollFortune() {
    final fortunes = [
      {'text': '大吉', 'color': const Color(0xFFFF5722)},
      {'text': '吉', 'color': const Color(0xFFFF9800)},
      {'text': '中吉', 'color': const Color(0xFFD4A84B)},
      {'text': '小吉', 'color': const Color(0xFF4CAF50)},
      {'text': '凶', 'color': const Color(0xFF607D8B)},
    ];
    final f = fortunes[_rng.nextInt(fortunes.length)];
    setState(() {
      _fortune = f['text'] as String;
      _fortuneColor = f['color'] as Color;
    });
  }

  Map<String, dynamic> _drawPrize() {
    // 运势影响稀有率：大吉 20% 传奇, 吉 10%, 中吉 5%, 小吉 2%, 凶 1%
    final fortuneBonus = switch (_fortune) {
      '大吉' => 0.20, '吉' => 0.10, '中吉' => 0.05, '小吉' => 0.02, _ => 0.01,
    };

    final roll = _rng.nextDouble();
    String targetRarity;
    if (roll < fortuneBonus) {
      targetRarity = 'legend';
    } else if (roll < fortuneBonus + 0.10) {
      targetRarity = 'epic';
    } else if (roll < fortuneBonus + 0.25) {
      targetRarity = 'rare';
    } else {
      targetRarity = 'common';
    }

    final pool = _prizePool.where((p) => p['rarity'] == targetRarity).toList();
    if (pool.isEmpty) return _prizePool[_rng.nextInt(_prizePool.length)];
    return pool[_rng.nextInt(pool.length)];
  }

  void _observe() {
    if (_isDrawing) return;

    if (_freeDrawsLeft <= 0 && _gems < 100) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('元宝不足，无法观星'), duration: Duration(seconds: 1)));
      return;
    }

    setState(() {
      _isDrawing = true;
      if (_freeDrawsLeft > 0) {
        _freeDrawsLeft--;
      } else {
        _gems -= 100;
      }
    });

    // 模拟动画：快速滚动奖池
    _showDrawAnimation();
  }

  void _showDrawAnimation() {
    final prize = _drawPrize();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          // 模拟滚动效果
          final displayPrize = _prizePool[_rng.nextInt(_prizePool.length)];
          Future.delayed(const Duration(milliseconds: 1200), () {
            if (ctx.mounted) {
              Navigator.pop(ctx);
              _showResult(prize);
            }
          });

          return AlertDialog(
            backgroundColor: const Color(0xEE1A1A2A),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: 2 * 3.14159),
                  duration: const Duration(milliseconds: 1200),
                  builder: (context, value, child) => Transform.rotate(angle: value, child: child),
                  child: Text(displayPrize['icon'] as String, style: const TextStyle(fontSize: 64)),
                ),
                const SizedBox(height: 16),
                Text(displayPrize['name'] as String, style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('观星中...', style: TextStyle(color: Color(0x668B7E6A), fontSize: 14)),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showResult(Map<String, dynamic> prize) {
    final rarityColor = switch (prize['rarity']) {
      'legend' => const Color(0xFFFF5722),
      'epic' => const Color(0xFF9B59B6),
      'rare' => const Color(0xFF4A90D9),
      _ => const Color(0x998B7E6A),
    };
    final rarityLabel = switch (prize['rarity']) {
      'legend' => '传奇', 'epic' => '史诗', 'rare' => '稀有', _ => '普通',
    };

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 80, height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: rarityColor.withAlpha(30),
                border: Border.all(color: rarityColor.withAlpha(120), width: 2),
                boxShadow: [BoxShadow(color: rarityColor.withAlpha(80), blurRadius: 20, spreadRadius: 2)],
              ),
              child: Center(
                child: (prize['icon'] as String).startsWith('assets/')
                    ? Image.asset(prize['icon'] as String, width: 40, height: 40)
                    : Text(prize['icon'] as String, style: const TextStyle(fontSize: 36)),
              ),
            ),
            const SizedBox(height: 12),
            Text(prize['name'] as String, style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(prize['value'] as String, style: const TextStyle(color: Color(0xFFD4A84B), fontSize: 16)),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(color: rarityColor.withAlpha(30), borderRadius: BorderRadius.circular(4)),
              child: Text(rarityLabel, style: TextStyle(color: rarityColor, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 16),
            // 再来一次
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_freeDrawsLeft > 0)
                  _actionButton(ctx, '免费再来 (剩$_freeDrawsLeft次)', () {
                    Navigator.pop(ctx);
                    _observe();
                  })
                else
                  _actionButton(ctx, '再抽一次 (💎100)', () {
                    Navigator.pop(ctx);
                    _observe();
                  }),
              ],
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                setState(() => _isDrawing = false);
                _rollFortune();
              },
              child: const Text('关闭', style: TextStyle(color: Color(0x668B7E6A))),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(BuildContext ctx, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFD4A84B), Color(0xFFB8922E)]),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(label, style: const TextStyle(color: Color(0xFF1A1111), fontSize: 14, fontWeight: FontWeight.bold)),
      ),
    );
  }

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
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('💎', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text('$_gems', style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 13, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/Bg/Bg6.png'), fit: BoxFit.cover)),
            ),
          ),
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: _ObservatoryPanel(
              fortune: _fortune,
              fortuneColor: _fortuneColor,
              freeDrawsLeft: _freeDrawsLeft,
              gems: _gems,
              isDrawing: _isDrawing,
              onObserve: _observe,
            ),
          ),
        ],
      ),
    );
  }
}

/// 观星台面板
class _ObservatoryPanel extends StatelessWidget {
  const _ObservatoryPanel({
    required this.fortune,
    required this.fortuneColor,
    required this.freeDrawsLeft,
    required this.gems,
    required this.isDrawing,
    required this.onObserve,
  });

  final String fortune;
  final Color fortuneColor;
  final int freeDrawsLeft;
  final int gems;
  final bool isDrawing;
  final VoidCallback onObserve;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xCC1A1111), Color(0xF21A1111)]),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        border: const Border(top: BorderSide(color: Color(0x40D4A84B), width: 1)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _PanelTitle(),
          const SizedBox(height: 14),
          _FortuneRow(fortune: fortune, color: fortuneColor),
          const SizedBox(height: 14),
          _RewardsSection(),
          const SizedBox(height: 16),
          _ObserveButton(freeDrawsLeft: freeDrawsLeft, gems: gems, isDrawing: isDrawing, onTap: onObserve),
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
        const Text('观星台', style: TextStyle(color: Color(0xFFE8D5A3), fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(width: 12),
        _goldLine(width: 40),
      ],
    );
  }

  Widget _goldLine({required double width}) {
    return Container(
      width: width, height: 1.5,
      decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0x00D4A84B), Color(0xFFD4A84B), Color(0x00D4A84B)])),
    );
  }
}

/// 今日运势
class _FortuneRow extends StatelessWidget {
  const _FortuneRow({required this.fortune, required this.color});
  final String fortune;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
      decoration: BoxDecoration(color: const Color(0x10D4A84B), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0x18D4A84B))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('今日运势：', style: TextStyle(color: Color(0x998B7E6A), fontSize: 14)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(color: color.withAlpha(40), borderRadius: BorderRadius.circular(4), border: Border.all(color: color.withAlpha(80))),
            child: Text(fortune, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.bold)),
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
      decoration: BoxDecoration(color: const Color(0x10D4A84B), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0x18D4A84B))),
      child: Column(
        children: [
          const Text('奖池一览：', style: TextStyle(color: Color(0x998B7E6A), fontSize: 13)),
          const SizedBox(height: 10),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _RewardItem(icon: '📜', value: '招贤令'),
              _RewardItem(icon: 'assets/UI/icon_0009.png', value: '元宝'),
              _RewardItem(icon: '🌟', value: '武将'),
            ],
          ),
        ],
      ),
    );
  }
}

class _RewardItem extends StatelessWidget {
  const _RewardItem({required this.icon, required this.value});
  final String icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 56, height: 56,
          decoration: BoxDecoration(color: const Color(0x20D4A84B), borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0x30D4A84B))),
          child: Center(
            child: icon.startsWith('assets/')
                ? Image.asset(icon, width: 28, height: 28)
                : Text(icon, style: const TextStyle(fontSize: 26)),
          ),
        ),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

/// 观星按钮 & 消耗
class _ObserveButton extends StatelessWidget {
  const _ObserveButton({required this.freeDrawsLeft, required this.gems, required this.isDrawing, required this.onTap});
  final int freeDrawsLeft;
  final int gems;
  final bool isDrawing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isFree = freeDrawsLeft > 0;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton(
            onPressed: isDrawing ? null : onTap,
            style: ElevatedButton.styleFrom(
              backgroundColor: isDrawing ? const Color(0x30D4A84B) : const Color(0xFFD4A84B),
              foregroundColor: const Color(0xFF1A1111),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              elevation: 0,
            ),
            child: Text(isDrawing ? '观星中...' : '观  星'),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isFree ? '今日免费: 剩余 $freeDrawsLeft 次' : '消耗 💎100 (剩余 $gems)',
          style: const TextStyle(color: Color(0x668B7E6A), fontSize: 12),
        ),
      ],
    );
  }
}
