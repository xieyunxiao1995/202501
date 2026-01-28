import 'package:flutter/material.dart';
import '../widgets/background_wrapper.dart';

class HelpScreen extends StatelessWidget {
  final VoidCallback onClose;

  const HelpScreen({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return BackgroundWrapper(
      backgroundImage: 'assets/bg/Bg2.jpeg',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.white70, size: isSmallScreen ? 20 : 24),
            onPressed: onClose,
          ),
          title: Text(
            "使用帮助",
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 18 : 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            _buildHeader("修行指南", isSmallScreen),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              "基础操作",
              [
                _buildTip("移动", "点击相邻卡牌，指引修仙者移动到目标位置", isSmallScreen),
                _buildTip("战斗", "点击妖兽卡牌进行战斗，妖力值等于伤害值", isSmallScreen),
                _buildTip("收集", "点击灵石、道具等卡牌进行收集", isSmallScreen),
                _buildTip("退出", "点击传送门进入下一层", isSmallScreen),
              ],
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              "卡牌类型",
              [
                _buildCardType("🗡️ 武器", "增加攻击力，提升战斗能力", isSmallScreen),
                _buildCardType("🛡️ 护盾", "增加护身值，抵御伤害", isSmallScreen),
                _buildCardType("🧪 丹药", "回复精血，恢复生命值", isSmallScreen),
                _buildCardType("💰 灵石", "收集灵石，用于万宝阁兑换", isSmallScreen),
                _buildCardType("🗝️ 钥匙", "用于开启宝箱", isSmallScreen),
                _buildCardType("📦 宝箱", "使用钥匙开启，可能获得稀有道具", isSmallScreen),
                _buildCardType("🔮 祭坛", "提供增益或减益效果", isSmallScreen),
                _buildCardType("🌀 传送门", "进入下一层", isSmallScreen),
                _buildCardType("👻 妖兽", "战斗敌人，击败获得奖励", isSmallScreen),
              ],
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              "传承异志",
              [
                _buildClass("⚔️ 荒古剑修", "御剑乘风，擅长正面交锋，剑意凌人", isSmallScreen),
                _buildClass("🪨 磐石力士", "不动如山，身怀大荒血脉，拥有极高的精血与防御", isSmallScreen),
                _buildClass("🏹 大荒羽士", "身轻如燕，箭无虚发，擅长爆发与身法闪避", isSmallScreen),
                _buildClass("⚡ 归元真人", "感悟雷法，引动“五雷正法”可焚尽全场妖孽", isSmallScreen),
              ],
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              "进阶技巧",
              [
                _buildTip("连击", "连续击败妖兽可获得连击加成", isSmallScreen),
                _buildTip("属性克制", "金木水火土五行相生相克，合理利用属性克制", isSmallScreen),
                _buildTip("资源管理", "合理分配灵石，优先购买关键道具", isSmallScreen),
                _buildTip("探索", "尽可能探索所有区域，获取更多资源", isSmallScreen),
                _buildTip("风险控制", "在精血不足时谨慎战斗，避免死亡", isSmallScreen),
              ],
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              "功能系统",
              [
                _buildTip("万宝阁", "使用灵石购买永久天赋和临时增益", isSmallScreen),
                _buildTip("乾坤炉", "收集材料炼制丹药，提升下次冒险属性", isSmallScreen),
                _buildTip("七日礼", "每日登录签到，领取丰厚奖励", isSmallScreen),
                _buildTip("图鉴", "查看已收集的妖兽和道具图鉴", isSmallScreen),
                _buildTip("功业录", "查看成就进度，解锁特殊奖励", isSmallScreen),
                _buildTip("秘境", "选择不同关卡进行挑战，解锁需要达到一定气运", isSmallScreen),
              ],
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 16 : 24),
            _buildSection(
              "常见问题",
              [
                _buildQA("如何获得更多灵石？", "击败妖兽、开启宝箱、完成成就、每日签到都可以获得灵石", isSmallScreen),
                _buildQA("如何解锁新传承？", "达到一定气运值后，新的传承会自动解锁", isSmallScreen),
                _buildQA("游戏数据会丢失吗？", "不会。游戏进度保存在本地，卸载应用前请先备份", isSmallScreen),
                _buildQA("如何获得稀有道具？", "在宝箱、祭坛和商店中有几率获得稀有道具", isSmallScreen),
                _buildQA("如何提升战力？", "收集武器、炼制丹药、购买天赋都可以提升战力", isSmallScreen),
              ],
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 24 : 32),
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  Icon(Icons.lightbulb_outline, color: Colors.blue, size: isSmallScreen ? 20 : 24),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  Text(
                    "温馨提示",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: isSmallScreen ? 13 : 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 6 : 8),
                  Text(
                    "修行之路漫长，请保持耐心。合理规划资源，善用策略，你一定能成为大荒主宰！",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isSmallScreen ? 11 : 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: isSmallScreen ? 24 : 32),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildHeader(String title, bool isSmallScreen) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.amber,
        fontSize: isSmallScreen ? 20 : 24,
        fontWeight: FontWeight.bold,
        letterSpacing: 1,
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 16 : 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildTip(String title, String description, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.only(bottom: isSmallScreen ? 8.0 : 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: isSmallScreen ? 20 : 24,
            height: isSmallScreen ? 20 : 24,
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Center(
              child: Icon(
                Icons.arrow_forward,
                color: Colors.amber,
                size: isSmallScreen ? 14 : 16,
              ),
            ),
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 13 : 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isSmallScreen ? 12 : 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardType(String title, String description, bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 8 : 12,
              vertical: isSmallScreen ? 4 : 6,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: isSmallScreen ? 12 : 13,
              ),
            ),
          ),
          SizedBox(width: isSmallScreen ? 8 : 12),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: Colors.white70,
                fontSize: isSmallScreen ? 12 : 13,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClass(String title, String description, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.only(bottom: isSmallScreen ? 8.0 : 12.0),
      child: Container(
        padding: EdgeInsets.all(isSmallScreen ? 10 : 12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white10),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.amber,
                fontSize: isSmallScreen ? 13 : 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: isSmallScreen ? 8 : 12),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: isSmallScreen ? 12 : 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQA(String question, String answer, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.only(bottom: isSmallScreen ? 8.0 : 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Q: $question",
            style: TextStyle(
              color: Colors.amber,
              fontSize: isSmallScreen ? 13 : 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "A: $answer",
            style: TextStyle(
              color: Colors.white70,
              fontSize: isSmallScreen ? 12 : 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
