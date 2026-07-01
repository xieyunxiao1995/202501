import 'dart:math';

import 'package:flutter/material.dart';

/// 资源数据
class _ResData {
  _ResData({required this.icon, required this.label, required this.amount, required this.unit, required this.useDesc, required this.useCost, required this.useGain});

  final String icon;
  final String label;
  int amount;
  final String unit;
  final String useDesc; // 使用效果描述
  final int useCost; // 每次消耗量
  final String useGain; // 使用获得
}

/// 粮仓页面
///
/// 储存和管理粮食资源。
class GranaryPage extends StatefulWidget {
  const GranaryPage({super.key});

  @override
  State<GranaryPage> createState() => _GranaryPageState();
}

class _GranaryPageState extends State<GranaryPage> {
  final Random _rng = Random();

  late final List<_ResData> _resources;

  @override
  void initState() {
    super.initState();
    _resources = [
      _ResData(icon: '🌾', label: '粮食', amount: 1257000, unit: '万', useDesc: '消耗 5 万粮食可训练一批士兵，提升兵力上限', useCost: 50000, useGain: '兵力上限 +200'),
      _ResData(icon: '🪵', label: '木材', amount: 853000, unit: '万', useDesc: '消耗 3 万木材可升级建筑，缩短建造时间', useCost: 30000, useGain: '建造速度 +5%'),
      _ResData(icon: '⛏️', label: '铁矿', amount: 652000, unit: '万', useDesc: '消耗 2 万铁矿可打造装备，提升武将属性', useCost: 20000, useGain: '随机武将攻击 +50'),
      _ResData(icon: '🪨', label: '石料', amount: 456000, unit: '万', useDesc: '消耗 2 万石料加固城墙，提升城防值', useCost: 20000, useGain: '城防值 +100'),
    ];
  }

  String _formatAmount(int amount) {
    if (amount >= 10000) return '${(amount / 10000).toStringAsFixed(1)}万';
    if (amount >= 1000) return '${(amount / 1000).toStringAsFixed(1)}千';
    return amount.toString();
  }

  void _useResource(int index) {
    final res = _resources[index];
    if (res.amount < res.useCost) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text('${res.label}不足，至少需要 ${_formatAmount(res.useCost)}'), duration: const Duration(seconds: 1)));
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Text(res.icon, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 8),
            Text('使用 $res.label', style: const TextStyle(color: Color(0xFFE8D5A3))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(res.useDesc, style: const TextStyle(color: Color(0x998B7E6A), fontSize: 13, height: 1.5)),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text('消耗: ', style: TextStyle(color: Color(0x998B7E6A))),
                Text('${res.icon} ${_formatAmount(res.useCost)}', style: const TextStyle(color: Color(0xFFA11717), fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                const Text('获得: ', style: TextStyle(color: Color(0x998B7E6A))),
                Text(res.useGain, style: const TextStyle(color: Color(0xFF4CAF50), fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消', style: TextStyle(color: Color(0x668B7E6A)))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4A84B), foregroundColor: const Color(0xFF1A1111)),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() => res.amount -= res.useCost);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text('消耗 ${res.label} ${_formatAmount(res.useCost)}，${res.useGain}！'),
                  backgroundColor: const Color(0xFF4CAF50),
                  duration: const Duration(seconds: 2),
                ));
            },
            child: const Text('确认使用'),
          ),
        ],
      ),
    );
  }

  void _collectResources() {
    // 采集：每种资源随机增加
    final gains = <String>[];
    setState(() {
      for (final res in _resources) {
        final gain = 10000 + _rng.nextInt(20000);
        res.amount += gain;
        gains.add('${res.icon}+${_formatAmount(gain)}');
      }
    });
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(
        content: Text('采集完成！${gains.join('  ')}'),
        backgroundColor: const Color(0xFF4CAF50),
        duration: const Duration(seconds: 2),
      ));
  }

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
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(image: AssetImage('assets/Bg/Bg11.png'), fit: BoxFit.cover),
              ),
            ),
          ),
          Positioned(
            left: 0, right: 0, bottom: 0,
            child: _GranaryPanel(
              resources: _resources,
              formatAmount: _formatAmount,
              onUse: _useResource,
              onCollect: _collectResources,
            ),
          ),
        ],
      ),
    );
  }
}

/// 粮仓面板
class _GranaryPanel extends StatelessWidget {
  const _GranaryPanel({
    required this.resources,
    required this.formatAmount,
    required this.onUse,
    required this.onCollect,
  });

  final List<_ResData> resources;
  final String Function(int) formatAmount;
  final ValueChanged<int> onUse;
  final VoidCallback onCollect;

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
          ...resources.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _ResourceItem(
              icon: e.value.icon,
              label: e.value.label,
              amount: formatAmount(e.value.amount),
              onTap: () => onUse(e.key),
            ),
          )),
          const SizedBox(height: 10),
          // 采集按钮
          GestureDetector(
            onTap: onCollect,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF388E3C)]),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.agriculture, color: Colors.white, size: 18),
                  SizedBox(width: 6),
                  Text('采集资源', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
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
        const Text('粮仓', style: TextStyle(color: Color(0xFFE8D5A3), fontSize: 18, fontWeight: FontWeight.bold)),
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

/// 单个资源条目
class _ResourceItem extends StatelessWidget {
  const _ResourceItem({required this.icon, required this.label, required this.amount, required this.onTap});
  final String icon;
  final String label;
  final String amount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0x10D4A84B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0x18D4A84B)),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(color: const Color(0x20D4A84B), borderRadius: BorderRadius.circular(6)),
              child: Center(child: Text(icon, style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(label, style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 14))),
            Text(amount, style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 15, fontWeight: FontWeight.bold)),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFD4A84B), Color(0xFFB8922E)]), borderRadius: BorderRadius.all(Radius.circular(6))),
                child: const Text('使用', style: TextStyle(color: Color(0xFF1A1111), fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
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
        Text('升级建筑可提升资源产出与存储上限', style: TextStyle(color: Color(0x668B7E6A), fontSize: 12)),
      ],
    );
  }
}
