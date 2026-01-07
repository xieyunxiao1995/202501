import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../models/beast_model.dart';
import '../core/app_colors.dart';

class InventoryPage extends StatefulWidget {
  final Inventory inventory;
  final List<Beast> beasts;
  final Function(Inventory) onUpdateInventory;

  const InventoryPage({
    super.key,
    required this.inventory,
    required this.beasts,
    required this.onUpdateInventory,
  });

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  String _selectedFilter = 'all';

  @override
  Widget build(BuildContext context) {
    final items = _getFilteredItems();
    final bool isSmallScreen = MediaQuery.of(context).size.height < 600;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(isSmallScreen),
          SliverToBoxAdapter(child: _buildFilterChips(isSmallScreen)),
          items.isEmpty
              ? SliverFillRemaining(child: _buildEmptyState(isSmallScreen))
              : SliverPadding(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    isSmallScreen ? 8 : 16,
                    16,
                    100,
                  ),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: isSmallScreen ? 4 : 3,
                      crossAxisSpacing: isSmallScreen ? 8 : 12,
                      mainAxisSpacing: isSmallScreen ? 8 : 12,
                      childAspectRatio: 0.8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _buildItemCard(items[index], isSmallScreen),
                      childCount: items.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(bool isSmallScreen) {
    return SliverAppBar(
      expandedHeight: isSmallScreen ? 120 : 160,
      pinned: true,
      backgroundColor: AppColors.bg,
      elevation: 0,
      centerTitle: true,
      title: Text(
        '山海背包',
        style: TextStyle(
          color: Colors.white,
          fontSize: isSmallScreen ? 16 : 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1A1A1A), Color(0xFF0D0D0D)],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  Icons.backpack_outlined,
                  size: isSmallScreen ? 100 : 150,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  24,
                  0,
                  24,
                  isSmallScreen ? 12 : 20,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${widget.inventory.itemCount}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 24 : 32,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '件宝物',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: isSmallScreen ? 12 : 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips(bool isSmallScreen) {
    return Container(
      color: AppColors.bg,
      padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 4 : 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            _buildFilterChip('全部', 'all', isSmallScreen),
            _buildFilterChip('消耗品', 'consumable', isSmallScreen),
            _buildFilterChip('材料', 'material', isSmallScreen),
            _buildFilterChip('特殊', 'special', isSmallScreen),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String filter, bool isSmallScreen) {
    final isSelected = _selectedFilter == filter;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = filter;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : 16,
          vertical: isSmallScreen ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.1)
              : Colors.white.withValues(alpha: 0.03),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.primary : AppColors.textSub,
            fontSize: isSmallScreen ? 12 : 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  List<ItemStack> _getFilteredItems() {
    final allItems = widget.inventory.getAllItems();

    if (_selectedFilter == 'all') {
      return allItems;
    }

    final itemType = _selectedFilter == 'consumable'
        ? ItemType.consumable
        : _selectedFilter == 'material'
        ? ItemType.material
        : ItemType.special;

    return allItems.where((stack) => stack.item.type == itemType).toList();
  }

  Widget _buildEmptyState(bool isSmallScreen) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: isSmallScreen ? 60 : 80,
            color: AppColors.textSub,
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Text(
            '背包空空如也',
            style: TextStyle(
              color: AppColors.textSub,
              fontSize: isSmallScreen ? 16 : 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemCard(ItemStack stack, bool isSmallScreen) {
    final item = stack.item;
    final rarityColor = _getRarityColor(item.rarity);

    return GestureDetector(
      onTap: () => _showItemDetail(stack, isSmallScreen),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: rarityColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Stack(
            children: [
              // 背景渐变
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        rarityColor.withValues(alpha: 0.05),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: isSmallScreen ? 36 : 50,
                    height: isSmallScreen ? 36 : 50,
                    decoration: BoxDecoration(
                      color: rarityColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        item.icon,
                        style: TextStyle(fontSize: isSmallScreen ? 20 : 28),
                      ),
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 4 : 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      item.name,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: isSmallScreen ? 10 : 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              // 数量显示
              Positioned(
                bottom: isSmallScreen ? 2 : 4,
                right: isSmallScreen ? 2 : 4,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 4 : 6,
                    vertical: isSmallScreen ? 1 : 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'x${stack.quantity}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 8 : 10,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
              ),
              // 稀有度指示
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  width: isSmallScreen ? 3 : 4,
                  height: isSmallScreen ? 8 : 12,
                  decoration: BoxDecoration(
                    color: rarityColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getRarityColor(int rarity) {
    switch (rarity) {
      case 5:
        return Colors.purple;
      case 4:
        return Colors.orange;
      case 3:
        return Colors.blue;
      case 2:
        return Colors.green;
      case 1:
      default:
        return Colors.grey;
    }
  }

  void _showItemDetail(ItemStack stack, bool isSmallScreen) {
    final item = stack.item;
    final rarityColor = _getRarityColor(item.rarity);

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1A1A1A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.fromLTRB(24, 12, 24, isSmallScreen ? 20 : 40),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: EdgeInsets.only(bottom: isSmallScreen ? 16 : 24),
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    width: isSmallScreen ? 60 : 80,
                    height: isSmallScreen ? 60 : 80,
                    decoration: BoxDecoration(
                      color: rarityColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 12 : 16,
                      ),
                      border: Border.all(
                        color: rarityColor.withValues(alpha: 0.2),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        item.icon,
                        style: TextStyle(fontSize: isSmallScreen ? 30 : 40),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 18 : 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 4 : 8),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: rarityColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                _getRarityName(item.rarity),
                                style: TextStyle(
                                  color: rarityColor,
                                  fontSize: isSmallScreen ? 10 : 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '拥有: ${stack.quantity}',
                              style: TextStyle(
                                color: AppColors.textSub,
                                fontSize: isSmallScreen ? 12 : 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: isSmallScreen ? 16 : 24),
              Text(
                '物品描述',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: isSmallScreen ? 12 : 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isSmallScreen ? 8 : 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.03),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                child: Text(
                  item.description,
                  style: TextStyle(
                    color: AppColors.textSub,
                    fontSize: isSmallScreen ? 13 : 15,
                    height: 1.5,
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 20 : 32),
              _buildActionButtons(stack, isSmallScreen),
            ],
          ),
        ),
      ),
    );
  }

  String _getRarityName(int rarity) {
    switch (rarity) {
      case 5:
        return '至尊';
      case 4:
        return '传说';
      case 3:
        return '史诗';
      case 2:
        return '稀有';
      case 1:
      default:
        return '普通';
    }
  }

  Widget _buildActionButtons(ItemStack stack, bool isSmallScreen) {
    final item = stack.item;

    if (item.type == ItemType.consumable) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: stack.quantity > 0
              ? () {
                  Navigator.pop(context);
                  _useConsumable(stack, isSmallScreen);
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            '使用',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    } else if (item.type == ItemType.special && item.id.contains('beast_egg')) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: stack.quantity > 0
              ? () {
                  Navigator.pop(context);
                  _hatchEgg(stack, isSmallScreen);
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            '孵化',
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }

  void _useConsumable(ItemStack stack, bool isSmallScreen) {
    if (widget.beasts.isEmpty) {
      _showSnackBar('没有可用的异兽', Colors.red);
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          '选择异兽',
          style: TextStyle(
            color: AppColors.textMain,
            fontSize: isSmallScreen ? 16 : 18,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.4,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.beasts.length,
              itemBuilder: (context, index) {
                final beast = widget.beasts[index];
                return ListTile(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 8 : 16,
                  ),
                  title: Text(
                    beast.name,
                    style: TextStyle(
                      color: AppColors.textMain,
                      fontSize: isSmallScreen ? 14 : 16,
                    ),
                  ),
                  subtitle: Text(
                    '生命: ${beast.stats.hp} | 攻击: ${beast.stats.atk}',
                    style: TextStyle(
                      color: AppColors.textSub,
                      fontSize: isSmallScreen ? 11 : 13,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _applyItemEffect(stack, beast);
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _applyItemEffect(ItemStack stack, Beast beast) {
    final item = stack.item;
    final updatedInventory = widget.inventory.copyWith();
    updatedInventory.removeItem(item.id);

    String message = '';
    Color color = Colors.green;

    // 应用实际效果到 beast 对象
    if (item.effect == ItemEffect.healHp) {
      beast.stats.hp += item.value;
      message = '${beast.name} 恢复了 ${item.value} 点生命值';
    } else if (item.effect == ItemEffect.boostAttack) {
      beast.stats.atk += item.value;
      message = '${beast.name} 永久提升了 ${item.value} 点攻击力';
    } else if (item.effect == ItemEffect.boostDefense) {
      beast.stats.def += item.value;
      message = '${beast.name} 永久提升了 ${item.value} 点防御力';
    } else if (item.effect == ItemEffect.boostSpeed) {
      beast.stats.spd += item.value;
      message = '${beast.name} 永久提升了 ${item.value} 点速度';
    } else {
      message = '使用了 ${item.name}';
    }

    widget.onUpdateInventory(updatedInventory);
    setState(() {}); // 刷新当前页面（更新数量显示）
    _showSnackBar(message, color);
  }

  void _hatchEgg(ItemStack stack, bool isSmallScreen) {
    final item = stack.item;
    final updatedInventory = widget.inventory.copyWith();
    updatedInventory.removeItem(item.id);

    widget.onUpdateInventory(updatedInventory);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.egg,
              size: isSmallScreen ? 60 : 80,
              color: AppColors.primary,
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Text(
              '孵化中...',
              style: TextStyle(
                color: AppColors.textMain,
                fontSize: isSmallScreen ? 16 : 18,
              ),
            ),
          ],
        ),
      ),
    );

    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pop(context);
      _showHatchResult(item, isSmallScreen);
    });
  }

  void _showHatchResult(Item item, bool isSmallScreen) {
    final tier = item.id.contains('epic')
        ? '万年'
        : item.id.contains('rare')
        ? '千年'
        : '百年';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.emoji_events,
              size: isSmallScreen ? 60 : 80,
              color: _getRarityColor(item.rarity),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Text(
              '孵化成功！',
              style: TextStyle(
                color: _getRarityColor(item.rarity),
                fontSize: isSmallScreen ? 20 : 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            Text(
              '获得了$tier异兽',
              style: TextStyle(
                color: AppColors.textMain,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '确定',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
