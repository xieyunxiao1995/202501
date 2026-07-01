import 'dart:math';

import 'package:flutter/material.dart';

/// 招募池武将
class _PoolGeneral {
  const _PoolGeneral({required this.name, required this.rarity, required this.icon});

  final String name;
  final String rarity; // 铜/蓝/紫/橙
  final String icon;
}

/// 酒馆页面
///
/// 招募武将，使用招募令或元宝抽取。
class TavernPage extends StatefulWidget {
  const TavernPage({super.key});

  @override
  State<TavernPage> createState() => _TavernPageState();
}

class _TavernPageState extends State<TavernPage> {
  int _scrolls = 12; // 招募令
  int _gems = 1250; // 元宝
  int _pityCount = 18; // 距离保底剩余次数
  final int _pityTotal = 20; // 保底总次数

  final List<String> _owned = []; // 已招募武将

  static const _pool = [
    // 橙将 5%
    _PoolGeneral(name: '吕布', rarity: '橙', icon: '⚔️'),
    _PoolGeneral(name: '诸葛亮', rarity: '橙', icon: '📜'),
    _PoolGeneral(name: '关羽', rarity: '橙', icon: '🗡️'),
    _PoolGeneral(name: '曹操', rarity: '橙', icon: '👑'),
    _PoolGeneral(name: '赵云', rarity: '橙', icon: '🏇'),
    _PoolGeneral(name: '周瑜', rarity: '橙', icon: '🔥'),
    // 紫将 20%
    _PoolGeneral(name: '夏侯惇', rarity: '紫', icon: '🛡️'),
    _PoolGeneral(name: '张辽', rarity: '紫', icon: '🐺'),
    _PoolGeneral(name: '孙策', rarity: '紫', icon: '💪'),
    _PoolGeneral(name: '黄忠', rarity: '紫', icon: '🏹'),
    _PoolGeneral(name: '庞统', rarity: '紫', icon: '🎭'),
    _PoolGeneral(name: '司马懿', rarity: '紫', icon: '🦅'),
    _PoolGeneral(name: '太史慈', rarity: '紫', icon: '🔱'),
    _PoolGeneral(name: '甘宁', rarity: '紫', icon: '⚓'),
    // 蓝将 35%
    _PoolGeneral(name: '徐晃', rarity: '蓝', icon: '🔰'),
    _PoolGeneral(name: '张郃', rarity: '蓝', icon: '🔷'),
    _PoolGeneral(name: '魏延', rarity: '蓝', icon: '🌀'),
    _PoolGeneral(name: '黄盖', rarity: '蓝', icon: '🪵'),
    _PoolGeneral(name: '程普', rarity: '蓝', icon: '🔵'),
    _PoolGeneral(name: '曹仁', rarity: '蓝', icon: '💠'),
    // 铜将 40%
    _PoolGeneral(name: '廖化', rarity: '铜', icon: '🟤'),
    _PoolGeneral(name: '周仓', rarity: '铜', icon: '🤠'),
    _PoolGeneral(name: '张翼', rarity: '铜', icon: '🪙'),
    _PoolGeneral(name: '马忠', rarity: '铜', icon: '🏇'),
    _PoolGeneral(name: '王平', rarity: '铜', icon: '🔸'),
    _PoolGeneral(name: '刘封', rarity: '铜', icon: '🟠'),
  ];

  static const _rarityColors = {
    '铜': Color(0xFF9E9E9E),
    '蓝': Color(0xFF42A5F5),
    '紫': Color(0xFFAB47BC),
    '橙': Color(0xFFFF8C00),
  };

  _PoolGeneral _drawOne(Random rng) {
    if (_pityCount <= 1) {
      // 触发保底：必出橙将
      return _pool.where((g) => g.rarity == '橙').toList()[rng.nextInt(_pool.where((g) => g.rarity == '橙').length)];
    }
    final roll = rng.nextInt(100);
    String rarity;
    if (roll < 5) {
      rarity = '橙';
    } else if (roll < 25) {
      rarity = '紫';
    } else if (roll < 60) {
      rarity = '蓝';
    } else {
      rarity = '铜';
    }
    final candidates = _pool.where((g) => g.rarity == rarity).toList();
    return candidates[rng.nextInt(candidates.length)];
  }

