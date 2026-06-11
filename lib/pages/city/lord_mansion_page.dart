import 'package:flutter/material.dart';

/// 主公府页面
///
/// 查看主公等级、属性、称号等信息，可消耗资源升级主公府。
class LordMansionPage extends StatefulWidget {
  const LordMansionPage({super.key});

  @override
  State<LordMansionPage> createState() => _LordMansionPageState();
}

class _LordMansionPageState extends State<LordMansionPage> {
  int _level = 18;
  int _xp = 25600;
  double _silver = 12.5; // 万
  int _ore = 1250;

  int get _xpToNext => 10000 + (_level * 2000); // 每级递增2000
  double get _xpProgress => (_xp / _xpToNext).clamp(0.0, 1.0);

  double get _attackBonus => (_level * 0.8).clamp(0, 50);
  double get _defenseBonus => (_level * 0.8).clamp(0, 50);
  double get _hpBonus => (_level * 0.8).clamp(0, 50);
  double get _critBonus => (_level * 0.5).clamp(0, 30);

  bool get _canUpgrade {
    return _xp >= _xpToNext && _silver >= 10 && _ore >= 800;
  }

  void _train() {
    // 修炼获得经验
    final gain = 3000 + (_level * 200);
    setState(() => _xp += gain);
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('修炼完成！获得经验 +$gain'),
        backgroundColor: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 1),
      ));
  }

  void _upgrade() {
    if (!_canUpgrade) {
      final reasons = <String>[];
      if (_xp < _xpToNext) reasons.add('经验不足');
      if (_silver < 10) reasons.add('银两不足');
      if (_ore < 800) reasons.add('矿石不足');
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('升级条件未满足：${reasons.join('、')}'), duration: const Duration(seconds: 2)));
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.arrow_upward, color: Color(0xFFD4A84B)),
            SizedBox(width: 8),
            Text('升级主公府', style: TextStyle(color: Color(0xFFE8D5A3))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lv.$_level → Lv.${_level + 1}', style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _costRow('📜 经验', '$_xp / $_xpToNext'),
            _costRow('🪙 银两', '10 万'),
            _costRow('🔨 矿石', '800'),
            const SizedBox(height: 8),
            Text('全体武将攻击: ${_attackBonus.toStringAsFixed(1)}% → ${((_level + 1) * 0.8).clamp(0, 50).toStringAsFixed(1)}%',
              style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 12)),
            const SizedBox(height: 2),
            Text('全体武将防御: ${_defenseBonus.toStringAsFixed(1)}% → ${((_level + 1) * 0.8).clamp(0, 50).toStringAsFixed(1)}%',
              style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 12)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消', style: TextStyle(color: Color(0x668B7E6A)))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4A84B), foregroundColor: const Color(0xFF1A1111)),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _xp -= _xpToNext;
                _silver -= 10;
                _ore -= 800;
                _level++;
              });
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text('主公府升至 Lv.$_level！全体武将属性提升'),
                  backgroundColor: const Color(0xFFD4A84B),
                  duration: const Duration(seconds: 2),
                ));
            },
            child: const Text('确认升级'),
          ),
        ],
      ),
    );
  }

  static Widget _costRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Color(0x998B7E6A), fontSize: 13))),
          Text(value, style: const TextStyle(color: Color(0xFFE2D9CD), fontSize: 13)),
        ],
      ),
    );
  }

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
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/images/city/zhugongfu.png'), fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: _LordMansionPanel(
              level: _level,
              xp: _xp,
              xpToNext: _xpToNext,
              xpProgress: _xpProgress,
              attackBonus: _attackBonus,
              defenseBonus: _defenseBonus,
              hpBonus: _hpBonus,
              critBonus: _critBonus,
              silver: _silver,
              ore: _ore,
              canUpgrade: _canUpgrade,
              onTrain: _train,
              onUpgrade: _upgrade,
            ),
          ),
        ],
      ),
    );
  }
}

/// 主公府信息面板
class _LordMansionPanel extends StatelessWidget {
  const _LordMansionPanel({
    required this.level,
    required this.xp,
    required this.xpToNext,
    required this.xpProgress,
    required this.attackBonus,
    required this.defenseBonus,
    required this.hpBonus,
    required this.critBonus,
    required this.silver,
    required this.ore,
    required this.canUpgrade,
    required this.onTrain,
    required this.onUpgrade,
  });

