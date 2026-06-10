import 'package:flutter/material.dart';

/// 主公府页面
///
/// 查看主公等级、属性、称号等信息，可消耗资源升级主公府。
class LordMansionPage extends StatelessWidget {
  const LordMansionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('主公府'),
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
                  image: AssetImage('assets/images/city/zhugongfu.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          // 底部信息面板
          Positioned(left: 0, right: 0, bottom: 0, child: _LordMansionPanel()),
        ],
      ),
    );
  }
}

/// 主公府信息面板
class _LordMansionPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [const Color(0xCC1A1111), const Color(0xF21A1111)],
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
          // ---- 标题栏 ----
          _PanelTitle(),
          const SizedBox(height: 12),

          // ---- 等级与经验 ----
          _LevelSection(),
          const SizedBox(height: 14),

          // ---- 属性加成 ----
          _BonusStatsSection(),
          const SizedBox(height: 14),

          // ---- 升级条件 ----
          _UpgradeConditionsSection(),
          const SizedBox(height: 20),

          // ---- 升级按钮 ----
          _UpgradeButton(),
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
          '主公府',
          style: TextStyle(
            color: Color(0xFFE8D5A3),
            fontSize: 20,
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
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0x00D4A84B), Color(0xFFD4A84B), Color(0x00D4A84B)],
        ),
      ),
    );
  }
}

/// 等级 & 经验条
class _LevelSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 等级徽章
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0x33D4A84B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x80D4A84B), width: 1),
          ),
          child: const Text(
            'Lv.18',
            style: TextStyle(
              color: Color(0xFFE8D5A3),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 10),
        // 经验进度条
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '25600 / 50000',
                style: TextStyle(color: Color(0x998B7E6A), fontSize: 12),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: 25600 / 50000,
                  minHeight: 8,
                  backgroundColor: const Color(0x33FFFFFF),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFFD4A84B),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// 属性加成列表
class _BonusStatsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0x18D4A84B),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0x20D4A84B)),
      ),
      child: const Column(
        children: [
          _BonusRow(icon: '⚔️', label: '全体武将攻击', value: '+15%'),
          SizedBox(height: 6),
          _BonusRow(icon: '🛡️', label: '全体武将防御', value: '+15%'),
          SizedBox(height: 6),
          _BonusRow(icon: '❤️', label: '全体武将兵力', value: '+15%'),
          SizedBox(height: 6),
          _BonusRow(icon: '💥', label: '全体武将暴击', value: '+10%'),
        ],
      ),
    );
  }
}

class _BonusRow extends StatelessWidget {
  final String icon;
  final String label;
  final String value;

  const _BonusRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xCC8B7E6A), fontSize: 13),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Color(0xFF4CAF50),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// 升级条件
class _UpgradeConditionsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '升级条件',
          style: TextStyle(
            color: Color(0xCC8B7E6A),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        _ConditionRow(
          icon: '📜',
          label: '主公经验',
          current: 25600,
          required: 50000,
          suffix: '',
        ),
        const SizedBox(height: 4),
        _ConditionRow(
          icon: '🪙',
          label: '银两',
          current: 12.5,
          required: 10,
          suffix: '万',
          isMet: true,
        ),
        const SizedBox(height: 4),
        _ConditionRow(
          icon: '🔨',
          label: '矿石',
          current: 1250,
          required: 800,
          suffix: '',
          isMet: true,
        ),
      ],
    );
  }
}

class _ConditionRow extends StatelessWidget {
  final String icon;
  final String label;
  final num current;
  final num required;
  final String suffix;
  final bool isMet;

  const _ConditionRow({
    required this.icon,
    required this.label,
    required this.current,
    required this.required,
    required this.suffix,
    this.isMet = false,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (current / required).clamp(0.0, 1.0);
    final metColor = isMet ? const Color(0xFF4CAF50) : const Color(0xFFD4A84B);

    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 6),
        SizedBox(
          width: 56,
          child: Text(
            label,
            style: const TextStyle(color: Color(0x998B7E6A), fontSize: 12),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: const Color(0x33FFFFFF),
              valueColor: AlwaysStoppedAnimation<Color>(metColor),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '$current$suffix / $required$suffix',
          style: TextStyle(
            color: isMet ? const Color(0xFF4CAF50) : const Color(0x998B7E6A),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

/// 升级按钮
class _UpgradeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: () {
          // TODO: 升级逻辑
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFD4A84B),
          foregroundColor: const Color(0xFF1A1111),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: const Text('升  级'),
      ),
    );
  }
}
