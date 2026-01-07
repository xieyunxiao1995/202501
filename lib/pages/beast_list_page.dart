import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/beast_model.dart';
import 'beast_detail_page.dart';

class BeastListPage extends StatelessWidget {
  final List<Beast> beasts;
  final Function(Beast) onUpdateBeast; // 新增回调

  const BeastListPage({
    super.key,
    required this.beasts,
    required this.onUpdateBeast,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.height < 600;

    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "山海异兽录",
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "数量: ${beasts.length}",
                style: TextStyle(
                  color: AppColors.textSub,
                  fontSize: isSmallScreen ? 11 : 12,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          Expanded(
            child: ListView.builder(
              itemCount: beasts.length + 1,
              itemBuilder: (ctx, idx) {
                if (idx == beasts.length) {
                  return Container(
                    height: 80,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white10),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        "捕捉更多异兽以解锁",
                        style: TextStyle(
                          color: AppColors.textSub,
                          fontSize: isSmallScreen ? 11 : 12,
                        ),
                      ),
                    ),
                  );
                }
                final beast = beasts[idx];
                return _buildBeastCard(context, beast, isSmallScreen);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeastCard(
    BuildContext context,
    Beast beast,
    bool isSmallScreen,
  ) {
    Color tierColor = AppColors.secondary;
    if (beast.tier == "千年") tierColor = AppColors.primary;
    if (beast.tier == "万年") tierColor = AppColors.danger;

    final double iconSize = isSmallScreen ? 64 : 80;

    return GestureDetector(
      onTap: () {
        // 导航至详情页
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                BeastDetailPage(beast: beast, onUpdate: onUpdateBeast),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: tierColor.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: tierColor.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // 异兽文字图标
            Hero(
              tag: 'beast_${beast.id}', // Hero动画
              child: Stack(
                children: [
                  Container(
                    width: iconSize,
                    height: iconSize,
                    decoration: BoxDecoration(
                      color: tierColor.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: tierColor.withOpacity(0.4),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          beast.name.substring(0, 1),
                          style: TextStyle(
                            color: tierColor,
                            fontSize: isSmallScreen ? 28 : 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 1,
                      ),
                      decoration: BoxDecoration(
                        color: tierColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        beast.tier,
                        style: const TextStyle(
                          fontSize: 7,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                  if (beast.isLocked)
                    const Positioned(
                      bottom: 4,
                      left: 4,
                      child: Icon(Icons.lock, size: 10, color: Colors.white54),
                    ),
                ],
              ),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    beast.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isSmallScreen ? 16 : 18,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 4 : 6),
                  _buildStatRow(beast.stats, isSmallScreen),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  // 部位展示
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: beast.parts
                          .map(
                            (p) => Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.05),
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.white10),
                              ),
                              child: Text(
                                p,
                                style: TextStyle(
                                  fontSize: isSmallScreen ? 9 : 10,
                                  color: AppColors.textSub,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.white24, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(BeastStats stats, bool isSmallScreen) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem("HP", stats.hp, Colors.green, isSmallScreen),
          _statItem("ATK", stats.atk, AppColors.danger, isSmallScreen),
          _statItem("DEF", stats.def, AppColors.info, isSmallScreen),
          _statItem("SPD", stats.spd, AppColors.secondary, isSmallScreen),
        ],
      ),
    );
  }

  Widget _statItem(String label, int val, Color color, bool isSmallScreen) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 7 : 8,
            color: AppColors.textSub,
          ),
        ),
        Text(
          "$val",
          style: TextStyle(
            fontSize: isSmallScreen ? 10 : 11,
            color: color,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ],
    );
  }
}
