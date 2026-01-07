import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../widgets/common_widgets.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.height < 600;
    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(isSmallScreen),
          SliverPadding(
            padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildHelpTile(
                  '如何获得灵气？',
                  '灵气是洪荒世界的硬币。您可以通过探索未知区域、击败野外异兽、完成每日任务以及在部落中领取每日祝福来获得。',
                  isSmallScreen,
                ),
                _buildHelpTile(
                  '什么是异兽进化？',
                  '当您的异兽达到一定等级并收集足够的血肉资源后，可以在“进化”页面进行突破。进化不仅能大幅提升各项属性，还有机会改变外形。',
                  isSmallScreen,
                ),
                _buildHelpTile(
                  '战斗失败了怎么办？',
                  '战斗失败不会导致异兽消失，但会损失一部分体力。您可以回到部落进行疗伤，或者使用丹药快速恢复。建议在挑战强大敌人前先在弱小区域磨练。',
                  isSmallScreen,
                ),
                _buildHelpTile(
                  '如何提升部落等级？',
                  '部落等级代表了您的综合实力。消耗灵气和特定材料可以升级部落，升级后将解锁更多建筑功能和更高级的异兽蛋。',
                  isSmallScreen,
                ),
                _buildHelpTile(
                  '存档会丢失吗？',
                  '本游戏采用本地存储。如果您卸载游戏或清理应用数据，存档将会丢失。建议定期使用“手动保存”功能，并关注未来的云存档功能。',
                  isSmallScreen,
                ),
                SizedBox(height: isSmallScreen ? 20 : 32),
                Center(
                  child: Text(
                    '如需更多帮助，请通过“反馈建议”联系我们',
                    style: TextStyle(
                      color: AppColors.textSub.withValues(alpha: 0.5),
                      fontSize: isSmallScreen ? 11 : 12,
                    ),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 20 : 40),
              ]),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildSliverAppBar(bool isSmallScreen) {
    return SliverAppBar(
      expandedHeight: isSmallScreen ? 100 : 120,
      pinned: true,
      backgroundColor: AppColors.bg,
      elevation: 0,
      centerTitle: true,
      title: Text(
        '使用帮助',
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
        ),
      ),
    );
  }

  Widget _buildHelpTile(String question, String answer, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 12 : 16,
            vertical: isSmallScreen ? 0 : 4,
          ),
          title: Text(
            question,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 14 : 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.textSub,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                isSmallScreen ? 12 : 16,
                0,
                isSmallScreen ? 12 : 16,
                isSmallScreen ? 12 : 16,
              ),
              child: Text(
                answer,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: isSmallScreen ? 13 : 14,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
