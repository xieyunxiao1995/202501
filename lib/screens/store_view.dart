import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
import '../state/game_state.dart';
import '../widgets/game_background.dart';

/// 商品データモデル
class StoreItem {
  final String id;
  final String name;
  final String desc;
  final IconData icon;
  final Color color;
  final int price;
  final String category; // 新增分类
  final String rewardType; // '経験' 或 '材料'
  final int rewardAmount;
  final String? badge; // 角标(如: 'すべて', '5折')

  StoreItem({
    required this.id,
    required this.name,
    required this.desc,
    required this.icon,
    required this.color,
    required this.price,
    required this.category,
    required this.rewardType,
    required this.rewardAmount,
    this.badge,
  });
}

class StoreView extends StatefulWidget {
  final GameState gameState;
  final VoidCallback onSave;

  const StoreView({super.key, required this.gameState, required this.onSave});

  @override
  State<StoreView> createState() => _StoreViewState();
}

class _StoreViewState extends State<StoreView>
    with SingleTickerProviderStateMixin {
  String _selectedCategory = 'すべて';

  // 商店商品池配置
  final List<StoreItem> _goods = [
    StoreItem(
      id: 'g1',
      name: '小型経験瓶',
      desc: '少量の英雄経験を提供する、初心者向け。',
      icon: Icons.science_rounded,
      color: Colors.blueAccent,
      price: 1500,
      category: '経験',
      rewardType: '経験',
      rewardAmount: 5000,
    ),
    StoreItem(
      id: 'g2',
      name: '大型経験秘薬',
      desc: '膨大なエネルギーを秘めた秘薬。英雄の成長を加速させる。',
      icon: Icons.biotech_rounded,
      color: Colors.purpleAccent,
      price: 8000,
      category: 'すべて',
      rewardType: '経験',
      rewardAmount: 30000,
      badge: '必買',
    ),
    StoreItem(
      id: 'g3',
      name: '終極経験宝典',
      desc: '古代の英雄の戦闘技巧が記録された書。大量の経験値を提供。',
      icon: Icons.menu_book_rounded,
      color: Colors.redAccent,
      price: 25000,
      category: '経験',
      rewardType: '経験',
      rewardAmount: 100000,
      badge: '超お得',
    ),
    StoreItem(
      id: 'g4',
      name: '普通召喚券',
      desc: '旅館で仲間を召喚するための基礎券。',
      icon: Icons.local_activity_rounded,
      color: Colors.cyan,
      price: 2000,
      category: '召喚',
      rewardType: '材料',
      rewardAmount: 1,
    ),
    StoreItem(
      id: 'g5',
      name: '高級召喚券',
      desc: '必ず高レアリティ英雄が入手できる高級券!',
      icon: Icons.stars_rounded,
      color: Colors.orangeAccent,
      price: 10000,
      category: 'すべて',
      rewardType: '材料',
      rewardAmount: 1,
      badge: '特供',
    ),
    StoreItem(
      id: 'g6',
      name: '強化石',
      desc: '用于打磨武器的神秘矿石(获得10个)。',
      icon: Icons.diamond_rounded,
      color: Colors.pinkAccent,
      price: 3000,
      category: '材料',
      rewardType: '材料',
      rewardAmount: 10,
    ),
    StoreItem(
      id: 'g7',
      name: '突破結晶',
      desc: '英雄の潜在能力の限界を突破する核心素材。',
      icon: Icons.change_history_rounded,
      color: Colors.greenAccent,
      price: 15000,
      category: '材料',
      rewardType: '材料',
      rewardAmount: 1,
    ),
    StoreItem(
      id: 'g8',
      name: '神秘福袋',
      desc: '運試しの瞬間！ランダムで豊富な物資を入手。',
      icon: Icons.redeem_rounded,
      color: Colors.amber,
      price: 5000,
      category: 'すべて',
      rewardType: 'ランダム',
      rewardAmount: 1,
      badge: '人気',
    ),
  ];

  void _buyItem(StoreItem item) {
    if (widget.gameState.gold < item.price) {
      _showErrorDialog('ゴールド不足', '探険で魔物を倒すか、遊園地を回ってゴールドを稼ぎましょう!');
      return;
    }

    // 弹窗确认购买
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xff2a1b14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xff8c6751), width: 2),
        ),
        title: const Text(
          '取引確認',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: RichText(
          text: TextSpan(
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 16,
              height: 1.5,
            ),
            children: [
              const TextSpan(text: '是否花费 '),
              TextSpan(
                text: '${item.price} 金币',
                style: const TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: '\n购买【'),
              TextSpan(
                text: item.name,
                style: TextStyle(
                  color: item.color,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const TextSpan(text: '】を購入しますか？'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('もう少し考える', style: TextStyle(color: Colors.white54)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _processTransaction(item);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffd49d6a),
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              '購入完了',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _processTransaction(StoreItem item) {
    String successMessage = '';

    setState(() {
      widget.gameState.spendGold(item.price);

      if (item.rewardType == '経験') {
        widget.gameState.addExp(item.rewardAmount);
        successMessage = '${item.rewardAmount} 経験値を獲得！';
      } else if (item.rewardType == '材料') {
        widget.gameState.addMaterial(item.name, item.rewardAmount);
        successMessage = '【${item.name}】x${item.rewardAmount} はバックパックに保管されました。';
      } else if (item.rewardType == 'ランダム') {
        // 福袋の特殊ロジック
        final rand = Random().nextInt(100);
        if (rand < 50) {
          widget.gameState.addMaterial('強化石', 15);
          successMessage = '福袋から【強化石】が登場x15！';
        } else if (rand < 85) {
          widget.gameState.addMaterial('普通召喚券', 2);
          successMessage = 'ラッキー！登場した【普通召喚券】x2！';
        } else {
          widget.gameState.addMaterial('高級召喚券', 1);
          successMessage = '大当たり！稀有な【高級召喚券】！';
        }
      }
    });

    widget.gameState.save();
    widget.onSave();

    // 成功提示(顶部SnackBar更优雅)
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green.shade800,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 150,
          left: 20,
          right: 20,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '购买成功！\n$successMessage',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xff2a1b14),
        title: Row(
          children: [
            const Icon(Icons.warning_rounded, color: Colors.redAccent),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(message, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              '分かった',
              style: TextStyle(color: Color(0xffd49d6a)),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredGoods = _selectedCategory == 'すべて'
        ? _goods
        : _goods.where((g) => g.category == _selectedCategory).toList();

    return GameBackground(
      backgroundImage: BackgroundUtil.getBgByScene('store'),
      overlayOpacity: BackgroundUtil.getOverlayOpacityForScene('store'),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildCurrencyBar(),
                _buildCategoryTabs(),
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      top: 10,
                      bottom: 40,
                    ),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.65, // 控制卡片长宽比
                        ),
                    itemCount: filteredGoods.length,
                    itemBuilder: (context, index) {
                      return _buildGoodsCard(filteredGoods[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xff25150d), Color(0xff0a0502)],
        ),
      ),
      child: CustomPaint(painter: WoodTexturePainter(), size: Size.infinite),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: Color(0xffe2c7a8),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              '神秘商店',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Color(0xffe2c7a8),
                letterSpacing: 4,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildCurrencyBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xff5d3b24), width: 1.5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            '現在所持',
            style: TextStyle(color: Colors.white54, fontSize: 14),
          ),
          Row(
            children: [
              const Icon(
                Icons.monetization_on_rounded,
                color: Colors.amber,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                widget.gameState.gold.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    final categories = ['すべて', '経験', '材料', '召喚', 'すべて'];
    return Container(
      height: 50,
      margin: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        itemBuilder: (ctx, index) {
          final cat = categories[index];
          final isSelected = _selectedCategory == cat;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 12),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xffd49d6a)
                    : Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(25),
                border: Border.all(
                  color: isSelected
                      ? Colors.transparent
                      : const Color(0xff5d3b24),
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xffd49d6a).withValues(alpha: 0.4),
                          blurRadius: 8,
                        ),
                      ]
                    : [],
              ),
              alignment: Alignment.center,
              child: Text(
                cat,
                style: TextStyle(
                  color: isSelected ? Colors.black : const Color(0xffe2c7a8),
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGoodsCard(StoreItem item) {
    final canAfford = widget.gameState.gold >= item.price;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xff2a1b14),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xff5d3b24), width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Column(
              children: [
                // 上半部分：物品图标背景
                Expanded(
                  flex: 5,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          item.color.withValues(alpha: 0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(item.icon, size: 60, color: item.color),
                    ),
                  ),
                ),

                // 下半部分：信息与按钮
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              item.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              item.desc,
                              style: const TextStyle(
                                color: Colors.white54,
                                fontSize: 10,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),

                        GestureDetector(
                          onTap: () => _buyItem(item),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            decoration: BoxDecoration(
                              color: canAfford
                                  ? const Color(0xffd49d6a)
                                  : Colors.grey.shade800,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.monetization_on_rounded,
                                  size: 14,
                                  color: canAfford
                                      ? Colors.black87
                                      : Colors.white54,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  item.price.toString(),
                                  style: TextStyle(
                                    color: canAfford
                                        ? Colors.black87
                                        : Colors.white54,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // 角标 (如果有)
            if (item.badge != null)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                  child: Text(
                    item.badge!,
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
}

/// 背景木质纹理自绘
class WoodTexturePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withValues(alpha: 0.1)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (double i = 0; i < size.height; i += 40) {
      final path = Path();
      path.moveTo(0, i);
      for (double j = 0; j < size.width; j += 20) {
        path.lineTo(j, i + (j % 40 == 0 ? 5 : -5));
      }
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
