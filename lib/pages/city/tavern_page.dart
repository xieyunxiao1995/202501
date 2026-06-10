import 'package:flutter/material.dart';

/// 酒馆页面
///
/// 招募武将，使用招募令或元宝抽取。
class TavernPage extends StatelessWidget {
  const TavernPage({super.key});

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
        actions: const [
          _CurrencyChip(icon: '📜', value: '12'),
          SizedBox(width: 8),
          _CurrencyChip(icon: '💎', value: '1250'),
          SizedBox(width: 16),
        ],
      ),
      body: Stack(
        children: [
          // 背景图
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/city/jiuguan.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 底部面板
          Positioned(left: 0, right: 0, bottom: 0, child: _TavernPanel()),
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
          Text(icon, style: const TextStyle(fontSize: 14)),
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
          _RecruitButtons(),
          const SizedBox(height: 12),

          // ---- 保底提示 ----
          _PityCounter(),
          const SizedBox(height: 14),

          // ---- 可能获得 ----
          _PossibleRewards(),
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

/// 招募按钮（单抽 & 十连）
class _RecruitButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _RecruitButton(
            label: '招募一次',
            cost: '消耗: x1',
            isPrimary: false,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _RecruitButton(
            label: '招募十次',
            cost: '消耗: x10',
            isPrimary: true,
          ),
        ),
      ],
    );
  }
}

class _RecruitButton extends StatelessWidget {
  final String label;
  final String cost;
  final bool isPrimary;

  const _RecruitButton({
    required this.label,
    required this.cost,
    required this.isPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: 招募逻辑
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          gradient: isPrimary
              ? const LinearGradient(
                  colors: [Color(0xFFD4A84B), Color(0xFFB8922E)],
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
                color: isPrimary
                    ? const Color(0xFF1A1111)
                    : const Color(0xFFE8D5A3),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              cost,
              style: TextStyle(
                color: isPrimary
                    ? const Color(0xCC1A1111)
                    : const Color(0x998B7E6A),
                fontSize: 12,
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
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0x10D4A84B),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '再招募 ',
            style: TextStyle(color: Color(0x998B7E6A), fontSize: 12),
          ),
          const Text(
            '18',
            style: TextStyle(
              color: Color(0xFFD4A84B),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            ' 次必得 ',
            style: TextStyle(color: Color(0x998B7E6A), fontSize: 12),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: const Color(0x30FF8C00),
              borderRadius: BorderRadius.circular(3),
            ),
            child: const Text(
              '橙色武将',
              style: TextStyle(
                color: Color(0xFFFF8C00),
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

/// 可能获得的奖励
class _PossibleRewards extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '可能获得',
          style: TextStyle(color: Color(0x998B7E6A), fontSize: 12),
        ),
        const SizedBox(height: 8),
        Row(
          children: const [
            Expanded(
              child: _RarityBox(
                label: '铜将',
                percent: '40%',
                color: Color(0xFF9E9E9E),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _RarityBox(
                label: '蓝将',
                percent: '35%',
                color: Color(0xFF42A5F5),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _RarityBox(
                label: '紫将',
                percent: '20%',
                color: Color(0xFFAB47BC),
              ),
            ),
            SizedBox(width: 8),
            Expanded(
              child: _RarityBox(
                label: '橙将',
                percent: '5%',
                color: Color(0xFFFF8C00),
              ),
            ),
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

  const _RarityBox({
    required this.label,
    required this.percent,
    required this.color,
  });

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
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            percent,
            style: TextStyle(color: color.withOpacity(0.8), fontSize: 12),
          ),
        ],
      ),
    );
  }
}
