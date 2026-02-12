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
  List<DailyReward> rewards = List.from(initialDailyRewards);
  int _selectedTabIndex = 2; // Default to 'Daily Check-in'

  void _claimReward(int index) {
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

  Color _getRarityColor(RewardRarity rarity) {
    switch (rarity) {
      case RewardRarity.r:
        return Colors.blue.shade300;
      case RewardRarity.sr:
        return Colors.purple.shade300;
      case RewardRarity.ssr:
        return Colors.orange.shade300;
      case RewardRarity.sp:
        return Colors.red.shade300;
    }
  }

  Color _getRarityBgColor(RewardRarity rarity) {
    switch (rarity) {
      case RewardRarity.r:
        return Colors.blue.shade50;
      case RewardRarity.sr:
        return Colors.purple.shade50;
      case RewardRarity.ssr:
        return Colors.orange.shade50;
      case RewardRarity.sp:
        return Colors.red.shade50;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 600;

    return BackgroundScaffold(
      backgroundImage: AppAssets.bgGiantLotusPond,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _buildBackButton(),
        title: Text(
          '每日签到',
          style: GoogleFonts.maShanZheng(
            color: AppColors.inkBlack,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(child: _buildMainContent(size, isSmall: isSmallScreen)),
    );
  }

  Widget _buildBackButton() {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.arrow_back, size: 20),
        color: AppColors.inkBlack,
        onPressed: () => Navigator.of(context).pop(),
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
      ),
    );
  }

  // --- Components ---

  Widget _buildMainContent(Size size, {required bool isSmall}) {
    // Dynamic layout calculations
    final double characterHeight = isSmall ? 350 : 500;
    final double contentTopOffset = isSmall ? 200 : 250;

    return Stack(
      fit: StackFit.expand,
      children: [
        // Character Image (Background Layer)
        Positioned(
          top: 0,
          right: 0,
          left: 0,
          child: Center(
            child: SizedBox(
              height: characterHeight,
              child: Image.asset(
                'assets/role/Nine-Tailed_Fox_3D.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),

        // Main Content Layer
        Positioned.fill(
          top: contentTopOffset,
          child: Align(
            alignment: Alignment.topCenter,
            child: Container(
              width: isSmall
                  ? double.infinity
                  : 600, // Max width for large screens
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              constraints: BoxConstraints(
                maxHeight:
                    size.height -
                    contentTopOffset -
                    20, // Leave some bottom padding
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.95),
                  ],
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(32),
                  bottom: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildStreakSection(),
                    const SizedBox(height: 16),
                    _buildRewardsGrid(isSmall),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStreakSection() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgPaper,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.woodDark.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.inkRed,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '1天',
                  style: GoogleFonts.notoSerifSc(
                    color: Colors.white,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '连续签到',
                style: GoogleFonts.maShanZheng(
                  fontSize: 18,
                  color: AppColors.inkBlack,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  // Bar Background
                  Container(
                    height: 8,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  // Progress
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      height: 8,
                      width: constraints.maxWidth * 0.14, // 1/7
                      decoration: BoxDecoration(
                        color: AppColors.inkRed,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  // Chests
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      const SizedBox(width: 10), // Offset
                      _buildStreakChest(3, false, '连续3天'),
                      _buildStreakChest(5, false, '连续5天'),
                      _buildStreakChest(7, false, '连续7天'),
                      const SizedBox(width: 10), // Offset
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStreakChest(int day, bool reached, String label) {
    return Column(
      children: [
        Image.asset(
          'assets/item/Chibi_treasure_chest.png',
          width: 40,
          height: 40,
          color: reached ? null : Colors.grey,
          colorBlendMode: reached ? null : BlendMode.saturation,
        ),
        Text(
          label,
          style: GoogleFonts.notoSerifSc(
            fontSize: 10,
            color: reached ? AppColors.inkBlack : Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildRewardsGrid(bool isSmall) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isSmall ? 3 : 5,
        childAspectRatio: 0.85,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        return _buildRewardItem(rewards[index], index);
      },
    );
  }

  Widget _buildRewardItem(DailyReward reward, int index) {
    final isClaimed = reward.status == RewardStatus.claimed;
    final isAvailable = reward.status == RewardStatus.available;
    final rarityColor = _getRarityColor(reward.rarity);
    final rarityBgColor = _getRarityBgColor(reward.rarity);

    return GestureDetector(
      onTap: isAvailable ? () => _claimReward(index) : null,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isClaimed ? Colors.grey[200] : rarityBgColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isAvailable
                    ? AppColors.inkRed
                    : rarityColor.withOpacity(0.5),
                width: isAvailable ? 2 : 1,
              ),
              boxShadow: isAvailable
                  ? [
                      BoxShadow(
                        color: AppColors.inkRed.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header (Icon + Rarity)
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 1,
                        ),
                        decoration: BoxDecoration(
                          color: rarityColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          reward.rarity.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (isAvailable && !isClaimed)
                        const Icon(
                          Icons.touch_app,
                          size: 12,
                          color: AppColors.inkRed,
                        ),
                    ],
                  ),
                ),

                // Image
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Image.asset(
                      reward.assetPath,
                      fit: BoxFit.contain,
                      color: isClaimed ? Colors.grey : null,
                      colorBlendMode: isClaimed ? BlendMode.saturation : null,
                    ),
                  ),
                ),

                // Footer (Count)
                Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.05),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(11),
                    ),
                  ),
                  child: Text(
                    'x${reward.count}',
                    textAlign: TextAlign.right,
                    style: GoogleFonts.notoSerifSc(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: isClaimed ? Colors.grey : AppColors.inkBlack,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Claimed Overlay
          if (isClaimed)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 32,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
