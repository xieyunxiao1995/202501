import 'package:flutter/material.dart';
import '../state/game_state.dart';
import '../widgets/game_background.dart';

class ItemModel {
  final String name;
  final String icon;
  final int count;
  final Color color;
  final String description;
  final String category;

  ItemModel({
    required this.name,
    required this.icon,
    required this.count,
    required this.color,
    required this.description,
    this.category = '消耗品',
  });
}

// 物品的元数据词典（UI配置）
const Map<String, Map<String, dynamic>> ITEM_META = {
  '普通召喚券': {
    'icon': '🎫',
    'color': Colors.blue,
    'category': '材料',
    'desc': '旅館で普通の英雄を召喚するために使用します。',
  },
  '高級召喚券': {
    'icon': '🎟️',
    'color': Colors.orangeAccent,
    'category': '材料',
    'desc': '用于在旅馆召唤稀有英雄，必出SR以上。',
  },
  '強化石': {
    'icon': '💎',
    'color': Colors.purpleAccent,
    'category': '材料',
    'desc': '魔法を秘めた石。装備強化に使用する万能鉱石。',
  },
  '突破結晶': {
    'icon': '💠',
    'color': Colors.redAccent,
    'category': '材料',
    'desc': '英雄のレベル上限を突破するための核心レア素材。',
  },
  '神秘福袋': {
    'icon': '🎁',
    'color': Colors.amber,
    'category': '消耗品',
    'desc': '中身は何が入っているか分かりません。運試ししてみてください！',
  },
  '小型経験瓶': {
    'icon': '🧪',
    'color': Colors.lightBlue,
    'category': '消耗品',
    'desc': '微かなエネルギーを秘めた薬瓶。使用すると英雄の経験値が増加します。',
  },
  '初心者の短剣': {
    'icon': '🗡️',
    'color': Colors.grey,
    'category': '装備',
    'desc': '平凡な短剣。ないよりはまし。',
  },
  '紅い傘の欠片': {
    'icon': '☂️',
    'color': Colors.red,
    'category': '材料',
    'desc': 'フレアの愛する傘の欠片。集めると力が目覚めます。',
  },
};

class InventoryView extends StatefulWidget {
  final GameState gameState;
  const InventoryView({super.key, required this.gameState});

  @override
  State<InventoryView> createState() => _InventoryViewState();
}

class _InventoryViewState extends State<InventoryView> {
  String _selectedCategory = 'すべて';

  // 动态从 gameState 抓取真实数据并映射UI信息
  List<ItemModel> _buildInventoryItems() {
    final List<ItemModel> items = [];
    widget.gameState.materials.forEach((name, count) {
      if (count <= 0) return;
      final meta =
          ITEM_META[name] ??
          {
            'icon': '📦',
            'color': Colors.white,
            'category': 'その他',
            'desc': '神秘の未知の物品。',
          };
      items.add(
        ItemModel(
          name: name,
          icon: meta['icon'],
          count: count,
          color: meta['color'],
          description: meta['desc'],
          category: meta['category'],
        ),
      );
    });
    return items;
  }

  @override
  Widget build(BuildContext context) {
    final allItems = _buildInventoryItems();
    final filteredItems = _selectedCategory == 'すべて'
        ? allItems
        : allItems.where((i) => i.category == _selectedCategory).toList();

    return GameBackground(
      backgroundImage: BackgroundUtil.getBgByScene('inventory'),
      overlayOpacity: BackgroundUtil.getOverlayOpacityForScene('inventory'),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'バックパック',
            style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2),
          ),
          backgroundColor: Colors.transparent,
        ),
        body: Column(
        children: [
          _buildFilterBar(),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: (filteredItems.length < 24)
                  ? 24
                  : filteredItems.length,
              itemBuilder: (context, index) {
                if (index < filteredItems.length)
                  return _buildItemTile(filteredItems[index]);
                return _buildEmptySlot();
              },
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildFilterBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: ['すべて', '消耗品', '装備', '材料', 'その他'].map((cat) {
          final isSelected = _selectedCategory == cat;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (_) => setState(() => _selectedCategory = cat),
              selectedColor: Colors.amber,
              backgroundColor: const Color(0xff1c1c24),
              labelStyle: TextStyle(
                color: isSelected ? Colors.black : Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildItemTile(ItemModel item) {
    return GestureDetector(
      onTap: () => _showDetail(item),
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xff1c1c24),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: item.color.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: item.color.withValues(alpha: 0.1),
              blurRadius: 8,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Text(item.icon, style: const TextStyle(fontSize: 32)),
            ),
            Positioned(
              bottom: 4,
              right: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'x${item.count}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySlot() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff16161c),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  void _showDetail(ItemModel item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xff1c1c24),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: item.color.withValues(alpha: 0.1),
                border: Border.all(
                  color: item.color.withValues(alpha: 0.5),
                  width: 2,
                ),
              ),
              child: Text(item.icon, style: const TextStyle(fontSize: 64)),
            ),
            const SizedBox(height: 16),
            Text(
              item.name,
              style: TextStyle(
                color: item.color,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                item.category,
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: item.color,
                foregroundColor: Colors.white, // 根据背景自动调整可能会黑，设为白比较好，或者统一Amber
                minimumSize: const Size(double.infinity, 54),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                '確認',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
