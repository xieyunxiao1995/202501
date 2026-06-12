import 'package:flutter/material.dart';

/// 物品类别
enum _ItemCategory { prop, equipment, material, treasure }

/// 物品条目
class _PackageItem {
  _PackageItem({
    required this.name,
    required this.icon,
    required this.count,
    required this.category,
    this.rarity,
    this.desc,
    this.suffix = '',
  });

  final String name;
  final String icon;
  int count;
  final _ItemCategory category;
  final String? rarity;
  final String? desc;
  final String suffix;
}

/// 背包页面
class PackagePage extends StatefulWidget {
  const PackagePage({super.key});

  @override
  State<PackagePage> createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {
  int _selectedTab = 0; // 0=全部, 1=道具, 2=装备, 3=材料, 4=宝物

  late final List<_PackageItem> _items;

  static const _tabLabels = ['全部', '道具', '装备', '材料', '宝物'];

  int _coins = 12340000;
  int _gems = 12345;

  String _fmt(int n) {
    if (n >= 10000) return '${(n / 10000).toStringAsFixed(1)}万';
    return n.toString();
  }

  @override
  void initState() {
    super.initState();
    _items = [
      // 道具
      _PackageItem(name: '武将招募令', icon: '📜', count: 12, category: _ItemCategory.prop, rarity: '稀有', desc: '在酒馆招募武将的凭证'),
      _PackageItem(name: '铜钱', icon: '🪙', count: 123000, category: _ItemCategory.prop, rarity: '普通', desc: '游戏通用货币', suffix: '万'),
      _PackageItem(name: '元宝', icon: '💎', count: 12345, category: _ItemCategory.prop, rarity: '稀有', desc: '珍贵货币，可购买稀有道具'),
      _PackageItem(name: '体力丹', icon: '🍡', count: 25, category: _ItemCategory.prop, rarity: '普通', desc: '恢复30点体力'),
      _PackageItem(name: '经验书', icon: '📙', count: 120, category: _ItemCategory.prop, rarity: '普通', desc: '武将获得500经验'),
      _PackageItem(name: '高级经验书', icon: '📕', count: 36, category: _ItemCategory.prop, rarity: '稀有', desc: '武将获得5000经验'),
      _PackageItem(name: '武将碎片', icon: '🧩', count: 58, category: _ItemCategory.prop, rarity: '史诗', desc: '集齐可合成武将'),
      // 装备
      _PackageItem(name: '装备强化石', icon: '💎', count: 276, category: _ItemCategory.equipment, rarity: '普通', desc: '用于强化装备'),
      _PackageItem(name: '突破石', icon: '🔮', count: 96, category: _ItemCategory.equipment, rarity: '稀有', desc: '装备突破所需'),
      _PackageItem(name: '精铁', icon: '🔩', count: 420, category: _ItemCategory.equipment, rarity: '普通', desc: '锻造武器材料'),
      _PackageItem(name: '星辉石', icon: '🌟', count: 22, category: _ItemCategory.equipment, rarity: '史诗', desc: '装备升星材料'),
      // 材料
      _PackageItem(name: '木材', icon: '🪵', count: 123000, category: _ItemCategory.material, rarity: '普通', desc: '建筑升级材料', suffix: '万'),
      _PackageItem(name: '铁矿', icon: '⛏️', count: 123000, category: _ItemCategory.material, rarity: '普通', desc: '锻造武器材料', suffix: '万'),
      _PackageItem(name: '石料', icon: '🪨', count: 123000, category: _ItemCategory.material, rarity: '普通', desc: '建筑升级材料', suffix: '万'),
      _PackageItem(name: '粮草', icon: '🌾', count: 123000, category: _ItemCategory.material, rarity: '普通', desc: '行军打仗的粮食', suffix: '万'),
      _PackageItem(name: '军功', icon: '🎖️', count: 32000, category: _ItemCategory.material, rarity: '稀有', desc: '征战获得的功勋', suffix: '万'),
      // 宝物
      _PackageItem(name: '宝物精华', icon: '💠', count: 48, category: _ItemCategory.treasure, rarity: '史诗', desc: '用于升级宝物'),
      _PackageItem(name: '传国玉玺碎片', icon: '🏆', count: 8, category: _ItemCategory.treasure, rarity: '传说', desc: '集齐30个合成传国玉玺'),
      _PackageItem(name: '青龙玉佩', icon: '🐉', count: 3, category: _ItemCategory.treasure, rarity: '传说', desc: '佩戴后提升全体攻击力'),
      _PackageItem(name: '玄武盾', icon: '🐢', count: 5, category: _ItemCategory.treasure, rarity: '史诗', desc: '佩戴后提升全体防御力'),
    ];
  }

  List<_PackageItem> get _filteredItems {
    switch (_selectedTab) {
      case 1:
        return _items.where((i) => i.category == _ItemCategory.prop).toList();
      case 2:
        return _items.where((i) => i.category == _ItemCategory.equipment).toList();
      case 3:
        return _items.where((i) => i.category == _ItemCategory.material).toList();
      case 4:
        return _items.where((i) => i.category == _ItemCategory.treasure).toList();
      default:
        return _items;
    }
  }

  String _categoryTitle(_ItemCategory cat) {
    switch (cat) {
      case _ItemCategory.prop:
        return '道具';
      case _ItemCategory.equipment:
        return '装备';
      case _ItemCategory.material:
        return '材料';
      case _ItemCategory.treasure:
        return '宝物';
    }
  }

  void _showItemDetail(_PackageItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Text(item.icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 16, fontWeight: FontWeight.bold)),
                  if (item.rarity != null)
                    Text(item.rarity!, style: const TextStyle(color: Color(0x998B7E6A), fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (item.desc != null)
              Text(item.desc!, style: const TextStyle(color: Color(0x998B7E6A), fontSize: 13, height: 1.5)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DetailAction(
                  icon: '🎁',
                  label: '使用',
                  onTap: () {
                    Navigator.pop(ctx);
                    setState(() => item.count > 0 ? item.count-- : _items.remove(item));
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(content: Text('已使用 ${item.name}'), backgroundColor: const Color(0xFF4CAF50), duration: const Duration(seconds: 1)));
                  },
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('关闭', style: TextStyle(color: Color(0xFFD4A84B)))),
        ],
      ),
    );
  }

  void _batchSell() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xEE1A1A2A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('批量出售', style: TextStyle(color: Color(0xFFE8D5A3))),
        content: const Text('选择要出售的物品', style: TextStyle(color: Color(0x668B7E6A))),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消', style: TextStyle(color: Color(0x668B7E6A)))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD4A84B), foregroundColor: const Color(0xFF1A1111)),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(const SnackBar(content: Text('批量出售功能开发中'), duration: Duration(seconds: 1)));
            },
            child: const Text('确认'),
          ),
        ],
      ),
    );
  }

  void _sortBag() {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(const SnackBar(content: Text('背包已整理'), backgroundColor: Color(0xFF4CAF50), duration: Duration(seconds: 1)));
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('背包'),
        backgroundColor: const Color.fromARGB(0, 240, 237, 237),
        elevation: 0,
        centerTitle: false,
        titleSpacing: 20,
        actions: [
          _CurrencyChip(icon: '🪙', value: _fmt(_coins)),
          const SizedBox(width: 6),
          _CurrencyChip(icon: '💎', value: '$_gems'),
          const SizedBox(width: 12),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/images/city/jiuguan.png'), fit: BoxFit.cover),
        ),
        child: Column(
          children: [
            const SizedBox(height: 150),
            // 分类 Tab
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: List.generate(_tabLabels.length, (i) {
                  final active = _selectedTab == i;
                  return Padding(
                    padding: EdgeInsets.only(right: i < _tabLabels.length - 1 ? 6 : 0),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedTab = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          color: active ? const Color(0xFFD4A84B) : const Color(0x18D4A84B),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          _tabLabels[i],
                          style: TextStyle(
                            color: active ? const Color(0xFF1A1111) : const Color(0xCCD4A84B),
                            fontSize: 13,
                            fontWeight: active ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 10),
            // 内容区
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('暂无物品', style: TextStyle(color: Color(0x668B7E6A), fontSize: 14)))
                  : Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xCC1A1111), Color(0xF21A1111)]),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        border: Border(top: BorderSide(color: Color(0x40D4A84B), width: 1)),
                      ),
                      child: _selectedTab == 0 ? _buildAllView(filtered) : _buildCategoryGrid(filtered),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// "全部"视图：按分类分组 + 底部按钮
  Widget _buildAllView(List<_PackageItem> items) {
    final groups = <_ItemCategory, List<_PackageItem>>{};
    for (final item in items) {
      groups.putIfAbsent(item.category, () => []).add(item);
    }

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            children: groups.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Container(width: 3, height: 14, decoration: BoxDecoration(color: const Color(0xFFD4A84B), borderRadius: BorderRadius.circular(2))),
                          const SizedBox(width: 6),
                          Text(_categoryTitle(entry.key), style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 14, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.78,
                      ),
                      itemCount: entry.value.length,
                      itemBuilder: (context, index) => _buildItemCard(entry.value[index]),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        _BottomActions(onBatchSell: _batchSell, onSort: _sortBag),
      ],
    );
  }

  /// 单分类网格视图
  Widget _buildCategoryGrid(List<_PackageItem> items) {
    return Column(
      children: [
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 5,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.78,
            ),
            itemCount: items.length,
            itemBuilder: (context, index) => _buildItemCard(items[index]),
          ),
        ),
        _BottomActions(onBatchSell: _batchSell, onSort: _sortBag),
      ],
    );
  }

  /// 单个物品卡片
  Widget _buildItemCard(_PackageItem item) {
    return GestureDetector(
      onTap: () => _showItemDetail(item),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0x10D4A84B),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0x18D4A84B)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(item.icon, style: const TextStyle(fontSize: 26)),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Text(
                item.name,
                style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 10),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(height: 2),
            if (item.suffix.isNotEmpty)
              Text('${item.count}${item.suffix}', style: const TextStyle(color: Color(0x998B7E6A), fontSize: 9))
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(color: const Color(0x15D4A84B), borderRadius: BorderRadius.circular(4)),
                child: Text('${item.count}', style: const TextStyle(color: Color(0xCCD4A84B), fontSize: 9, fontWeight: FontWeight.bold)),
              ),
          ],
        ),
      ),
    );
  }
}

/// 货币显示组件
class _CurrencyChip extends StatelessWidget {
  const _CurrencyChip({required this.icon, required this.value});
  final String icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(color: const Color(0x30FFFFFF), borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 3),
          Text(value, style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 12, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

/// 底部操作按钮
class _BottomActions extends StatelessWidget {
  const _BottomActions({required this.onBatchSell, required this.onSort});
  final VoidCallback onBatchSell;
  final VoidCallback onSort;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0x10D4A84B))),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onBatchSell,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0x40D4A84B)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(child: Text('批量出售', style: TextStyle(color: Color(0xCCD4A84B), fontSize: 14, fontWeight: FontWeight.bold))),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: GestureDetector(
              onTap: onSort,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [Color(0xFFD4A84B), Color(0xFFB8922E)]),
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: const Center(child: Text('整理背包', style: TextStyle(color: Color(0xFF1A1111), fontSize: 14, fontWeight: FontWeight.bold))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 操作按钮
class _DetailAction extends StatelessWidget {
  const _DetailAction({required this.icon, required this.label, required this.onTap});
  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFD4A84B), Color(0xFFB8922E)]),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: Color(0xFF1A1111), fontSize: 14, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
