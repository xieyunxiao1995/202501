import 'package:flutter/material.dart';

/// 物品条目
class _PackageItem {
  _PackageItem({
    required this.name,
    required this.icon,
    required this.count,
    required this.rarity,
    required this.desc,
  });
  final String name;
  final String icon;
  int count;
  final String rarity; // 普通/稀有/史诗/传说
  final String desc;
}

/// 背包页面
///
/// 查看和管理所有物品、道具、材料。
class PackagePage extends StatefulWidget {
  const PackagePage({super.key});

  @override
  State<PackagePage> createState() => _PackagePageState();
}

class _PackagePageState extends State<PackagePage> {
  static const _rarityColors = {
    '普通': Color(0xFF9E9E9E),
    '稀有': Color(0xFF42A5F5),
    '史诗': Color(0xFFAB47BC),
    '传说': Color(0xFFFF8C00),
  };

  int _selectedTab = 0; // 0=全部, 1=材料, 2=道具, 3=碎片

  late final List<_PackageItem> _items;

  @override
  void initState() {
    super.initState();
    _items = [
      _PackageItem(name: '强化石', icon: '💎', count: 128, rarity: '普通', desc: '用于装备强化，提升装备属性'),
      _PackageItem(name: '招募令', icon: '📜', count: 12, rarity: '稀有', desc: '在酒馆招募武将的凭证'),
      _PackageItem(name: '体力丹', icon: '🍡', count: 35, rarity: '普通', desc: '恢复30点体力'),
      _PackageItem(name: '进阶石', icon: '🔮', count: 56, rarity: '稀有', desc: '武将进阶所需材料'),
      _PackageItem(name: '精铁', icon: '🔩', count: 420, rarity: '普通', desc: '锻造武器的基础材料'),
      _PackageItem(name: '粮草包', icon: '🌾', count: 18, rarity: '普通', desc: '使用后获得5000粮草'),
      _PackageItem(name: '银两箱', icon: '🪙', count: 8, rarity: '稀有', desc: '使用后获得20000铜钱'),
      _PackageItem(name: '关羽碎片', icon: '🗡️', count: 28, rarity: '史诗', desc: '集齐60个可合成武将关羽'),
      _PackageItem(name: '诸葛亮碎片', icon: '📖', count: 15, rarity: '传说', desc: '集齐60个可合成武将诸葛亮'),
      _PackageItem(name: '赵云碎片', icon: '🏇', count: 42, rarity: '史诗', desc: '集齐60个可合成武将赵云'),
      _PackageItem(name: '技能书', icon: '📘', count: 7, rarity: '稀有', desc: '用于升级武将技能'),
      _PackageItem(name: '觉醒石', icon: '✨', count: 3, rarity: '传说', desc: '武将觉醒所需珍贵材料'),
      _PackageItem(name: '经验书', icon: '📙', count: 25, rarity: '普通', desc: '使用后武将获得500经验'),
      _PackageItem(name: '吕布碎片', icon: '⚔️', count: 9, rarity: '传说', desc: '集齐60个可合成武将吕布'),
      _PackageItem(name: '马鞍', icon: '🐴', count: 14, rarity: '稀有', desc: '培养战马的必备道具'),
      _PackageItem(name: '星辉石', icon: '🌟', count: 22, rarity: '史诗', desc: '武将升星所需材料'),
    ];
  }

  List<_PackageItem> get _filteredItems {
    switch (_selectedTab) {
      case 1:
        return _items.where((i) => i.rarity == '普通').toList();
      case 2:
        return _items.where((i) => i.rarity == '稀有' || i.rarity == '史诗' || i.rarity == '传说').toList();
      case 3:
        return _items.where((i) => i.name.contains('碎片')).toList();
      default:
        return _items;
    }
  }