  List<_PoolGeneral> _draw(int count) {
    final rng = Random();
    final results = <_PoolGeneral>[];
    for (int i = 0; i < count; i++) {
      final general = _drawOne(rng);
      results.add(general);
      if (general.rarity == '橙') {
        _pityCount = _pityTotal; // 出橙重置保底
      } else {
        _pityCount = max(1, _pityCount - 1);
      }
      if (!_owned.contains(general.name)) {
        _owned.add(general.name);
      }
    }
    return results;
  }

  void _recruit(int count) {
    final scrollCost = count;
    // 元宝单价随数量递减：1抽=100，10抽=90/抽，千抽=80/抽
    final int gemPerDraw;
    if (count >= 1000) {
      gemPerDraw = 80;
    } else if (count >= 10) {
      gemPerDraw = 90;
    } else {
      gemPerDraw = 100;
    }
    final gemCost = count * gemPerDraw;

    if (_scrolls >= scrollCost) {
      // 使用招募令
      setState(() => _scrolls -= scrollCost);
    } else if (_gems >= gemCost) {
      // 招募令不足，使用元宝
      setState(() => _gems -= gemCost);
    } else {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('招募令和元宝都不足！'), duration: Duration(seconds: 1)));
      return;
    }

    final results = _draw(count);
    setState(() {}); // 更新保底计数

    _showResultDialog(results);
  }

  void _showResultDialog(List<_PoolGeneral> results) {
    final hasOrange = results.any((g) => g.rarity == '橙');
    final hasPurple = results.any((g) => g.rarity == '紫');
    final isBulkDraw = results.length > 10;

    // 统计各稀有度数量
    final rarityCount = <String, int>{};
    for (final g in results) {
      rarityCount[g.rarity] = (rarityCount[g.rarity] ?? 0) + 1;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(
              hasOrange ? Icons.stars : hasPurple ? Icons.auto_awesome : Icons.card_giftcard,
              color: hasOrange ? const Color(0xFFFF8C00) : hasPurple ? const Color(0xFFAB47BC) : const Color(0xFFD4A84B),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              isBulkDraw
                  ? '招募 ${results.length} 次结果'
                  : hasOrange ? '🌟 天命所归！' : hasPurple ? '✨ 良将入手' : '招募结果',
              style: TextStyle(
                color: hasOrange ? const Color(0xFFFF8C00) : hasPurple ? const Color(0xFFAB47BC) : const Color(0xFFE8D5A3),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isBulkDraw) ...[
                // 大量抽取：显示稀有度汇总
                _RaritySummary(rarityCount: rarityCount),
                const SizedBox(height: 10),
                // 显示橙将和紫将详情
                ..._buildRareResults(results),
              ] else if (results.length == 1)
                _ResultCard(general: results.first)
              else
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: results.map((g) => SizedBox(width: (MediaQuery.of(context).size.width - 120) / 4, child: _ResultCard(general: g, compact: true))).toList(),
                ),
              const SizedBox(height: 12),
              Text(
                '剩余保底: $_pityCount 次',
                style: TextStyle(color: _pityCount <= 5 ? const Color(0xFFFF8C00) : const Color(0x668B7E6A), fontSize: 12),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('确定', style: TextStyle(color: Color(0xFFD4A84B)))),
        ],
      ),
    );
  }

  /// 构建稀有武将（橙+紫）的结果卡片
  List<Widget> _buildRareResults(List<_PoolGeneral> results) {
    final rares = results.where((g) => g.rarity == '橙' || g.rarity == '紫').toList();
    if (rares.isEmpty) return [const Text('本次未获得紫将及以上', style: TextStyle(color: Color(0x668B7E6A), fontSize: 12))];
    final displayList = rares.length > 20 ? rares.sublist(0, 20) : rares;
    return [
      ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 180),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: displayList
                .map((g) => SizedBox(
                      width: (MediaQuery.of(context).size.width - 120) / 4,
                      child: _ResultCard(general: g, compact: true),
                    ))
                .toList(),
          ),
        ),
      ),
      if (rares.length > 20)
        Text('...及其他 ${rares.length - 20} 位稀有武将', style: const TextStyle(color: Color(0x668B7E6A), fontSize: 11)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('酒馆'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        actions: [
          _CurrencyChip(icon: '📜', value: '$_scrolls'),
          const SizedBox(width: 8),
          _CurrencyChip(icon: 'assets/UI/icon_0009.png', value: '$_gems'),
          const SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          // 背景图
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/Bg/Bg10.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 底部面板
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _TavernPanel(
              pityCount: _pityCount,
              pityTotal: _pityTotal,
              onRecruit: _recruit,
            ),
          ),
        ],
      ),
    );
  }
}

