import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/tribe_model.dart';

class TribePage extends StatelessWidget {
  final int spirit;
  final TribeData tribeData;
  final VoidCallback onUpgrade;
  final Function(String) onUpgradeBlessing;
  final VoidCallback onBuyEgg;
  final VoidCallback onHeal;

  const TribePage({
    super.key,
    required this.spirit,
    required this.tribeData,
    required this.onUpgrade,
    required this.onUpgradeBlessing,
    required this.onBuyEgg,
    required this.onHeal,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.height < 600;

    return ListView(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      children: [
        // 顶部图腾展示
        _buildTotemShowcase(context, isSmallScreen),
        SizedBox(height: isSmallScreen ? 20 : 30),

        // 科技树部分
        _buildTechSection(context, isSmallScreen),
        SizedBox(height: isSmallScreen ? 20 : 30),

        // 市场部分
        _buildMarketSection(isSmallScreen),
      ],
    );
  }

  Widget _buildTotemShowcase(BuildContext context, bool isSmallScreen) {
    final canAfford = spirit >= tribeData.upgradeCost;
    final totemSize = isSmallScreen ? 90.0 : 120.0;
    final ringSize = isSmallScreen ? 100.0 : 130.0;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: totemSize,
              height: totemSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary.withOpacity(0.2)),
              ),
            ),
            TweenAnimationBuilder(
              duration: const Duration(seconds: 10),
              tween: Tween<double>(begin: 0, end: 2 * 3.14159),
              builder: (ctx, val, child) {
                return Transform.rotate(
                  angle: val,
                  child: Container(
                    width: ringSize,
                    height: ringSize,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                        width: isSmallScreen ? 2 : 3,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: isSmallScreen ? 6 : 8,
                        height: isSmallScreen ? 6 : 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Icon(
              Icons.auto_awesome,
              size: isSmallScreen ? 36 : 48,
              color: AppColors.primary,
            ),
          ],
        ),
        SizedBox(height: isSmallScreen ? 12 : 16),
        Text(
          "九黎部落",
          style: TextStyle(
            fontSize: isSmallScreen ? 18 : 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'serif',
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        InkWell(
          onTap: () => _showUpgradeDialog(context, isSmallScreen),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.card.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: canAfford
                    ? AppColors.primary.withOpacity(0.5)
                    : Colors.white10,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "LV.${tribeData.level} TRIBE",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 9 : 10,
                    color: canAfford ? AppColors.primary : AppColors.textSub,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_upward,
                  size: isSmallScreen ? 9 : 10,
                  color: canAfford ? AppColors.primary : AppColors.textSub,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showUpgradeDialog(BuildContext context, bool isSmallScreen) {
    final cost = tribeData.upgradeCost;
    final canAfford = spirit >= cost;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          "部落升级",
          style: TextStyle(
            color: AppColors.primary,
            fontSize: isSmallScreen ? 16 : 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "当前等级: Lv.${tribeData.level}",
              style: TextStyle(
                color: Colors.white70,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
            Text(
              "下一等级: Lv.${tribeData.level + 1}",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Text(
              "升级效果:",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
            Text(
              "• 开启更多赐福位面",
              style: TextStyle(
                color: Colors.white70,
                fontSize: isSmallScreen ? 11 : 12,
              ),
            ),
            Text(
              "• 提高异兽基础属性加成",
              style: TextStyle(
                color: Colors.white70,
                fontSize: isSmallScreen ? 11 : 12,
              ),
            ),
            Text(
              "• 增加集市稀有物品出现率",
              style: TextStyle(
                color: Colors.white70,
                fontSize: isSmallScreen ? 11 : 12,
              ),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Row(
              children: [
                Icon(
                  Icons.bolt,
                  size: isSmallScreen ? 14 : 16,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 4),
                Text(
                  "消耗: $cost 灵气",
                  style: TextStyle(
                    color: canAfford ? AppColors.secondary : AppColors.danger,
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 13 : 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "取消",
              style: TextStyle(
                color: AppColors.textSub,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: canAfford
                ? () {
                    onUpgrade();
                    Navigator.pop(context);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: Colors.white10,
              padding: isSmallScreen
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                  : null,
            ),
            child: Text(
              "升级",
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTechSection(BuildContext context, bool isSmallScreen) {
    final activatedCount = tribeData.blessings.where((b) => b.level > 0).length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  size: isSmallScreen ? 14 : 16,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 8),
                Text(
                  "图腾赐福",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 13 : 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMain,
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "$activatedCount/${tribeData.blessings.length} 已激活",
                style: TextStyle(
                  fontSize: isSmallScreen ? 9 : 10,
                  color: AppColors.textSub,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        ...tribeData.blessings
            .map((b) => _buildTotemCard(context, b, isSmallScreen))
            .toList(),
      ],
    );
  }

  Widget _buildTotemCard(
    BuildContext context,
    TotemBlessing blessing,
    bool isSmallScreen,
  ) {
    IconData iconData = Icons.help_outline;
    if (blessing.icon == 'swords') iconData = Icons.change_history;
    if (blessing.icon == 'zap') iconData = Icons.bolt;
    if (blessing.icon == 'droplet') iconData = Icons.water_drop;
    if (blessing.icon == 'shield') iconData = Icons.shield;
    if (blessing.icon == 'wind') iconData = Icons.air;

    final canAfford = spirit >= blessing.cost;

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 8 : 12),
      padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
      decoration: BoxDecoration(
        color: AppColors.card.withOpacity(0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            width: isSmallScreen ? 32 : 40,
            height: isSmallScreen ? 32 : 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              iconData,
              color: AppColors.textSub,
              size: isSmallScreen ? 16 : 20,
            ),
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      blessing.name,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 12 : 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textMain,
                      ),
                    ),
                    Text(
                      "Lv.${blessing.level}",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 9 : 10,
                        color: AppColors.primary,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  blessing.desc,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 9 : 10,
                    color: AppColors.textSub,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              InkWell(
                onTap: () => _showBlessingDialog(context, blessing, isSmallScreen),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: canAfford ? Colors.white10 : Colors.black26,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: canAfford ? Colors.white24 : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    "提升",
                    style: TextStyle(
                      fontSize: isSmallScreen ? 9 : 10,
                      color: canAfford ? AppColors.textMain : AppColors.textSub,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "${blessing.cost} 灵气",
                style: TextStyle(
                  fontSize: isSmallScreen ? 8 : 9,
                  color: AppColors.textSub,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showBlessingDialog(
    BuildContext context,
    TotemBlessing blessing,
    bool isSmallScreen,
  ) {
    final canAfford = spirit >= blessing.cost;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          blessing.name,
          style: TextStyle(
            color: AppColors.primary,
            fontSize: isSmallScreen ? 16 : 18,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              blessing.desc,
              style: TextStyle(
                color: Colors.white70,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Text(
              "当前等级: Lv.${blessing.level}",
              style: TextStyle(
                color: Colors.white70,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
            Text(
              "下一等级: Lv.${blessing.level + 1}",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Text(
              "当前加成:",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
            Text(
              "+${(blessing.effectValue * 100).toInt()}%",
              style: TextStyle(
                color: Colors.green,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "下一级加成:",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
            Text(
              "+${((blessing.level + 1) * 5)}%",
              style: TextStyle(
                color: AppColors.primary,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Row(
              children: [
                Icon(
                  Icons.bolt,
                  size: isSmallScreen ? 14 : 16,
                  color: AppColors.secondary,
                ),
                const SizedBox(width: 4),
                Text(
                  "消耗: ${blessing.cost} 灵气",
                  style: TextStyle(
                    color: canAfford ? AppColors.secondary : AppColors.danger,
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 13 : 14,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "取消",
              style: TextStyle(
                color: AppColors.textSub,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: canAfford
                ? () {
                    onUpgradeBlessing(blessing.id);
                    Navigator.pop(context);
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: Colors.white10,
              padding: isSmallScreen
                  ? const EdgeInsets.symmetric(horizontal: 16, vertical: 8)
                  : null,
            ),
            child: Text(
              "提升",
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarketSection(bool isSmallScreen) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: isSmallScreen ? 14 : 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              "部落集市",
              style: TextStyle(
                fontSize: isSmallScreen ? 13 : 14,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
          ],
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        Row(
          children: [
            Expanded(
              child: _buildMarketItem(
                "灵石袋",
                "100 功德",
                Icons.diamond_outlined,
                AppColors.secondary,
                () {},
                isSmallScreen,
              ),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            Expanded(
              child: _buildMarketItem(
                "变异诱发剂",
                "500 功德",
                Icons.science_outlined,
                AppColors.danger,
                () {},
                isSmallScreen,
              ),
            ),
          ],
        ),
        SizedBox(height: isSmallScreen ? 8 : 12),
        Row(
          children: [
            Expanded(
              child: _buildMarketItem(
                "千年灵草",
                "50 灵气",
                Icons.eco,
                Colors.green,
                onHeal,
                isSmallScreen,
              ),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            Expanded(
              child: _buildMarketItem(
                "异兽蛋",
                "1000 灵气",
                Icons.egg,
                AppColors.primary,
                onBuyEgg,
                isSmallScreen,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMarketItem(
    String name,
    String price,
    IconData icon,
    Color color,
    VoidCallback onTap,
    bool isSmallScreen,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
        decoration: BoxDecoration(
          color: AppColors.card.withOpacity(0.4),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          children: [
            Container(
              width: isSmallScreen ? 24 : 32,
              height: isSmallScreen ? 24 : 32,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: isSmallScreen ? 12 : 16,
                color: color,
              ),
            ),
            SizedBox(height: isSmallScreen ? 4 : 8),
            Text(
              name,
              style: TextStyle(
                fontSize: isSmallScreen ? 11 : 12,
                color: AppColors.textMain,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              "售价: $price",
              style: TextStyle(
                fontSize: isSmallScreen ? 8 : 10,
                color: AppColors.textSub,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