  final int level;
  final int xp;
  final int xpToNext;
  final double xpProgress;
  final double attackBonus;
  final double defenseBonus;
  final double hpBonus;
  final double critBonus;
  final double silver;
  final int ore;
  final bool canUpgrade;
  final VoidCallback onTrain;
  final VoidCallback onUpgrade;

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
          const SizedBox(height: 12),
          _LevelSection(level: level, xp: xp, xpToNext: xpToNext, progress: xpProgress),
          const SizedBox(height: 10),
          // 修炼按钮
          GestureDetector(
            onTap: onTrain,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0x18D4A84B),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0x40D4A84B)),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('📖', style: TextStyle(fontSize: 14)),
                  SizedBox(width: 6),
                  Text('修炼', style: TextStyle(color: Color(0xFFD4A84B), fontSize: 13, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 14),
          _BonusStatsSection(attack: attackBonus, defense: defenseBonus, hp: hpBonus, crit: critBonus),
          const SizedBox(height: 14),
          _UpgradeConditionsSection(xp: xp, xpToNext: xpToNext, silver: silver, ore: ore),
          const SizedBox(height: 20),
          _UpgradeButton(canUpgrade: canUpgrade, onTap: onUpgrade),
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
        const Text('主公府', style: TextStyle(color: Color(0xFFE8D5A3), fontSize: 20, fontWeight: FontWeight.bold)),
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

/// 等级 & 经验条
class _LevelSection extends StatelessWidget {
  const _LevelSection({required this.level, required this.xp, required this.xpToNext, required this.progress});
  final int level;
  final int xp;
  final int xpToNext;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0x33D4A84B),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0x80D4A84B)),
          ),
          child: Text('Lv.$level', style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 14, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('$xp / $xpToNext', style: const TextStyle(color: Color(0x998B7E6A), fontSize: 12)),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress, minHeight: 8,
                  backgroundColor: const Color(0x33FFFFFF),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4A84B)),
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
  const _BonusStatsSection({required this.attack, required this.defense, required this.hp, required this.crit});
  final double attack;
  final double defense;
  final double hp;
  final double crit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0x18D4A84B), borderRadius: BorderRadius.circular(8), border: Border.all(color: const Color(0x20D4A84B))),
      child: Column(
        children: [
          _BonusRow(icon: '⚔️', label: '全体武将攻击', value: '+${attack.toStringAsFixed(1)}%'),
          const SizedBox(height: 6),
          _BonusRow(icon: '🛡️', label: '全体武将防御', value: '+${defense.toStringAsFixed(1)}%'),
          const SizedBox(height: 6),
          _BonusRow(icon: '❤️', label: '全体武将兵力', value: '+${hp.toStringAsFixed(1)}%'),
          const SizedBox(height: 6),
          _BonusRow(icon: '💥', label: '全体武将暴击', value: '+${crit.toStringAsFixed(1)}%'),
        ],
      ),
    );
  }
}

class _BonusRow extends StatelessWidget {
  const _BonusRow({required this.icon, required this.label, required this.value});
  final String icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Expanded(child: Text(label, style: const TextStyle(color: Color(0xCC8B7E6A), fontSize: 13))),
        Text(value, style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }
}

/// 升级条件
class _UpgradeConditionsSection extends StatelessWidget {
  const _UpgradeConditionsSection({required this.xp, required this.xpToNext, required this.silver, required this.ore});
  final int xp;
  final int xpToNext;
  final double silver;
  final int ore;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('升级条件', style: TextStyle(color: Color(0xCC8B7E6A), fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        _ConditionRow(icon: '📜', label: '主公经验', current: xp.toDouble(), required: xpToNext.toDouble(), suffix: '', isMet: xp >= xpToNext),
        const SizedBox(height: 4),
        _ConditionRow(icon: '🪙', label: '银两', current: silver, required: 10, suffix: '万', isMet: silver >= 10),
        const SizedBox(height: 4),
        _ConditionRow(icon: '🔨', label: '矿石', current: ore.toDouble(), required: 800, suffix: '', isMet: ore >= 800),
      ],
    );
  }
}

class _ConditionRow extends StatelessWidget {
  const _ConditionRow({required this.icon, required this.label, required this.current, required this.required, required this.suffix, required this.isMet});
  final String icon;
  final String label;
  final double current;
  final double required;
  final String suffix;
  final bool isMet;

  @override
  Widget build(BuildContext context) {
    final progress = required <= 0 ? 1.0 : (current / required).clamp(0.0, 1.0);
    final metColor = isMet ? const Color(0xFF4CAF50) : const Color(0xFFD4A84B);

    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 6),
        SizedBox(width: 56, child: Text(label, style: const TextStyle(color: Color(0x998B7E6A), fontSize: 12))),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(value: progress, minHeight: 6, backgroundColor: const Color(0x33FFFFFF), valueColor: AlwaysStoppedAnimation<Color>(metColor)),
          ),
        ),
        const SizedBox(width: 8),
        Text('${_fmt(current)}$suffix / ${_fmt(required)}$suffix',
          style: TextStyle(color: isMet ? const Color(0xFF4CAF50) : const Color(0x998B7E6A), fontSize: 11)),
      ],
    );
  }

  static String _fmt(double n) {
    if (n == n.roundToDouble() && n < 10000) return n.toInt().toString();
    return n.toStringAsFixed(1);
  }
}

/// 升级按钮
class _UpgradeButton extends StatelessWidget {
  const _UpgradeButton({required this.canUpgrade, required this.onTap});
  final bool canUpgrade;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: canUpgrade ? const Color(0xFFD4A84B) : const Color(0x30D4A84B),
          foregroundColor: canUpgrade ? const Color(0xFF1A1111) : const Color(0x408B7E6A),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          elevation: 0,
        ),
        child: const Text('升  级'),
      ),
    );
  }
}
