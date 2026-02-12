import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/game_service.dart';
import '../../utils/constants.dart';
import '../../models/part.dart';
import '../../models/player.dart';
import '../../models/item.dart';
import '../widgets/character_schema_widget.dart';
import '../widgets/painters.dart'; // Keep for now if needed, or remove if not

class InventoryScreen extends StatefulWidget {
  final GameService gameService;

  const InventoryScreen({super.key, required this.gameService});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  PartType? _selectedFilter;
  String _sortOption = 'default'; // default, power_desc, power_asc
  int _currentTabIndex = 0; // 0: Equipment, 1: Items

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.gameService,
      builder: (context, child) {
        final player = widget.gameService.player;
        if (player == null) return const SizedBox();

        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallScreen = screenWidth < 380;
        final isTablet = screenWidth > 600;
        final schemaScale = isSmallScreen ? 0.6 : (isTablet ? 1.2 : 1.0);

        var filteredInventory = _selectedFilter == null
            ? List<Part>.from(player.inventory)
            : player.inventory.where((p) => p.type == _selectedFilter).toList();

        // Sorting
        if (_sortOption == 'power_desc') {
          filteredInventory.sort((a, b) => b.power.compareTo(a.power));
        } else if (_sortOption == 'power_asc') {
          filteredInventory.sort((a, b) => a.power.compareTo(b.power));
        }

        return Scaffold(
          backgroundColor: AppColors.bgPaper,
          body: Stack(
            children: [
              // Background
              Positioned.fill(
                child: Opacity(
                  opacity: 0.1,
                  child: Image.network(
                    'https://www.transparenttextures.com/patterns/wood-pattern.png',
                    repeat: ImageRepeat.repeat,
                    errorBuilder: (c, e, s) => Container(color: AppColors.woodLight),
                  ),
                ),
              ),
              
              Column(
                children: [
                  // Custom App Bar
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Navigator.of(context).pop(),
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: AppColors.inkBlack),
                              ),
                              child: const Icon(Icons.arrow_back, color: AppColors.inkBlack),
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Text(
                                '行囊',
                                style: GoogleFonts.maShanZheng(
                                  color: AppColors.inkBlack,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 48), // Balance the back button
                        ],
                      ),
                    ),
                  ),

                  // Character & Stats Section
                  Expanded(
                    flex: 9, // Increased flex for visualization
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        children: [
                          // Left: Character Visualization
                          Expanded(
                            flex: 5,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.woodDark.withOpacity(0.3)),
                              ),
                              child: CharacterSchemaWidget(
                                player: player,
                                scale: schemaScale,
                                onSlotTap: (type, part) {
                                  if (part != null) {
                                    _showItemDetails(context, part, isEquipped: true);
                                  }
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Right: Stats Panel
                          Expanded(
                            flex: 3,
                            child: _buildStatsPanel(player, isSmallScreen),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Inventory Section
                  Expanded(
                    flex: 10,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.bgPaper,
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Custom Tabs
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                            child: Row(
                              children: [
                                _buildTabButton(0, '装备', isSmallScreen, isTablet),
                                const SizedBox(width: 16),
                                _buildTabButton(1, '物品', isSmallScreen, isTablet),
                              ],
                            ),
                          ),
                          const Divider(),

                          // Content
                          Expanded(
                            child: _currentTabIndex == 0
                                ? _buildEquipmentView(player, filteredInventory, isSmallScreen, isTablet)
                                : _buildItemsView(player, isSmallScreen, isTablet),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabButton(int index, String label, bool isSmallScreen, bool isTablet) {
    final isSelected = _currentTabIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentTabIndex = index),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 12 : (isTablet ? 24 : 16), 
          vertical: isSmallScreen ? 6 : (isTablet ? 12 : 8)
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.woodDark : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.woodDark),
        ),
        child: Text(
          label,
          style: GoogleFonts.notoSerifSc(
            color: isSelected ? AppColors.bgPaper : AppColors.woodDark,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: isSmallScreen ? 12 : (isTablet ? 18 : 14),
          ),
        ),
      ),
    );
  }

  Widget _buildEquipmentView(Player player, List<Part> filteredInventory, bool isSmallScreen, bool isTablet) {
    // Dynamic grid columns
    final screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = (screenWidth / 180).floor().clamp(2, 6);
    
    return Column(
      children: [
        // Header & Filter
        Padding(
          padding: EdgeInsets.fromLTRB(16, isSmallScreen ? 4 : 8, 16, isSmallScreen ? 4 : 8),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 4,
                    height: isSmallScreen ? 16 : (isTablet ? 24 : 20),
                    color: AppColors.inkRed,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '装备列表',
                    style: GoogleFonts.notoSerifSc(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 16 : (isTablet ? 22 : 18),
                      color: AppColors.inkBlack,
                    ),
                  ),
                  const Spacer(),
                  PopupMenuButton<String>(
                    icon: Icon(Icons.sort, color: AppColors.inkBlack.withOpacity(0.7), size: isSmallScreen ? 20 : (isTablet ? 28 : 24)),
                    onSelected: (value) {
                      setState(() {
                        _sortOption = value;
                      });
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'default',
                        child: Text('默认排序', style: GoogleFonts.notoSerifSc()),
                      ),
                      PopupMenuItem(
                        value: 'power_desc',
                        child: Text('战力: 高 -> 低', style: GoogleFonts.notoSerifSc()),
                      ),
                      PopupMenuItem(
                        value: 'power_asc',
                        child: Text('战力: 低 -> 高', style: GoogleFonts.notoSerifSc()),
                      ),
                    ],
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${player.inventory.length}/20',
                    style: GoogleFonts.notoSerifSc(
                      fontSize: isSmallScreen ? 10 : (isTablet ? 14 : 12),
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip(null, '全部', isSmallScreen, isTablet),
                    ...PartType.values.map((type) => _buildFilterChip(type, _getPartTypeLabel(type), isSmallScreen, isTablet)),
                  ],
                ),
              ),
            ],
          ),
        ),
        
        // Grid
        Expanded(
          child: filteredInventory.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.backpack_outlined, size: isSmallScreen ? 36 : 48, color: Colors.grey.withOpacity(0.5)),
                      const SizedBox(height: 8),
                      Text(
                        '暂无此类物品',
                        style: GoogleFonts.maShanZheng(
                          color: Colors.grey,
                          fontSize: isSmallScreen ? 16 : 20,
                        ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: isSmallScreen ? 0.75 : 0.85,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: filteredInventory.length,
                  itemBuilder: (context, index) {
                    final part = filteredInventory[index];
                    return _buildInventoryItem(context, part, isSmallScreen, isTablet);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildItemsView(Player player, bool isSmallScreen, bool isTablet) {
    // Dynamic grid columns
    final screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = (screenWidth / 180).floor().clamp(2, 6);

    if (player.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.category_outlined, size: isSmallScreen ? 36 : 48, color: Colors.grey.withOpacity(0.5)),
            const SizedBox(height: 8),
            Text(
              '行囊空空如也',
              style: GoogleFonts.maShanZheng(
                color: Colors.grey,
                fontSize: isSmallScreen ? 16 : 20,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: isSmallScreen ? 0.75 : 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: player.items.length,
      itemBuilder: (context, index) {
        final item = player.items[index];
        return _buildItemCard(context, item, isSmallScreen, isTablet);
      },
    );
  }

  Widget _buildItemCard(BuildContext context, Item item, bool isSmallScreen, bool isTablet) {
    return GestureDetector(
      onTap: () => _showConsumableDetails(context, item),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgPaper,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.woodDark.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.woodLight.withOpacity(0.1),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    ),
                    child: Center(
                      child: Icon(
                        _getItemIcon(item.effectType),
                        size: isSmallScreen ? 36 : 48,
                        color: AppColors.woodDark,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                      item.name,
                      style: GoogleFonts.maShanZheng(
                        fontSize: isSmallScreen ? 14 : (isTablet ? 18 : 16),
                        fontWeight: FontWeight.bold,
                        color: AppColors.inkBlack,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      item.description,
                      style: GoogleFonts.notoSerifSc(
                        fontSize: isSmallScreen ? 9 : (isTablet ? 12 : 10),
                        color: Colors.grey[600],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.inkBlack.withOpacity(0.8),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'x${item.count}',
              style: GoogleFonts.notoSerifSc(
                color: AppColors.bgPaper,
                fontSize: isSmallScreen ? 9 : (isTablet ? 12 : 10),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  ),
);
}

IconData _getItemIcon(ItemEffectType type) {
    switch (type) {
      case ItemEffectType.healSanity:
        return Icons.spa;
      case ItemEffectType.restoreInk:
        return Icons.local_cafe;
      case ItemEffectType.buffAttack:
        return Icons.flash_on;
      default:
        return Icons.inventory_2;
    }
  }

  void _showConsumableDetails(BuildContext context, Item item) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 380;
    final isTablet = screenWidth > 600;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.bgPaper,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.all(isSmallScreen ? 16 : (isTablet ? 32 : 24)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.name,
              style: GoogleFonts.maShanZheng(
                fontSize: isSmallScreen ? 20 : (isTablet ? 32 : 24),
                fontWeight: FontWeight.bold,
                color: AppColors.inkBlack,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              item.description,
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSerifSc(
                fontSize: isSmallScreen ? 14 : (isTablet ? 20 : 16),
                color: AppColors.inkBlack.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '持有数量: ${item.count}',
                  style: GoogleFonts.notoSerifSc(
                    fontSize: isSmallScreen ? 12 : (isTablet ? 16 : 14),
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final success = widget.gameService.useItem(item);
                  Navigator.pop(context);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '使用了 ${item.name}',
                          style: TextStyle(fontSize: isTablet ? 18 : 14),
                        ),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('无法使用，状态已满'),
                        backgroundColor: Colors.orange,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.inkBlack,
                  padding: EdgeInsets.symmetric(vertical: isSmallScreen ? 12 : 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  '使用',
                  style: GoogleFonts.notoSerifSc(
                    color: AppColors.bgPaper,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(PartType? type, String label, bool isSmallScreen, bool isTablet) {
    final isSelected = _selectedFilter == type;
    return Padding(
      padding: EdgeInsets.only(right: isSmallScreen ? 4.0 : (isTablet ? 12.0 : 8.0)),
      child: FilterChip(
        label: Text(
          label,
          style: GoogleFonts.notoSerifSc(
            color: isSelected ? AppColors.bgPaper : AppColors.inkBlack,
            fontSize: isSmallScreen ? 10 : (isTablet ? 16 : 12),
          ),
        ),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            _selectedFilter = selected ? type : null;
          });
        },
        backgroundColor: Colors.transparent,
        selectedColor: AppColors.inkBlack,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(
            color: isSelected ? Colors.transparent : AppColors.inkBlack.withOpacity(0.5),
          ),
        ),
        showCheckmark: false,
        padding: EdgeInsets.symmetric(horizontal: isSmallScreen ? 2 : 4, vertical: isTablet ? 4 : 0),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildStatsPanel(Player player, bool isSmallScreen) {
    int attack = 10;
    int defense = 0;
    int hp = 100;
    int vision = 10;
    int speed = 10;

    player.parts.values.whereType<Part>().forEach((part) {
      if (part.stats.containsKey('attack')) attack += part.stats['attack'] as int;
      if (part.stats.containsKey('defense')) defense += part.stats['defense'] as int;
      if (part.stats.containsKey('hp')) hp += part.stats['hp'] as int;
      if (part.stats.containsKey('vision')) vision += part.stats['vision'] as int;
      if (part.stats.containsKey('speed')) speed += part.stats['speed'] as int;
    });

    final totalScore = attack * 2 + defense * 2 + (hp / 5).round() + vision + speed * 3;
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        color: AppColors.inkBlack.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.woodDark.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // Total Score
          Column(
            children: [
              Text(
                '综合战力',
                style: GoogleFonts.notoSerifSc(fontSize: isSmallScreen ? 10 : (isTablet ? 14 : 12), color: Colors.grey),
              ),
              Text(
                '$totalScore',
                style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 24 : (isTablet ? 42 : 32), fontWeight: FontWeight.bold, color: AppColors.inkRed),
              ),
            ],
          ),
          const Divider(thickness: 1),
          // Individual Stats
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildStatRow('生命', hp, Icons.favorite, isSmallScreen, isTablet),
                  _buildStatRow('心神', player.maxSanity, Icons.psychology, isSmallScreen, isTablet),
                  _buildStatRow('灵墨', player.maxInk, Icons.water_drop, isSmallScreen, isTablet),
                  const Divider(height: 12, thickness: 0.5),
                  _buildStatRow('攻击', attack, Icons.flash_on, isSmallScreen, isTablet),
                  _buildStatRow('防御', defense, Icons.shield, isSmallScreen, isTablet),
                  _buildStatRow('速度', speed, Icons.speed, isSmallScreen, isTablet),
                  _buildStatRow('视野', vision, Icons.visibility, isSmallScreen, isTablet),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, int value, IconData icon, bool isSmallScreen, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: isSmallScreen ? 12 : (isTablet ? 18 : 14), color: AppColors.inkBlack.withOpacity(0.7)),
          SizedBox(width: isTablet ? 12 : 8),
          Text(label, style: GoogleFonts.notoSerifSc(fontSize: isSmallScreen ? 10 : (isTablet ? 14 : 12), color: Colors.grey)),
          const Spacer(),
          Text(
            '$value',
            style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 14 : (isTablet ? 20 : 16), fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }


  Widget _buildInventoryItem(BuildContext context, Part part, bool isSmallScreen, bool isTablet) {
    return GestureDetector(
      onTap: () => _showItemDetails(context, part, isEquipped: false),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgPaper,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.woodDark.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.woodLight.withOpacity(0.1),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                ),
                child: Center(
                  child: CustomPaint(
                    size: Size(isSmallScreen ? 60 : (isTablet ? 100 : 80), isSmallScreen ? 60 : (isTablet ? 100 : 80)),
                    painter: BodySchemaPainter(),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 6 : 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      part.name,
                      style: GoogleFonts.maShanZheng(
                        fontSize: isSmallScreen ? 14 : (isTablet ? 18 : 16),
                        fontWeight: FontWeight.bold,
                        color: AppColors.inkBlack,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _getPartTypeLabel(part.type),
                      style: GoogleFonts.notoSerifSc(
                        fontSize: isSmallScreen ? 10 : (isTablet ? 14 : 12),
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showItemDetails(BuildContext context, Part part, {required bool isEquipped}) {
    final isSmallScreen = MediaQuery.of(context).size.width < 380;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: AppColors.bgPaper,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
                  decoration: BoxDecoration(
                    color: AppColors.woodLight.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.woodDark),
                  ),
                  child: Text(
                    _getPartTypeChar(part.type),
                    style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 20 : 24, color: AppColors.inkBlack),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        part.name,
                        style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 20 : 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '来源: ${part.origin}',
                        style: GoogleFonts.notoSerifSc(fontSize: isSmallScreen ? 10 : 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.5),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.withOpacity(0.2)),
              ),
              child: Text(
                part.description,
                style: GoogleFonts.notoSerifSc(fontSize: isSmallScreen ? 12 : 14, height: 1.5),
              ),
            ),
            const SizedBox(height: 16),
            Text('属性加成', style: GoogleFonts.notoSerifSc(fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 12 : 14)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: part.stats.entries.map((e) {
                return Chip(
                  backgroundColor: AppColors.woodLight.withOpacity(0.2),
                  label: Text(
                    '${_translateStatKey(e.key)} +${e.value}',
                    style: GoogleFonts.notoSerifSc(fontSize: isSmallScreen ? 10 : 12, color: AppColors.inkBlack),
                  ),
                  padding: EdgeInsets.zero,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: isSmallScreen ? 44 : 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  if (isEquipped) {
                    widget.gameService.unequipPart(part.type);
                  } else {
                    widget.gameService.equipPart(part);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isEquipped ? Colors.grey : AppColors.inkBlack,
                  foregroundColor: AppColors.bgPaper,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  isEquipped ? '卸下装备' : '装备此物',
                  style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 16 : 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPartTypeChar(PartType type) {
    switch (type) {
      case PartType.head: return '首';
      case PartType.body: return '躯';
      case PartType.leg: return '足';
      case PartType.tail: return '尾';
      case PartType.soul: return '魂';
    }
  }

  String _getPartTypeLabel(PartType type) {
    switch (type) {
      case PartType.head: return '头部';
      case PartType.body: return '躯干';
      case PartType.leg: return '足部';
      case PartType.tail: return '尾部';
      case PartType.soul: return '神魂';
    }
  }

  String _translateStatKey(String key) {
    switch (key) {
      case 'attack': return '攻';
      case 'defense': return '防';
      case 'hp': return '命';
      case 'vision': return '视';
      case 'speed': return '速';
      default: return key;
    }
  }

  String _getStatsString(Map<String, dynamic> stats) {
    final buffer = StringBuffer();
    stats.forEach((key, value) {
      buffer.write('${_translateStatKey(key)} +$value  ');
    });
    return buffer.toString().trim();
  }
}

