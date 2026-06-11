import 'package:flutter/material.dart';

/// 武器数据
class _Weapon {
  _Weapon({
    required this.name,
    required this.icon,
    required this.level,
    required this.baseAttack,
    required this.attackPerLevel,
    required this.craftCoinCost,
    required this.craftIronCost,
  });

  final String name;
  final String icon;
  int level;
  final int baseAttack;
  final int attackPerLevel;
  final int craftCoinCost;
  final int craftIronCost;

  int get attack => baseAttack + (level - 1) * attackPerLevel;

  int get upgradeCoinCost => (craftCoinCost * level * 0.5).round();
  int get upgradeIronCost => (craftIronCost * level * 0.5).round();
}

/// 武器坊页面
///
/// 打造、强化、精炼武将装备。
class WeaponWorkshopPage extends StatefulWidget {
  const WeaponWorkshopPage({super.key});

  @override
  State<WeaponWorkshopPage> createState() => _WeaponWorkshopPageState();
}

class _WeaponWorkshopPageState extends State<WeaponWorkshopPage> {
  int _coins = 125000;
  int _iron = 1250;
  int _gems = 300;
  bool _isForge = true; // true=锻造, false=强化

  late final List<_Weapon> _ownedWeapons;
  late final List<_Weapon> _craftableWeapons;

  @override
  void initState() {
    super.initState();
    _ownedWeapons = [
      _Weapon(name: '审虑剑', icon: '🗡️', level: 3, baseAttack: 60, attackPerLevel: 30, craftCoinCost: 30000, craftIronCost: 300),
      _Weapon(name: '丈八蛇矛', icon: '🐍', level: 2, baseAttack: 80, attackPerLevel: 35, craftCoinCost: 40000, craftIronCost: 400),
    ];

    _craftableWeapons = [
      _Weapon(name: '方天画戟', icon: '🔱', level: 1, baseAttack: 100, attackPerLevel: 45, craftCoinCost: 50000, craftIronCost: 500),
      _Weapon(name: '诡刺逐野', icon: '⚔️', level: 1, baseAttack: 50, attackPerLevel: 25, craftCoinCost: 20000, craftIronCost: 200),
      _Weapon(name: '青龙偃月刀', icon: '🐉', level: 1, baseAttack: 120, attackPerLevel: 50, craftCoinCost: 80000, craftIronCost: 800),
      _Weapon(name: '双股剑', icon: '⚔️', level: 1, baseAttack: 45, attackPerLevel: 20, craftCoinCost: 15000, craftIronCost: 150),
    ];
  }

