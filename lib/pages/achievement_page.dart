import 'package:flutter/material.dart';
import '../models/achievement_model.dart';
import '../core/app_colors.dart';
import '../widgets/common_widgets.dart';

class AchievementPage extends StatefulWidget {
  final AchievementStats stats;
  final Function(int) onClaimReward;
  final Function(String) onClaimAchievement;

  const AchievementPage({
    super.key,
    required this.stats,
    required this.onClaimReward,
    required this.onClaimAchievement,
  });

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.height < 600;
    final achievements = AchievementManager.getAllAchievements();
    final currentStats = widget.stats.toMap();

    // 统计数据
    int totalUnlocked = 0;
    int claimableCount = 0;
    for (var a in achievements) {
      final progress = AchievementManager.getProgress(a, currentStats);
      final unlocked = a.isUnlocked(progress);
      if (unlocked) {
        totalUnlocked++;
        if (!widget.stats.claimedAchievements.contains(a.id)) {
          claimableCount++;
        }
      }
    }

    final progressRatio = totalUnlocked / achievements.length;

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            _buildSliverAppBar(
              totalUnlocked,
              achievements.length,
              progressRatio,
              claimableCount,
              achievements,
              currentStats,
              isSmallScreen,
            ),
            SliverToBoxAdapter(child: _buildTabBar()),
            SliverFillRemaining(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAchievementsList(
                    achievements,
                    currentStats,
                    'all',
                    isSmallScreen,
                  ),
                  _buildAchievementsList(
                    achievements,
                    currentStats,
                    'unlocked',
                    isSmallScreen,
                  ),
                  _buildAchievementsList(
                    achievements,
                    currentStats,
                    'locked',
                    isSmallScreen,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(
    int unlocked,
    int total,
    double ratio,
    int claimableCount,
    List<Achievement> achievements,
    Map<String, int> statsMap,
    bool isSmallScreen,
  ) {
    return SliverAppBar(
      expandedHeight: isSmallScreen ? 160 : 200,
      pinned: true,
      backgroundColor: AppColors.bg,
      elevation: 0,
      centerTitle: true,
      title: Text(
        '成就名录',
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
          child: Stack(
            children: [
              Positioned(
                right: -20,
                top: -20,
                child: Icon(
                  Icons.emoji_events_outlined,
                  size: isSmallScreen ? 120 : 180,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(
                  24,
                  isSmallScreen ? 60 : 100,
                  24,
                  20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$unlocked',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isSmallScreen ? 28 : 36,
                            fontWeight: FontWeight.bold,
                            height: 1,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '/ $total',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: isSmallScreen ? 14 : 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '达成率 ${(ratio * 100).toInt()}%',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: isSmallScreen ? 12 : 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: ratio,
                        backgroundColor: Colors.white.withValues(alpha: 0.05),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.primary,
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.bg,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TabBar(
        controller: _tabController,
        dividerColor: Colors.transparent,
        indicatorSize: TabBarIndicatorSize.label,
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: AppColors.primary.withValues(alpha: 0.1),
        ),
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSub.withValues(alpha: 0.5),
        labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
        ),
        tabs: const [
          Tab(text: '全部'),
          Tab(text: '已达成'),
          Tab(text: '进行中'),
        ],
      ),
    );
  }

  Widget _buildAchievementsList(
    List<Achievement> achievements,
    Map<String, int> stats,
    String filter,
    bool isSmallScreen,
  ) {
    // 排序逻辑：可领取 > 未达成(按进度) > 已领取
    List<Achievement> sortedList = List.from(achievements);
    sortedList.sort((a, b) {
      final progA = AchievementManager.getProgress(a, stats);
      final progB = AchievementManager.getProgress(b, stats);
      final unlockedA = a.isUnlocked(progA);
      final unlockedB = b.isUnlocked(progB);
      final claimedA = widget.stats.claimedAchievements.contains(a.id);
      final claimedB = widget.stats.claimedAchievements.contains(b.id);

      // 1. 可领取优先 (已达成且未领取)
      bool canClaimA = unlockedA && !claimedA;
      bool canClaimB = unlockedB && !claimedB;
      if (canClaimA != canClaimB) return canClaimA ? -1 : 1;

      // 2. 未达成次之 (按进度百分比排序)
      if (!unlockedA && !unlockedB) {
        double ratioA = progA / a.requirement;
        double ratioB = progB / b.requirement;
        return ratioB.compareTo(ratioA);
      }
      if (unlockedA != unlockedB) {
        return unlockedA ? 1 : -1; // 未达成的排在已达成(但已领取)的前面
      }

      // 3. 最后是已达成的
      if (claimedA != claimedB) return claimedA ? 1 : -1;

      return 0;
    });

    List<Achievement> filteredAchievements;
    if (filter == 'unlocked') {
      filteredAchievements = sortedList
          .where((a) => a.isUnlocked(AchievementManager.getProgress(a, stats)))
          .toList();
    } else if (filter == 'locked') {
      filteredAchievements = sortedList
          .where((a) => !a.isUnlocked(AchievementManager.getProgress(a, stats)))
          .toList();
    } else {
      filteredAchievements = sortedList;
    }

    if (filteredAchievements.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.auto_fix_off,
              size: isSmallScreen ? 48 : 64,
              color: AppColors.textSub.withValues(alpha: 0.3),
            ),
            SizedBox(height: isSmallScreen ? 12 : 16),
            Text(
              filter == 'locked' ? '所有成就都已达成！' : '暂无相关成就',
              style: TextStyle(
                color: AppColors.textSub,
                fontSize: isSmallScreen ? 14 : 16,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.fromLTRB(
        16,
        isSmallScreen ? 8 : 16,
        16,
        isSmallScreen ? 80 : 100,
      ),
      itemCount: filteredAchievements.length,
      itemBuilder: (context, index) {
        final achievement = filteredAchievements[index];
        final progress = AchievementManager.getProgress(achievement, stats);
        final isUnlocked = achievement.isUnlocked(progress);
        final isClaimed = widget.stats.claimedAchievements.contains(
          achievement.id,
        );

        return _buildAchievementCard(
          achievement,
          progress,
          isUnlocked,
          isClaimed,
          isSmallScreen,
        );
      },
    );
  }

  Widget _buildAchievementCard(
    Achievement achievement,
    int progress,
    bool isUnlocked,
    bool isClaimed,
    bool isSmallScreen,
  ) {
    final progressPercent = (progress / achievement.requirement).clamp(
      0.0,
      1.0,
    );
    final canClaim = isUnlocked && !isClaimed;

    Widget cardContent = Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: canClaim
              ? AppColors.primary.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            if (isClaimed)
              Positioned(
                right: -5,
                bottom: -5,
                child: Icon(
                  Icons.check_circle,
                  size: isSmallScreen ? 40 : 60,
                  color: AppColors.primary.withValues(alpha: 0.05),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildAchievementIcon(achievement, isUnlocked, isSmallScreen),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              achievement.name,
                              style: TextStyle(
                                color: isUnlocked
                                    ? Colors.white
                                    : AppColors.textSub,
                                fontSize: isSmallScreen ? 14 : 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              achievement.description,
                              style: TextStyle(
                                color: AppColors.textSub.withValues(alpha: 0.6),
                                fontSize: isSmallScreen ? 11 : 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  isClaimed
                                      ? '已达成'
                                      : '进度: ${(progressPercent * 100).toInt()}%',
                                  style: TextStyle(
                                    color: isUnlocked
                                        ? AppColors.primary
                                        : AppColors.textSub,
                                    fontSize: isSmallScreen ? 10 : 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  '$progress / ${achievement.requirement}',
                                  style: TextStyle(
                                    color: AppColors.textSub.withValues(
                                      alpha: 0.5,
                                    ),
                                    fontSize: isSmallScreen ? 10 : 11,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progressPercent,
                                backgroundColor: Colors.white.withValues(
                                  alpha: 0.03,
                                ),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  isUnlocked
                                      ? AppColors.primary
                                      : Colors.grey.shade800,
                                ),
                                minHeight: isSmallScreen ? 3 : 4,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),
                      _buildActionButton(
                        achievement,
                        canClaim,
                        isClaimed,
                        isSmallScreen,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    if (canClaim) {
      return _PulseEffect(child: cardContent);
    }
    return cardContent;
  }

  Widget _buildAchievementIcon(
    Achievement achievement,
    bool isUnlocked,
    bool isSmallScreen,
  ) {
    return Container(
      width: isSmallScreen ? 44 : 52,
      height: isSmallScreen ? 44 : 52,
      decoration: BoxDecoration(
        color: isUnlocked
            ? AppColors.primary.withValues(alpha: 0.1)
            : Colors.white.withValues(alpha: 0.03),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isUnlocked
              ? AppColors.primary.withValues(alpha: 0.2)
              : Colors.transparent,
        ),
      ),
      child: Center(
        child: Text(
          achievement.icon,
          style: TextStyle(
            fontSize: isSmallScreen ? 20 : 24,
            color: isUnlocked ? Colors.white : Colors.white24,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
    Achievement achievement,
    bool canClaim,
    bool isClaimed,
    bool isSmallScreen,
  ) {
    if (isClaimed) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.02),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          '已领取',
          style: TextStyle(
            color: Colors.white24,
            fontSize: isSmallScreen ? 10 : 11,
          ),
        ),
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: canClaim
            ? () {
                widget.onClaimAchievement(achievement.id);
                widget.onClaimReward(achievement.reward);
                setState(() {}); // 立即刷新UI
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('领取成功！获得 ${achievement.reward} 灵气'),
                    backgroundColor: Colors.green,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            : null,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 10 : 12,
            vertical: isSmallScreen ? 6 : 8,
          ),
          decoration: BoxDecoration(
            color: canClaim
                ? AppColors.primary
                : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(8),
            boxShadow: canClaim
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.card_giftcard,
                size: isSmallScreen ? 12 : 14,
                color: canClaim ? Colors.black : Colors.white24,
              ),
              const SizedBox(width: 4),
              Text(
                '${achievement.reward}',
                style: TextStyle(
                  color: canClaim ? Colors.black : Colors.white24,
                  fontSize: isSmallScreen ? 11 : 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 呼吸灯脉冲效果
class _PulseEffect extends StatefulWidget {
  final Widget child;
  const _PulseEffect({required this.child});

  @override
  State<_PulseEffect> createState() => _PulseEffectState();
}

class _PulseEffectState extends State<_PulseEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(scale: _animation, child: widget.child);
  }
}
