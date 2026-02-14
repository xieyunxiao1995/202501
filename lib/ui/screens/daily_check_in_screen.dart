import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/daily_reward.dart';
import '../../utils/constants.dart';
import '../widgets/background_scaffold.dart';

class DailyCheckInScreen extends StatefulWidget {
  const DailyCheckInScreen({super.key});

  @override
  State<DailyCheckInScreen> createState() => _DailyCheckInScreenState();
}

class _DailyCheckInScreenState extends State<DailyCheckInScreen> {
  // 模拟数据，实际应从API获取
  List<DailyReward> rewards = List.from(initialDailyRewards);
  final int _currentDayIndex = 0; // 假设今天是第1天（索引0）

  void _claimReward(int index) {
    if (index != _currentDayIndex &&
        rewards[index].status != RewardStatus.available) {
      return; // 只能领取当天的或可领取的
    }

    setState(() {
      rewards[index] = rewards[index].copyWith(status: RewardStatus.claimed);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '已领取 ${rewards[index].itemName} x${rewards[index].count}',
          style: GoogleFonts.notoSerifSc(color: Colors.white),
        ),
        backgroundColor: AppColors.inkRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;
    // 调整面板高度比例
    final double panelHeightPct = isSmallScreen ? 0.60 : 0.70;

    return BackgroundScaffold(
      backgroundImage: AppAssets.bgGiantLotusPond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _buildBackButton(),
        title: ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFFE082), Color(0xFFFFB300)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ).createShader(bounds),
          child: Text(
            '每日签到',
            style: GoogleFonts.maShanZheng(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Required for ShaderMask
              shadows: [
                const Shadow(
                  offset: Offset(0, 2),
                  blurRadius: 4,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 1. 角色层 (Character Layer)
          Positioned(
            top: -size.height * 0.08,
            right: -size.width * 0.15,
            height: size.height * 0.72,
            child: Transform.flip(
              flipX: true,
              child: Image.asset(
                'assets/role/Nine-Tailed_Fox_3D.png',
                fit: BoxFit.contain,
              ),
            ),
          ),

          // 2. 主内容面板 (Main Panel)
          Container(
            height: size.height * panelHeightPct,
            width: isSmallScreen ? size.width : 600,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFFDFBF7).withOpacity(0.96),
                  const Color(0xFFF5F0E6).withOpacity(1.0),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(36),
                topRight: Radius.circular(36),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 24),
                // 签到进度条区域
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildStreakHeader(),
                ),
                const SizedBox(height: 16),
                // 装饰分割线
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 1,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.brown.withOpacity(0.2),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // 物品网格区域
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: _buildRewardsGrid(isSmallScreen),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackButton() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, size: 18),
        color: Colors.white,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  // --- 签到进度条组件 (高度还原版) ---
  Widget _buildStreakHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 左侧：大圆圈 + 底部文字
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52, // 加大尺寸
              height: 52,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9FA8DA), Color(0xFF7986CB)], // 柔和的紫蓝色
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF7986CB).withOpacity(0.4),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(color: Colors.white, width: 2.5),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '1天',
                      style: GoogleFonts.notoSerifSc(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '连续签到',
              style: GoogleFonts.notoSerifSc(
                color: const Color(0xFF5D4037),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
        // 右侧：进度条
        Expanded(
          child: Container(
            height: 70, // 给予足够高度对齐
            padding: const EdgeInsets.only(top: 20), // 让进度条对齐圆圈中部
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.centerLeft,
              children: [
                // 1. 背景槽 (Background Track)
                Container(
                  height: 6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                // 2. 进度填充 (Progress Fill)
                Container(
                  height: 6,
                  width: 50, // 示例进度
                  decoration: BoxDecoration(
                    color: const Color(0xFF81C784), // 浅绿色
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                // 3. 宝箱节点 (Chest Nodes)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(width: 16), // 错开左侧
                    _buildChestItem('连续3天'),
                    _buildChestItem('连续5天'),
                    _buildChestItem('连续7天'),
                    const SizedBox(width: 0),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChestItem(String text) {
    return Transform.translate(
      offset: const Offset(0, -14), // Move the entire widget up by 14 pixels
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/item/Chibi_treasure_chest.png',
            width: 32,
            height: 32,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 2),
          Text(
            text,
            style: GoogleFonts.notoSerifSc(
              fontSize: 10,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // --- 网格组件 ---
  Widget _buildRewardsGrid(bool isSmall) {
    return GridView.builder(
      padding: const EdgeInsets.only(bottom: 20),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.78, // 更修长的比例
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
      ),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        return _buildItemCard(rewards[index], index);
      },
    );
  }

  Widget _buildItemCard(DailyReward reward, int index) {
    final bool isToday = index == _currentDayIndex;
    final bool isClaimed = reward.status == RewardStatus.claimed;

    // 颜色配置 - 调整为更柔和的色调
    final bool isRare =
        reward.rarity == RewardRarity.sr || reward.rarity == RewardRarity.ssr;

    // SR: 淡紫色背景 (Lavender)
    // Normal: 淡奶油色背景 (Cream)
    final Color bgColor = isRare
        ? const Color(0xFFDED6F6)
        : const Color(0xFFFFF3E0);

    final Color borderColor = isRare
        ? const Color(0xFFB39DDB)
        : const Color(0xFFFFCC80);

    return GestureDetector(
      onTap: () => _claimReward(index),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 卡片主体
          Container(
            decoration: BoxDecoration(
              color: isClaimed ? Colors.grey[200] : bgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isClaimed ? Colors.grey[300]! : borderColor,
                width: 1,
              ),
              boxShadow: isToday && !isClaimed
                  ? [
                      // 选中时的发光效果
                      BoxShadow(
                        color: Colors.orange.withOpacity(0.3),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: Stack(
              children: [
                // 1. SR 标签 (精致的小方块)
                if (isRare && !isClaimed)
                  Positioned(
                    top: 0,
                    left: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFF7E57C2), // 深紫色
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(11),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // 模拟截图中的小图标
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 1),
                              borderRadius: BorderRadius.circular(1),
                            ),
                            child: const Icon(
                              Icons.grid_view,
                              size: 6,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            "SR",
                            style: GoogleFonts.roboto(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                // 2. 物品图片
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 18),
                    child: Image.asset(
                      reward.assetPath,
                      fit: BoxFit.contain,
                      color: isClaimed ? Colors.black.withOpacity(0.3) : null,
                      colorBlendMode: isClaimed ? BlendMode.srcATop : null,
                    ),
                  ),
                ),

                // 3. 星星 (底部左侧 - 精致排列)
                if (isRare && !isClaimed)
                  Positioned(
                    bottom: 4,
                    left: 4,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        3,
                        (index) => Padding(
                          padding: const EdgeInsets.only(right: 1),
                          child: const Icon(
                            Icons.star,
                            size: 10,
                            color: Color(0xFFFFCA28), // 琥珀色星星
                            shadows: [
                              Shadow(
                                color: Colors.black12,
                                offset: Offset(0, 1),
                                blurRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                // 4. 数量 (底部右侧 - 强描边)
                Positioned(
                  bottom: 2,
                  right: 6,
                  child: Stack(
                    children: [
                      // 描边层 (Stroke)
                      Text(
                        "${reward.count}",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 3
                            ..color = isClaimed
                                ? Colors.grey[400]!
                                : Colors.black.withOpacity(0.5),
                        ),
                      ),
                      // 实体层 (Fill)
                      Text(
                        "${reward.count}",
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                // 5. 已领取遮罩
                if (isClaimed)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 6. 红点 (右上角 - 仅显示在当天未领取时)
          if (isToday && !isClaimed)
            Positioned(
              top: -3,
              right: -3,
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 2)],
                ),
                child: const Center(
                  child: Text(
                    "!",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
