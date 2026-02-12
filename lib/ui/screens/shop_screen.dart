import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/game_service.dart';
import '../../utils/constants.dart';
import '../../models/part.dart';
import '../../models/player.dart';
import '../../models/item.dart';

class ShopScreen extends StatefulWidget {
  final GameService gameService;

  const ShopScreen({super.key, required this.gameService});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  final List<Part?> _shopItems = [];
  final Map<String, int> _itemPrices = {};
  static const int _refreshCost = 10;

  @override
  void initState() {
    super.initState();
    _refreshShopItems(initial: true);
  }

  void _refreshShopItems({bool initial = false}) {
    if (!initial) {
      if (widget.gameService.player!.ink < _refreshCost) {
        _showToast('灵墨不足，无法刷新');
        return;
      }
      widget.gameService.consumeInk(_refreshCost);
    }

    setState(() {
      _shopItems.clear();
      _itemPrices.clear();
      // Generate 4 random items
      for (int i = 0; i < 4; i++) {
        final part = widget.gameService.generateRandomPart();
        _shopItems.add(part);
        _itemPrices[part.id] = _calculatePrice(part);
      }
    });

    if (!initial) {
      _showToast('货物已刷新');
    }
  }

  int _calculatePrice(Part part) {
    int power = _calculatePartPower(part);
    // Base price + power multiplier
    return 50 + (power * 2);
  }

  int _calculatePartPower(Part part) {
    int score = 0;
    if (part.stats.containsKey('attack')) score += (part.stats['attack'] as int) * 2;
    if (part.stats.containsKey('defense')) score += (part.stats['defense'] as int) * 2;
    if (part.stats.containsKey('hp')) score += ((part.stats['hp'] as int) / 5).round();
    if (part.stats.containsKey('vision')) score += (part.stats['vision'] as int);
    if (part.stats.containsKey('speed')) score += (part.stats['speed'] as int) * 3;
    return score;
  }