  void _showRules() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: Color(0xFFD4A84B), size: 22),
            SizedBox(width: 8),
            Text('武器坊规则', style: TextStyle(color: Color(0xFFE8D5A3))),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _RuleItem(icon: '🔨', text: '锻造：消耗铜钱和铁矿打造新武器'),
            SizedBox(height: 8),
            _RuleItem(icon: '⬆️', text: '强化：消耗资源提升已拥有武器的等级和攻击力'),
            SizedBox(height: 8),
            _RuleItem(icon: '⬆️', text: '每提升1级，攻击力增加固定数值'),
            SizedBox(height: 8),
            _RuleItem(icon: '💎', text: '强化消耗随等级递增'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('知道了', style: TextStyle(color: Color(0xFFD4A84B))),
          ),
        ],
      ),
    );
  }

  void _craft(_Weapon weapon) {
    if (_coins < weapon.craftCoinCost || _iron < weapon.craftIronCost) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('资源不足，无法锻造'), duration: Duration(seconds: 1)));
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Text(weapon.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            const Text('锻造武器', style: TextStyle(color: Color(0xFFE8D5A3))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(weapon.name, style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text('攻击力: +${weapon.attack}', style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 14)),
            const SizedBox(height: 8),
            Text('需要: 🪙${_formatNum(weapon.craftCoinCost)}  🔩${weapon.craftIronCost}', style: const TextStyle(color: Color(0x998B7E6A), fontSize: 13)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消', style: TextStyle(color: Color(0x668B7E6A)))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4A84B), foregroundColor: const Color(0xFF1A1111)),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _coins -= weapon.craftCoinCost;
                _iron -= weapon.craftIronCost;
                _craftableWeapons.remove(weapon);
                _ownedWeapons.add(weapon);
              });
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text('锻造成功: ${weapon.name}！'), backgroundColor: const Color(0xFFD4A84B), duration: const Duration(seconds: 1)));
            },
            child: const Text('确认锻造'),
          ),
        ],
      ),
    );
  }

  void _upgrade(_Weapon weapon) {
    final coinCost = weapon.upgradeCoinCost;
    final ironCost = weapon.upgradeIronCost;

    if (_coins < coinCost || _iron < ironCost) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(const SnackBar(content: Text('资源不足，无法强化'), duration: Duration(seconds: 1)));
      return;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Text(weapon.icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 8),
            Text('强化 ${weapon.name}', style: const TextStyle(color: Color(0xFFE8D5A3))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Lv.${weapon.level} → Lv.${weapon.level + 1}', style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('攻击力: +${weapon.attack} → +${weapon.attack + weapon.attackPerLevel}', style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 13)),
            const SizedBox(height: 8),
            Text('消耗: 🪙${_formatNum(coinCost)}  🔩$ironCost', style: const TextStyle(color: Color(0x998B7E6A), fontSize: 13)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消', style: TextStyle(color: Color(0x668B7E6A)))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4A84B), foregroundColor: const Color(0xFF1A1111)),
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _coins -= coinCost;
                _iron -= ironCost;
                weapon.level++;
              });
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text('${weapon.name} 强化至 Lv.${weapon.level}！'), backgroundColor: const Color(0xFF4CAF50), duration: const Duration(seconds: 1)));
            },
            child: const Text('确认强化'),
          ),
        ],
      ),
    );
  }

  String _formatNum(int n) {
    if (n >= 10000) return '${(n / 10000).toStringAsFixed(1)}万';
    return n.toString();
  }

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
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: _WorkshopPanel(
              isForge: _isForge,
              ownedWeapons: _ownedWeapons,
              craftableWeapons: _craftableWeapons,
              coins: _coins,
              iron: _iron,
              gems: _gems,
              onRules: _showRules,
              onTabChange: (v) => setState(() => _isForge = v),
              onCraft: _craft,
              onUpgrade: _upgrade,
            ),
          ),
        ],
      ),
    );
  }
}

/// 武器坊面板
class _WorkshopPanel extends StatelessWidget {
  const _WorkshopPanel({
    required this.isForge,
    required this.ownedWeapons,
    required this.craftableWeapons,
    required this.coins,
    required this.iron,
    required this.gems,
    required this.onRules,
    required this.onTabChange,
    required this.onCraft,
    required this.onUpgrade,
  });

  final bool isForge;
  final List<_Weapon> ownedWeapons;
  final List<_Weapon> craftableWeapons;
  final int coins;
  final int iron;
  final int gems;
  final VoidCallback onRules;
  final ValueChanged<bool> onTabChange;
  final ValueChanged<_Weapon> onCraft;
  final ValueChanged<_Weapon> onUpgrade;

  String _fmt(int n) {
    if (n >= 10000) return '${(n / 10000).toStringAsFixed(1)}万';
    return n.toString();
  }

  @override
  Widget build(BuildContext context) {
    final weapons = isForge ? craftableWeapons : ownedWeapons;
    final actionLabel = isForge ? '锻造' : '强化';
    final sampleCost = weapons.isNotEmpty ? (isForge ? weapons.first.craftCoinCost : weapons.first.upgradeCoinCost) : 50000;
    final sampleIron = weapons.isNotEmpty ? (isForge ? weapons.first.craftIronCost : weapons.first.upgradeIronCost) : 500;

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
          _PanelHeader(onRules: onRules),
          const SizedBox(height: 12),
          _TabBar(isForge: isForge, onChanged: onTabChange),
          const SizedBox(height: 12),
          if (weapons.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text('暂无武器', style: TextStyle(color: Color(0x668B7E6A), fontSize: 14)),
            )
          else
            ...weapons.map((w) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: _WeaponItem(
                    icon: w.icon,
                    name: w.name,
                    level: w.level,
                    attack: w.attack,
                    label: actionLabel,
                    cost: '🪙${_fmt(isForge ? w.craftCoinCost : w.upgradeCoinCost)}  🔩${isForge ? w.craftIronCost : w.upgradeIronCost}',
                    onTap: () => isForge ? onCraft(w) : onUpgrade(w),
                  ),
                )),
          const SizedBox(height: 12),
          _ResourceBar(
            coins: coins,
            iron: iron,
            gems: gems,
            requiredCoins: sampleCost,
            requiredIron: sampleIron,
            fmt: _fmt,
          ),
        ],
      ),
    );
  }
}