/// 招募结果卡片
class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.general, this.compact = false});
  final _PoolGeneral general;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = _TavernPageState._rarityColors[general.rarity]!;
    return Container(
      padding: EdgeInsets.all(compact ? 6 : 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(general.icon, style: TextStyle(fontSize: compact ? 20 : 28)),
          const SizedBox(height: 4),
          Text(general.name, style: TextStyle(color: const Color(0xFFE8D5A3), fontSize: compact ? 10 : 13, fontWeight: FontWeight.bold)),
          Text(general.rarity + '将', style: TextStyle(color: color, fontSize: compact ? 9 : 11)),
        ],
      ),
    );
  }
}

/// 货币显示组件
class _CurrencyChip extends StatelessWidget {
  final String icon;
  final String value;

  const _CurrencyChip({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0x40FFFFFF),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          icon.startsWith('assets/')
              ? Image.asset(icon, width: 16, height: 16)
              : Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            value,
            style: const TextStyle(
              color: Color(0xFFE8D5A3),
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// 酒馆招募面板
class _TavernPanel extends StatelessWidget {
  const _TavernPanel({
    required this.pityCount,
    required this.pityTotal,
    required this.onRecruit,
  });

  final int pityCount;
  final int pityTotal;
  final ValueChanged<int> onRecruit;

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
          const SizedBox(height: 16),

          // ---- 招募按钮 ----
          _RecruitButtons(onRecruit: onRecruit),
          const SizedBox(height: 12),

          // ---- 保底提示 ----
          _PityCounter(pityCount: pityCount, pityTotal: pityTotal),
          const SizedBox(height: 14),

          // ---- 可能获得 ----
          const _PossibleRewards(),
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
          '酒馆',
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

/// 招募按钮（单抽 & 十连 & 千抽）
class _RecruitButtons extends StatelessWidget {
  const _RecruitButtons({required this.onRecruit});
  final ValueChanged<int> onRecruit;

  static const _gemIcon = 'assets/UI/icon_0009.png';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 第一行：单抽 + 十连
        Row(
          children: [
            Expanded(
              child: _RecruitButton(
                label: '招募一次',
                scrollCount: 1,
                gemCount: 100,
                gemIcon: _gemIcon,
                isPrimary: false,
                onTap: () => onRecruit(1),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _RecruitButton(
                label: '招募十次',
                scrollCount: 10,
                gemCount: 900,
                gemIcon: _gemIcon,
                isPrimary: true,
                onTap: () => onRecruit(10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // 第二行：千抽
        _RecruitButton(
          label: '千抽',
          scrollCount: 1000,
          gemCount: 80000,
          gemIcon: _gemIcon,
          isPrimary: true,
          isHighlight: true,
          onTap: () => onRecruit(1000),
        ),
      ],
    );
  }
}

class _RecruitButton extends StatelessWidget {
  final String label;
  final int scrollCount;
  final int gemCount;
  final String gemIcon;
  final bool isPrimary;
  final bool isHighlight;
  final VoidCallback onTap;

  const _RecruitButton({
    required this.label,
    required this.scrollCount,
    required this.gemCount,
    required this.gemIcon,
    required this.isPrimary,
    required this.onTap,
    this.isHighlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? LinearGradient(
                  colors: isHighlight
                      ? const [Color(0xFFFF8C00), Color(0xFFD4A84B), Color(0xFFFF8C00)]
                      : const [Color(0xFFD4A84B), Color(0xFFB8922E)],
                )
              : null,
          color: isPrimary ? null : const Color(0x18D4A84B),
          borderRadius: BorderRadius.circular(8),
          border: isPrimary ? null : Border.all(color: const Color(0x40D4A84B)),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                color: isPrimary ? const Color(0xFF1A1111) : const Color(0xFFE8D5A3),
                fontSize: isHighlight ? 17 : 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            // 消耗：招募令图标 + 数量  或  元宝图标 + 数量
            RichText(
              text: TextSpan(
                style: TextStyle(
                  color: isPrimary ? const Color(0xCC1A1111) : const Color(0x998B7E6A),
                  fontSize: 11,
                ),
                children: [
                  const TextSpan(text: '消耗: '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Text('📜', style: TextStyle(fontSize: 11)),
                  ),
                  TextSpan(text: 'x$scrollCount 或 '),
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 1),
                      child: Image.asset(gemIcon, width: 12, height: 12),
                    ),
                  ),
                  TextSpan(text: 'x$gemCount'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 保底提示
class _PityCounter extends StatelessWidget {
  const _PityCounter({required this.pityCount, required this.pityTotal});
  final int pityCount;
  final int pityTotal;

  @override
  Widget build(BuildContext context) {
    final close = pityCount <= 5;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: close ? const Color(0x20FF8C00) : const Color(0x10D4A84B),
        borderRadius: BorderRadius.circular(6),
        border: close ? Border.all(color: const Color(0x40FF8C00)) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('再招募 ', style: TextStyle(color: Color(0x998B7E6A), fontSize: 12)),
          Text(
            '$pityCount',
            style: TextStyle(
              color: close ? const Color(0xFFFF8C00) : const Color(0xFFD4A84B),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(' 次必得 ', style: TextStyle(color: Color(0x998B7E6A), fontSize: 12)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: const Color(0x30FF8C00),
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text(
              '橙色武将',
              style: TextStyle(color: Color(0xFFFF8C00), fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

/// 可能获得的奖励
class _PossibleRewards extends StatelessWidget {
  const _PossibleRewards();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('可能获得', style: TextStyle(color: Color(0x998B7E6A), fontSize: 12)),
        const SizedBox(height: 8),
        Row(
          children: const [
            Expanded(child: _RarityBox(label: '铜将', percent: '40%', color: Color(0xFF9E9E9E))),
            SizedBox(width: 8),
            Expanded(child: _RarityBox(label: '蓝将', percent: '35%', color: Color(0xFF42A5F5))),
            SizedBox(width: 8),
            Expanded(child: _RarityBox(label: '紫将', percent: '20%', color: Color(0xFFAB47BC))),
            SizedBox(width: 8),
            Expanded(child: _RarityBox(label: '橙将', percent: '5%', color: Color(0xFFFF8C00))),
          ],
        ),
      ],
    );
  }
}

class _RarityBox extends StatelessWidget {
  final String label;
  final String percent;
  final Color color;

  const _RarityBox({required this.label, required this.percent, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(percent, style: TextStyle(color: color.withOpacity(0.8), fontSize: 12)),
        ],
      ),
    );
  }
}

/// 批量抽取稀有度汇总
class _RaritySummary extends StatelessWidget {
  const _RaritySummary({required this.rarityCount});
  final Map<String, int> rarityCount;

  @override
  Widget build(BuildContext context) {
    const order = ['橙', '紫', '蓝', '铜'];
    return Row(
      children: order.where((r) => (rarityCount[r] ?? 0) > 0).map((rarity) {
        final color = _TavernPageState._rarityColors[rarity]!;
        final count = rarityCount[rarity]!;
        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: color.withOpacity(0.4)),
            ),
            child: Column(
              children: [
                Text(
                  '$count',
                  style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 2),
                Text(
                  '$rarity将',
                  style: TextStyle(color: color.withOpacity(0.9), fontSize: 11),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