  void _showItemDetail(_PackageItem item) {
    final color = _rarityColors[item.rarity]!;
    final isShard = item.name.contains('碎片');

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
                  Text(
                    item.name,
                    style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(item.rarity, style: TextStyle(color: color, fontSize: 12)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'x${item.count}',
                style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.desc,
              style: const TextStyle(color: Color(0x998B7E6A), fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 16),
            if (isShard)
              _ShardProgress(current: item.count, total: 60)
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _DetailAction(
                    icon: '📤',
                    label: '出售',
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() {
                        if (item.count > 1) {
                          item.count--;
                        } else {
                          _items.remove(item);
                        }
                      });
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(content: Text('已出售 1 个${item.name}'), duration: const Duration(seconds: 1)),
                        );
                    },
                  ),
                  _DetailAction(
                    icon: '🎁',
                    label: '使用',
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() {
                        if (item.count > 1) {
                          item.count--;
                        } else {
                          _items.remove(item);
                        }
                      });
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            content: Text('已使用 ${item.name}'),
                            backgroundColor: const Color(0xFF4CAF50),
                            duration: const Duration(seconds: 1),
                          ),
                        );
                    },
                  ),
                ],
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('关闭', style: TextStyle(color: Color(0xFFD4A84B))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredItems;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('背包'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleSpacing: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Text(
              '${_items.fold<int>(0, (s, i) => s + i.count)} 件',
              style: const TextStyle(color: Color(0x998B7E6A), fontSize: 13),
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/city/jiuguan.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const Spacer(),
            // 分类 Tab
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _TabChip(label: '全部', isActive: _selectedTab == 0, onTap: () => setState(() => _selectedTab = 0)),
                  const SizedBox(width: 8),
                  _TabChip(label: '材料', isActive: _selectedTab == 1, onTap: () => setState(() => _selectedTab = 1)),
                  const SizedBox(width: 8),
                  _TabChip(label: '道具', isActive: _selectedTab == 2, onTap: () => setState(() => _selectedTab = 2)),
                  const SizedBox(width: 8),
                  _TabChip(label: '碎片', isActive: _selectedTab == 3, onTap: () => setState(() => _selectedTab = 3)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // 物品列表
            Expanded(
              child: filtered.isEmpty
                  ? const Center(child: Text('暂无物品', style: TextStyle(color: Color(0x668B7E6A), fontSize: 14)))
                  : Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Color(0xCC1A1111), Color(0xF21A1111)],
                        ),
                        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        border: const Border(top: BorderSide(color: Color(0x40D4A84B), width: 1)),
                      ),
                      child: GridView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 14, 12, 20),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.72,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final item = filtered[index];
                          final color = _rarityColors[item.rarity]!;
                          return GestureDetector(
                            onTap: () => _showItemDetail(item),
                            child: Container(
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: color.withOpacity(0.2)),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(item.icon, style: const TextStyle(fontSize: 28)),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.name,
                                    style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 11),
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                    decoration: BoxDecoration(
                                      color: color.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      'x${item.count}',
                                      style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 分类标签
class _TabChip extends StatelessWidget {
  const _TabChip({required this.label, required this.isActive, required this.onTap});
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? const Color(0x30D4A84B) : const Color(0x10FFFFFF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isActive ? const Color(0x60D4A84B) : const Color(0x20FFFFFF)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFFE8D5A3) : const Color(0x668B7E6A),
            fontSize: 13,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

/// 碎片合成进度条
class _ShardProgress extends StatelessWidget {
  const _ShardProgress({required this.current, required this.total});
  final int current;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ratio = (current / total).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('合成进度', style: TextStyle(color: Color(0x998B7E6A), fontSize: 12)),
            Text(
              '$current/$total',
              style: const TextStyle(color: Color(0xFFD4A84B), fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: const Color(0x20FFFFFF),
            valueColor: AlwaysStoppedAnimation<Color>(
              ratio >= 1 ? const Color(0xFF4CAF50) : const Color(0xFFD4A84B),
            ),
            minHeight: 8,
          ),
        ),
        const SizedBox(height: 8),
        if (current >= total)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4A84B),
                foregroundColor: const Color(0xFF1A1111),
              ),
              onPressed: () {},
              child: const Text('合成'),
            ),
          ),
      ],
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
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0x40D4A84B)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: Color(0xFFE8D5A3), fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