  Color _getPowerColor(int power) {
    if (power < 20) return AppColors.woodDark;
    if (power < 40) return Colors.blueGrey;
    if (power < 60) return Colors.purple;
    return AppColors.inkRed;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isSmallScreen = screenWidth < 380;
    final bool isTablet = screenWidth > 600;
    
    return ListenableBuilder(
      listenable: widget.gameService,
      builder: (context, child) {
        final player = widget.gameService.player;
        if (player == null) return const SizedBox();

        return Scaffold(
          backgroundColor: AppColors.bgPaper,
          body: Stack(
            children: [
              // Background texture
              Positioned.fill(
                child: Opacity(
                  opacity: 0.05,
                  child: Image.network(
                    'https://www.transparenttextures.com/patterns/paper-fibers.png',
                    fit: BoxFit.cover,
                    errorBuilder: (c, e, s) => Container(color: AppColors.bgPaper),
                  ),
                ),
              ),

              CustomScrollView(
                slivers: [
                  _buildAppBar(player, isSmallScreen, isTablet),
                  SliverPadding(
                    padding: EdgeInsets.all(isSmallScreen ? 12 : (isTablet ? 24 : 16)),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildShopBanner(isSmallScreen, isTablet),
                        SizedBox(height: isSmallScreen ? 16 : (isTablet ? 32 : 24)),
                        
                        // Supplies Section
                        _buildSectionTitle('补给', Icons.medical_services_outlined, isSmallScreen, isTablet),
                        _buildSupplyItem(
                          context,
                          title: '灵茶',
                          desc: '清心凝神，恢复30点理智',
                          price: 20,
                          icon: Icons.local_cafe_outlined,
                          isSmallScreen: isSmallScreen,
                          isTablet: isTablet,
                          onBuy: () {
                            if (player.ink >= 20) {
                              widget.gameService.consumeInk(20);
                              widget.gameService.addItemToBag(Item(
                                id: 'item_tea',
                                name: '灵茶',
                                description: '清心凝神，恢复30点理智',
                                type: ItemType.consumable,
                                effectType: ItemEffectType.healSanity,
                                effectValue: 30,
                              ));
                              _showToast('已购入灵茶');
                            } else {
                              _showToast('囊中羞涩');
                            }
                          },
                          canBuy: player.ink >= 20,
                        ),
                        _buildSupplyItem(
                          context,
                          title: '凝神丹',
                          desc: '强效定心，恢复60点理智',
                          price: 35,
                          icon: Icons.spa,
                          isSmallScreen: isSmallScreen,
                          isTablet: isTablet,
                          onBuy: () {
                            if (player.ink >= 35) {
                              widget.gameService.consumeInk(35);
                              widget.gameService.addItemToBag(Item(
                                id: 'item_pill',
                                name: '凝神丹',
                                description: '强效定心，恢复60点理智',
                                type: ItemType.consumable,
                                effectType: ItemEffectType.healSanity,
                                effectValue: 60,
                              ));
                              _showToast('已购入凝神丹');
                            } else {
                              _showToast('囊中羞涩');
                            }
                          },
                          canBuy: player.ink >= 35,
                        ),

                        SizedBox(height: isSmallScreen ? 16 : (isTablet ? 32 : 24)),

                        // Treasures Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildSectionTitle('珍宝', Icons.diamond_outlined, isSmallScreen, isTablet),
                            TextButton.icon(
                              onPressed: () => _refreshShopItems(),
                              icon: Icon(Icons.refresh, size: isSmallScreen ? 14 : (isTablet ? 20 : 16), color: AppColors.inkBlack),
                              label: Text(
                                '刷新 ($_refreshCost墨)',
                                style: GoogleFonts.notoSerifSc(color: AppColors.inkBlack, fontSize: isSmallScreen ? 12 : (isTablet ? 18 : 14)),
                              ),
                            ),
                          ],
                        ),
                        
                        if (_shopItems.isEmpty)
                          Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Center(
                              child: Text(
                                '今日货物已售罄',
                                style: GoogleFonts.maShanZheng(fontSize: 20, color: Colors.grey),
                              ),
                            ),
                          )
                        else
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: isTablet ? 3 : 2,
                              childAspectRatio: isSmallScreen ? 0.65 : (isTablet ? 0.8 : 0.75),
                              crossAxisSpacing: isTablet ? 16 : 12,
                              mainAxisSpacing: isTablet ? 16 : 12,
                            ),
                            itemCount: _shopItems.length,
                            itemBuilder: (context, index) {
                              final part = _shopItems[index];
                              if (part == null) {
                                return _buildSoldOutItem();
                              }
                              return _buildTreasureItem(context, part, player, index, isSmallScreen, isTablet);
                            },
                          ),
                          
                        const SizedBox(height: 40),
                      ]),
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

  Widget _buildAppBar(Player player, bool isSmallScreen, bool isTablet) {
    return SliverAppBar(
      backgroundColor: AppColors.bgPaper.withOpacity(0.9),
      floating: true,
      pinned: true,
      elevation: 0,
      iconTheme: IconThemeData(color: AppColors.inkBlack, size: isTablet ? 32 : 24),
      centerTitle: true,
      title: Text(
        '墨韵斋',
        style: GoogleFonts.maShanZheng(color: AppColors.inkBlack, fontSize: isSmallScreen ? 24 : (isTablet ? 36 : 28), fontWeight: FontWeight.bold),
      ),
      actions: [
        Container(
          margin: EdgeInsets.symmetric(horizontal: isTablet ? 32 : 16, vertical: isTablet ? 12 : 8),
          padding: EdgeInsets.symmetric(horizontal: isTablet ? 20 : 12, vertical: isTablet ? 8 : 4),
          decoration: BoxDecoration(
            color: AppColors.inkBlack.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.inkBlack.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Icon(Icons.water_drop, size: isSmallScreen ? 14 : (isTablet ? 24 : 16), color: AppColors.inkBlack),
              const SizedBox(width: 4),
              Text(
                '${player.ink}',
                style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 16 : (isTablet ? 24 : 18), color: AppColors.inkBlack),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildShopBanner(bool isSmallScreen, bool isTablet) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : (isTablet ? 32 : 24)),
      decoration: BoxDecoration(
        color: AppColors.woodDark,
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage('https://www.transparenttextures.com/patterns/wood-pattern.png'),
          repeat: ImageRepeat.repeat,
          opacity: 0.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.storefront, color: AppColors.gold, size: isSmallScreen ? 24 : (isTablet ? 48 : 32)),
              SizedBox(width: isSmallScreen ? 8 : (isTablet ? 16 : 12)),
              Text(
                '货通三界',
                style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 26 : (isTablet ? 48 : 32), color: AppColors.gold, fontWeight: FontWeight.bold),
              ),
              SizedBox(width: isSmallScreen ? 8 : (isTablet ? 16 : 12)),
              Icon(Icons.storefront, color: AppColors.gold, size: isSmallScreen ? 24 : (isTablet ? 48 : 32)),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.gold.withOpacity(0.5))),
            ),
            child: Text(
              '童叟无欺 · 以墨易物 · 奇珍异宝',
              style: GoogleFonts.notoSerifSc(color: Colors.white70, fontSize: isSmallScreen ? 10 : (isTablet ? 16 : 12), letterSpacing: 2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, bool isSmallScreen, bool isTablet) {
    return Padding(
      padding: EdgeInsets.only(bottom: isTablet ? 16.0 : 12.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 12 : 8),
            decoration: BoxDecoration(
              color: AppColors.inkRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppColors.inkRed, size: isSmallScreen ? 18 : (isTablet ? 28 : 20)),
          ),
          SizedBox(width: isSmallScreen ? 8 : (isTablet ? 16 : 12)),
          Text(title, style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 18 : (isTablet ? 32 : 22), color: AppColors.inkBlack, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildSupplyItem(
    BuildContext context, {
    required String title,
    required String desc,
    required int price,
    required IconData icon,
    required VoidCallback onBuy,
    required bool canBuy,
    required bool isSmallScreen,
    required bool isTablet,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isTablet ? 20 : 12),
      padding: EdgeInsets.all(isSmallScreen ? 12 : (isTablet ? 24 : 16)),
      decoration: BoxDecoration(
        color: AppColors.bgPaper,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inkBlack.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: isSmallScreen ? 48 : (isTablet ? 72 : 56),
            height: isSmallScreen ? 48 : (isTablet ? 72 : 56),
            decoration: BoxDecoration(
              color: AppColors.woodLight.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.inkBlack.withOpacity(0.1)),
            ),
            child: Icon(icon, color: AppColors.inkBlack, size: isSmallScreen ? 24 : (isTablet ? 40 : 28)),
          ),
          SizedBox(width: isSmallScreen ? 12 : (isTablet ? 24 : 16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 18 : (isTablet ? 28 : 20), fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(desc, style: GoogleFonts.notoSerifSc(fontSize: isSmallScreen ? 10 : (isTablet ? 16 : 12), color: Colors.grey)),
              ],
            ),
          ),
          _PurchaseButton(
            price: price,
            canBuy: canBuy,
            onBuy: onBuy,
            onFail: () => _showToast('灵墨不足'),
            isSmallScreen: isSmallScreen,
            isTablet: isTablet,
          ),
        ],
      ),
    );
  }

