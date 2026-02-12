import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../utils/constants.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 380;

    return Scaffold(
      backgroundColor: AppColors.bgPaper,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.inkBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('使用帮助', style: GoogleFonts.maShanZheng(color: AppColors.inkBlack, fontSize: isSmallScreen ? 24 : 28)),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        children: [
          _buildHelpItem(
            '基础玩法',
            '在《山海墨世》中，你需要通过探索地图节点，收集“灵言”卡牌与敌人战斗。每次战斗胜利可获得资源，用于强化自身或购买道具。',
            isSmallScreen,
          ),
          _buildHelpItem(
            '战斗系统',
            '战斗采用回合制卡牌对战。\n1. 每回合抽取一定数量的手牌。\n2. 消耗“墨韵”（能量）打出卡牌。\n3. 卡牌分为攻击、防御、技能等类型。\n4. 敌人的意图会在头顶显示，请根据意图合理应对。',
            isSmallScreen,
          ),
          _buildHelpItem(
            '肢体与异变',
            '击败强敌或遭遇特殊事件可能获得新的“肢体”。肢体不仅改变外观，还提供强大的被动效果和专属卡牌。但要注意，过多的异变可能导致理智值下降。',
            isSmallScreen,
          ),
          _buildHelpItem(
            '理智系统',
            '理智值代表角色的精神状态。遭遇恐怖事件或过度使用禁忌力量会降低理智。理智过低时，可能会遭遇幻觉或受到额外伤害，但也可能触发疯狂的强力效果。',
            isSmallScreen,
          ),
          _buildHelpItem(
            '常见问题',
            'Q: 游戏存档在哪里？\nA: 游戏采用自动存档机制，每次战斗结束或进入新节点时会自动保存。\n\nQ: 如何恢复生命值？\nA: 在休息节点（篝火）休息，或使用恢复类道具/卡牌。',
            isSmallScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String title, String content, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.book, color: AppColors.inkRed, size: isSmallScreen ? 18 : 20),
              SizedBox(width: isSmallScreen ? 6 : 8),
              Text(
                title,
                style: GoogleFonts.maShanZheng(fontSize: isSmallScreen ? 18 : 22, color: AppColors.inkBlack, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF3EFE6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.woodDark.withOpacity(0.2)),
            ),
            child: Text(
              content,
              style: GoogleFonts.notoSerifSc(fontSize: isSmallScreen ? 14 : 16, height: 1.6, color: AppColors.inkBlack),
            ),
          ),
        ],
      ),
    );
  }
}