/// 面板标题 + 规则说明
class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.onRules});
  final VoidCallback onRules;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _goldLine(width: 30),
            const SizedBox(width: 10),
            const Text('武器坊', style: TextStyle(color: Color(0xFFE8D5A3), fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(width: 10),
            _goldLine(width: 30),
          ],
        ),
        GestureDetector(
          onTap: onRules,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(border: Border.all(color: const Color(0x60D4A84B)), borderRadius: BorderRadius.circular(12)),
            child: const Text('规则说明', style: TextStyle(color: Color(0xCCD4A84B), fontSize: 12)),
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
        gradient: LinearGradient(colors: [Color(0x00D4A84B), Color(0xFFD4A84B), Color(0x00D4A84B)]),
      ),
    );
  }
}

/// 锻造 / 强化 Tab
class _TabBar extends StatelessWidget {
  const _TabBar({required this.isForge, required this.onChanged});
  final bool isForge;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(true),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isForge ? const Color(0x30D4A84B) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: isForge ? const Color(0x60D4A84B) : const Color(0x20FFFFFF)),
              ),
              child: Center(
                child: Text('锻造', style: TextStyle(color: isForge ? const Color(0xFFE8D5A3) : const Color(0x668B7E6A), fontSize: 14, fontWeight: isForge ? FontWeight.bold : FontWeight.normal)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: GestureDetector(
            onTap: () => onChanged(false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: !isForge ? const Color(0x30D4A84B) : Colors.transparent,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: !isForge ? const Color(0x60D4A84B) : const Color(0x20FFFFFF)),
              ),
              child: Center(
                child: Text('强化', style: TextStyle(color: !isForge ? const Color(0xFFE8D5A3) : const Color(0x668B7E6A), fontSize: 14, fontWeight: !isForge ? FontWeight.bold : FontWeight.normal)),
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
  const _WeaponItem({
    required this.icon,
    required this.name,
    required this.level,
    required this.attack,
    required this.label,
    required this.cost,
    required this.onTap,
  });
  final String icon;
  final String name;
  final int level;
  final int attack;
  final String label;
  final String cost;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0x10D4A84B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0x18D4A84B)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: const Color(0x20D4A84B), borderRadius: BorderRadius.circular(6)),
              child: Center(child: Text(icon, style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(name, style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 14)),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                        decoration: BoxDecoration(color: const Color(0x20D4A84B), borderRadius: BorderRadius.circular(3)),
                        child: Text('Lv.$level', style: const TextStyle(color: Color(0xCCD4A84B), fontSize: 9)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text('攻击 +$attack', style: const TextStyle(color: Color(0xFF4CAF50), fontSize: 11)),
                      const SizedBox(width: 8),
                      Text(cost, style: const TextStyle(color: Color(0x668B7E6A), fontSize: 10)),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFD4A84B), Color(0xFFB8922E)]),
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                child: Text(label, style: const TextStyle(color: Color(0xFF1A1111), fontSize: 13, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 底部资源消耗
class _ResourceBar extends StatelessWidget {
  const _ResourceBar({
    required this.coins,
    required this.iron,
    required this.gems,
    required this.requiredCoins,
    required this.requiredIron,
    required this.fmt,
  });

  final int coins;
  final int iron;
  final int gems;
  final int requiredCoins;
  final int requiredIron;
  final String Function(int) fmt;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _ResourceItem(icon: '🪙', current: fmt(coins), required: '/${fmt(requiredCoins)}', isMet: coins >= requiredCoins),
        _ResourceItem(icon: '🔩', current: fmt(iron), required: '/$requiredIron', isMet: iron >= requiredIron),
        _ResourceItem(icon: '💎', current: '$gems', required: '', isMet: true),
      ],
    );
  }
}

class _ResourceItem extends StatelessWidget {
  const _ResourceItem({required this.icon, required this.current, required this.required, required this.isMet});
  final String icon;
  final String current;
  final String required;
  final bool isMet;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 4),
        Text(current, style: TextStyle(color: isMet ? const Color(0xFF4CAF50) : const Color(0xFFD32F2F), fontSize: 12, fontWeight: FontWeight.bold)),
        Text(required, style: const TextStyle(color: Color(0x668B7E6A), fontSize: 11)),
      ],
    );
  }
}

class _RuleItem extends StatelessWidget {
  const _RuleItem({required this.icon, required this.text});
  final String icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(color: Color(0x998B7E6A), fontSize: 13, height: 1.5))),
      ],
    );
  }
}