  Widget _buildTreasureItem(BuildContext context, Part part, Player player, int index, bool isSmallScreen, bool isTablet) {
    final price = _itemPrices[part.id] ?? 999;
    final canBuy = player.ink >= price;
    final power = _calculatePartPower(part);
    final powerColor = _getPowerColor(power);

    final equippedPart = player.parts[part.type];
    final equippedPower = equippedPart != null ? _calculatePartPower(equippedPart) : 0;
    final isUpgrade = power > equippedPower;

    return GestureDetector(
      onTap: () => _showItemDetails(context, part, price, index),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.bgPaper,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: powerColor.withOpacity(0.5), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: powerColor.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icon Area
                Expanded(
                  flex: 4,
                  child: Container(
                    decoration: BoxDecoration(
                      color: powerColor.withOpacity(0.05),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: isSmallScreen ? 40 : (isTablet ? 72 : 48),
                          height: isSmallScreen ? 40 : (isTablet ? 72 : 48),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(color: powerColor.withOpacity(0.5)),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            _getPartTypeChar(part.type),
                            style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 20 : (isTablet ? 36 : 24), color: powerColor),
                          ),
                        ),
                        Positioned(
                          top: isTablet ? 12 : 8,
                          right: isTablet ? 12 : 8,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: isTablet ? 10 : 6, vertical: isTablet ? 4 : 2),
                            decoration: BoxDecoration(
                              color: powerColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '$power',
                              style: GoogleFonts.notoSerifSc(
                                fontSize: isSmallScreen ? 9 : (isTablet ? 14 : 10),
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Info Area
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 8.0 : (isTablet ? 16.0 : 10.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              part.name,
                              style: GoogleFonts.notoSerifSc(
                                fontWeight: FontWeight.bold,
                                fontSize: isSmallScreen ? 12 : (isTablet ? 18 : 14),
                                color: AppColors.inkBlack,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              part.origin,
                              style: GoogleFonts.notoSerifSc(
                                fontSize: isSmallScreen ? 9 : (isTablet ? 12 : 10),
                                color: Colors.grey,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.water_drop, size: isSmallScreen ? 10 : (isTablet ? 16 : 12), color: AppColors.inkBlack),
                                Text(
                                  '$price',
                                  style: GoogleFonts.notoSerifSc(
                                    fontSize: isSmallScreen ? 12 : (isTablet ? 18 : 14),
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.inkBlack
                                  ),
                                ),
                              ],
                            ),
                            if (canBuy)
                              Icon(Icons.add_shopping_cart, size: isSmallScreen ? 14 : (isTablet ? 24 : 16), color: AppColors.inkRed)
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Tap Ripple
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => _showItemDetails(context, part, price, index),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSoldOutItem() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgPaper.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_outline, size: 32, color: Colors.grey.withOpacity(0.5)),
            const SizedBox(height: 8),
            Text(
              '已售出',
              style: GoogleFonts.maShanZheng(
                fontSize: 18,
                color: Colors.grey.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _buyItem(Part part, int price, int index) {
    widget.gameService.consumeInk(price);
    widget.gameService.addPartToInventory(part);
    
    setState(() {
      _shopItems[index] = null;
      _itemPrices.remove(part.id);
    });

    _showToast('已购入: ${part.name}');
  }

  void _showItemDetails(BuildContext context, Part part, int price, int index) {
    final player = widget.gameService.player!;
    final equippedPart = player.parts[part.type];
    final isSmallScreen = MediaQuery.of(context).size.width < 380;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          bool isBuying = false;
          bool isSuccess = false;

          void handleBuy() async {
            if (isBuying) return;
            setModalState(() {
              isBuying = true;
            });

            // Simulate delay
            await Future.delayed(const Duration(milliseconds: 600));

            // Check conditions again just in case
            if (widget.gameService.player!.ink >= price) {
              // Perform buy logic but don't close yet
              // We need to call _buyItem on the parent state, but _buyItem calls setState on parent.
              // Since we are in a callback, it's fine.
              
              // However, _buyItem also calls _showToast which needs context.
              // And it modifies _shopItems.
              
              widget.gameService.consumeInk(price);
              widget.gameService.addPartToInventory(part);
              
              // Update parent state
              setState(() {
                _shopItems[index] = null;
                _itemPrices.remove(part.id);
              });

              // Show local success
              if (context.mounted) {
                setModalState(() {
                  isBuying = false;
                  isSuccess = true;
                });
              }

              // Show global toast
              _showToast('已购入: ${part.name}');
              
              // Close after short delay
              await Future.delayed(const Duration(milliseconds: 1000));
              if (context.mounted) {
                Navigator.pop(context);
              }
            } else {
               setModalState(() {
                isBuying = false;
              });
              _showToast('灵墨不足');
            }
          }

          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: const BoxDecoration(
              color: AppColors.bgPaper,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: EdgeInsets.only(bottom: isSmallScreen ? 16 : 24),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
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
                            SizedBox(width: isSmallScreen ? 12 : 16),
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
                        SizedBox(height: isSmallScreen ? 12 : 16),
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
                        SizedBox(height: isSmallScreen ? 16 : 24),
                        if (equippedPart != null) ...[
                          Text('装备对比', style: GoogleFonts.notoSerifSc(fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 14 : 16)),
                          SizedBox(height: isSmallScreen ? 8 : 12),
                          _buildComparisonTable(equippedPart, part, isSmallScreen),
                        ] else ...[
                          Text('属性详情', style: GoogleFonts.notoSerifSc(fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 14 : 16)),
                          SizedBox(height: isSmallScreen ? 8 : 12),
                          _buildStatsList(part),
                        ],
                      ],
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 12 : 16),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (isBuying || isSuccess)
                        ? null
                        : () {
                            if (player.ink < price) {
                              _showToast('灵墨不足');
                              return;
                            }
                            handleBuy();
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSuccess 
                          ? Colors.green 
                          : (player.ink >= price ? AppColors.inkBlack : Colors.grey),
                      foregroundColor: AppColors.bgPaper,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      disabledBackgroundColor: Colors.grey,
                    ),
                    child: isBuying
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(isSuccess ? Icons.check : Icons.shopping_cart_outlined, size: isSmallScreen ? 20 : 24),
                              const SizedBox(width: 8),
                              Text(
                                isSuccess ? '购买成功' : '购买 ($price 墨)',
                                style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 16 : 18),
                              ),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }

  Widget _buildComparisonTable(Part current, Part next, bool isSmallScreen) {
    final keys = {...current.stats.keys, ...next.stats.keys}.toList();
    
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      columnWidths: const {
        0: FlexColumnWidth(1.2),
        1: FlexColumnWidth(1),
        2: FlexColumnWidth(1),
        3: FlexColumnWidth(1),
      },
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.withOpacity(0.1)),
          children: [
            Padding(padding: EdgeInsets.all(isSmallScreen ? 4 : 8), child: Text('属性', style: GoogleFonts.notoSerifSc(fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 10 : 12))),
            Padding(padding: EdgeInsets.all(isSmallScreen ? 4 : 8), child: Text('当前', style: GoogleFonts.notoSerifSc(color: Colors.grey, fontSize: isSmallScreen ? 10 : 12))),
            Padding(padding: EdgeInsets.all(isSmallScreen ? 4 : 8), child: Text('新购', style: GoogleFonts.notoSerifSc(fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 10 : 12))),
            Padding(padding: EdgeInsets.all(isSmallScreen ? 4 : 8), child: Text('变化', style: GoogleFonts.notoSerifSc(fontSize: isSmallScreen ? 10 : 12))),
          ],
        ),
        ...keys.map((key) {
          final currVal = (current.stats[key] ?? 0) as int;
          final nextVal = (next.stats[key] ?? 0) as int;
          final diff = nextVal - currVal;
          final diffColor = diff > 0 ? Colors.green : (diff < 0 ? Colors.red : Colors.grey);
          final diffText = diff > 0 ? '+$diff' : '$diff';
          
          return TableRow(
            children: [
              Padding(padding: EdgeInsets.all(isSmallScreen ? 4 : 8), child: Text(_translateStatKey(key), style: GoogleFonts.notoSerifSc(fontSize: isSmallScreen ? 11 : 13))),
              Padding(padding: EdgeInsets.all(isSmallScreen ? 4 : 8), child: Text('$currVal', style: GoogleFonts.notoSerifSc(color: Colors.grey, fontSize: isSmallScreen ? 11 : 13))),
              Padding(padding: EdgeInsets.all(isSmallScreen ? 4 : 8), child: Text('$nextVal', style: GoogleFonts.notoSerifSc(fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 11 : 13))),
              Padding(padding: EdgeInsets.all(isSmallScreen ? 4 : 8), child: Text(diff == 0 ? '-' : diffText, style: GoogleFonts.notoSerifSc(color: diffColor, fontWeight: FontWeight.bold, fontSize: isSmallScreen ? 11 : 13))),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildStatsList(Part part) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: part.stats.entries.map((e) {
        return Chip(
          backgroundColor: AppColors.woodLight.withOpacity(0.2),
          label: Text(
            '${_translateStatKey(e.key)} +${e.value}',
            style: GoogleFonts.notoSerifSc(fontSize: 12, color: AppColors.inkBlack),
          ),
          padding: EdgeInsets.zero,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        );
      }).toList(),
    );
  }

  void _showToast(String message) {
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.of(context).padding.top + 60,
        left: 32,
        right: 32,
        child: Material(
          color: Colors.transparent,
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 300),
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: child,
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.inkBlack.withOpacity(0.95),
                borderRadius: BorderRadius.circular(30),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                ],
                border: Border.all(color: AppColors.gold.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_outline, color: AppColors.gold, size: 20),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      message,
                      style: GoogleFonts.notoSerifSc(color: AppColors.bgPaper, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);
    Future.delayed(const Duration(seconds: 2), () {
      entry.remove();
    });
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
}

class _PurchaseButton extends StatefulWidget {
  final int price;
  final bool canBuy;
  final VoidCallback onBuy;
  final String label;
  final bool isSmallScreen;
  final bool isTablet;

  final VoidCallback? onFail;

  const _PurchaseButton({
    required this.price,
    required this.canBuy,
    required this.onBuy,
    this.onFail,
    this.label = '购买',
    required this.isSmallScreen,
    required this.isTablet,
  });

  @override
  State<_PurchaseButton> createState() => _PurchaseButtonState();
}

class _PurchaseButtonState extends State<_PurchaseButton> {
  bool _isLoading = false;
  bool _isSuccess = false;

  Future<void> _handleTap() async {
    if (!widget.canBuy) {
      widget.onFail?.call();
      return;
    }

    if (_isLoading) return;

    setState(() => _isLoading = true);
    
    // Simulate processing
    await Future.delayed(const Duration(milliseconds: 600));
    
    widget.onBuy();
    
    if (mounted) {
      setState(() {
        _isLoading = false;
        _isSuccess = true;
      });
      
      Future.delayed(const Duration(milliseconds: 1500), () {
        if (mounted) {
          setState(() => _isSuccess = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isSuccess) {
      return Container(
        padding: EdgeInsets.symmetric(
          horizontal: widget.isSmallScreen ? 12 : (widget.isTablet ? 24 : 16),
          vertical: widget.isTablet ? 16 : 12
        ),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.green),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, size: widget.isSmallScreen ? 12 : (widget.isTablet ? 18 : 14), color: Colors.green),
            const SizedBox(width: 4),
            Text('已购', style: TextStyle(
              fontSize: widget.isTablet ? 18 : 14,
              color: Colors.green,
              fontWeight: FontWeight.bold
            )),
          ],
        ),
      );
    }

    return ElevatedButton(
      onPressed: !_isLoading ? _handleTap : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: widget.canBuy ? AppColors.inkBlack : Colors.grey,
        foregroundColor: AppColors.bgPaper,
        disabledBackgroundColor: Colors.grey.withOpacity(0.3),
        padding: EdgeInsets.symmetric(
          horizontal: widget.isSmallScreen ? 12 : (widget.isTablet ? 24 : 16),
          vertical: widget.isTablet ? 16 : 12
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: _isLoading 
        ? SizedBox(
            width: widget.isTablet ? 18 : 14,
            height: widget.isTablet ? 18 : 14,
            child: const CircularProgressIndicator(strokeWidth: 2, color: AppColors.bgPaper),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.water_drop, size: widget.isSmallScreen ? 12 : (widget.isTablet ? 18 : 14)),
              const SizedBox(width: 4),
              Text('${widget.price}', style: TextStyle(fontSize: widget.isTablet ? 18 : 14)),
            ],
          ),
    );
  }
}
