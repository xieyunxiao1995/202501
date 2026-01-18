import 'package:flutter/material.dart';
import '../utils/daily_login_manager.dart';

class DailyReward {
  final int day;
  final String label;
  final String icon;
  final int gold;
  final Map<String, int>? items; // itemId -> count

  const DailyReward({
    required this.day,
    required this.label,
    required this.icon,
    required this.gold,
    this.items,
  });
}

const List<DailyReward> dailyRewards = [
  DailyReward(day: 1, label: "初入大荒", icon: "💰", gold: 100),
  DailyReward(
    day: 2,
    label: "灵草补给",
    icon: "🌿",
    gold: 0,
    items: {'spirit_grass': 5},
  ),
  DailyReward(
    day: 3,
    label: "天水洗礼",
    icon: "💧",
    gold: 50,
    items: {'aqua_drop': 2},
  ),
  DailyReward(
    day: 4,
    label: "精金锻造",
    icon: "🪨",
    gold: 150,
    items: {'iron_ore': 3},
  ),
  DailyReward(
    day: 5,
    label: "地火淬体",
    icon: "🌺",
    gold: 200,
    items: {'fire_lotus': 2},
  ),
  DailyReward(
    day: 6,
    label: "月华凝练",
    icon: "🌙",
    gold: 0,
    items: {'moon_stone': 2, 'crimson_crystal': 1},
  ),
  DailyReward(
    day: 7,
    label: "混沌赐福",
    icon: "✨",
    gold: 500,
    items: {'void_dust': 1, 'dragon_scale': 1},
  ),
];

class DailyLoginScreen extends StatefulWidget {
  final VoidCallback onClose;
  final Function(int gold, Map<String, int> items) onClaim;

  const DailyLoginScreen({
    super.key,
    required this.onClose,
    required this.onClaim,
  });

  @override
  State<DailyLoginScreen> createState() => _DailyLoginScreenState();
}

class _DailyLoginScreenState extends State<DailyLoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(
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
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return Scaffold(
      backgroundColor: const Color(0xFF111827),
      appBar: AppBar(
        title: const Text(
          "七日签到",
          style: TextStyle(
            color: Colors.amber,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.amber),
          onPressed: widget.onClose,
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF111827),
              const Color(0xFF1F2937),
            ],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12 : 24,
                    vertical: isSmallScreen ? 8 : 24,
                  ),
                  child: Column(
                    children: [
                      _buildHeaderInfo(isSmallScreen),
                      const SizedBox(height: 24),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isSmallScreen ? 3 : 4,
                          crossAxisSpacing: isSmallScreen ? 8 : 12,
                          mainAxisSpacing: isSmallScreen ? 8 : 12,
                          childAspectRatio: isSmallScreen ? 0.85 : 0.75,
                        ),
                        itemCount: 7,
                        itemBuilder: (context, index) {
                          final reward = dailyRewards[index];
                          final day = index + 1;
                          final isPast = day < DailyLoginManager.currentDay;
                          final isToday = day == DailyLoginManager.currentDay;
                          final isClaimed =
                              isPast || (isToday && DailyLoginManager.isClaimedToday);

                          return isToday && !isClaimed
                              ? ScaleTransition(
                                  scale: _scaleAnimation,
                                  child: _buildDayCard(reward, isToday, isClaimed, isSmallScreen),
                                )
                              : _buildDayCard(reward, isToday, isClaimed, isSmallScreen);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Claim Button at the bottom
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(isSmallScreen ? 16.0 : 24.0),
                child: SizedBox(
                  width: double.infinity,
                  height: isSmallScreen ? 48 : 56,
                  child: ElevatedButton(
                    onPressed: (!DailyLoginManager.isClaimedToday)
                        ? _handleClaim
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      disabledBackgroundColor: Colors.grey[800],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                      elevation: DailyLoginManager.isClaimedToday ? 0 : 8,
                      shadowColor: Colors.amber.withOpacity(0.5),
                    ),
                    child: Text(
                      DailyLoginManager.isClaimedToday ? "今日已领" : "领取今日奖励",
                      style: TextStyle(
                        color: DailyLoginManager.isClaimedToday
                            ? Colors.white38
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: isSmallScreen ? 16 : 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.amber.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.auto_awesome,
              color: Colors.amber,
              size: isSmallScreen ? 24 : 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "大荒气运：第七日可得混沌赐福",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "连续签到即可领取珍稀材料与灵石",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayCard(DailyReward reward, bool isToday, bool isClaimed, bool isSmallScreen) {
    Color borderColor = Colors.white10;
    Color bgColor = Colors.black26;
    Color iconColor = Colors.white70;

    if (isToday) {
      borderColor = Colors.amber;
      bgColor = Colors.amber.withOpacity(0.15);
      iconColor = Colors.white;
    } else if (isClaimed) {
      borderColor = Colors.green.withOpacity(0.5);
      bgColor = Colors.green.withOpacity(0.1);
      iconColor = Colors.white38;
    }

    if (reward.day == 7 && !isClaimed) {
      borderColor = Colors.purpleAccent;
      bgColor = Colors.purple.withOpacity(0.2);
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor, width: isToday ? 2 : 1),
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: Colors.amber.withOpacity(0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "第${reward.day}天",
                  style: TextStyle(
                    color: isToday
                        ? Colors.amber
                        : (isClaimed ? Colors.green : Colors.white54),
                    fontSize: isSmallScreen ? 10 : 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  reward.icon,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 28 : 36,
                    color: iconColor,
                    shadows: isToday
                        ? [const Shadow(color: Colors.amber, blurRadius: 10)]
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                if (reward.gold > 0)
                  Text(
                    "${reward.gold} 灵石",
                    style: TextStyle(
                      color: Colors.amberAccent,
                      fontSize: isSmallScreen ? 10 : 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (reward.items != null)
                  Text(
                    "${reward.items!.length}种材料",
                    style: TextStyle(
                      color: Colors.white70, 
                      fontSize: isSmallScreen ? 9 : 11
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),

          if (isClaimed)
            Container(
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  child: const Icon(Icons.check, color: Colors.green, size: 24),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _handleClaim() async {
    final reward = dailyRewards[DailyLoginManager.currentDay - 1];

    await DailyLoginManager.claimReward();
    widget.onClaim(reward.gold, reward.items ?? {});
    if (mounted) setState(() {});
  }
}
