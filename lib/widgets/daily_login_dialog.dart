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
    icon: "�",
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

class DailyLoginDialog extends StatefulWidget {
  final VoidCallback onClose;
  final Function(int gold, Map<String, int> items) onClaim;

  const DailyLoginDialog({
    super.key,
    required this.onClose,
    required this.onClaim,
  });

  @override
  State<DailyLoginDialog> createState() => _DailyLoginDialogState();
}

class _DailyLoginDialogState extends State<DailyLoginDialog>
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
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: const Color(0xFF1F2937),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.amber.withOpacity(0.5), width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.1),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Color(0xFF111827),
                borderRadius: BorderRadius.vertical(top: Radius.circular(14)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today, color: Colors.amber),
                  const SizedBox(width: 8),
                  const Text(
                    "七日签到",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: widget.onClose,
                  ),
                ],
              ),
            ),

            // Grid
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.75,
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
                          child: _buildDayCard(reward, isToday, isClaimed),
                        )
                      : _buildDayCard(reward, isToday, isClaimed);
                },
              ),
            ),

            // Claim Button
            Padding(
              padding: const EdgeInsets.only(bottom: 24.0, top: 8.0),
              child: SizedBox(
                width: 200,
                height: 48,
                child: ElevatedButton(
                  onPressed: (!DailyLoginManager.isClaimedToday)
                      ? _handleClaim
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    disabledBackgroundColor: Colors.grey[800],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: DailyLoginManager.isClaimedToday ? 0 : 8,
                    shadowColor: Colors.amber.withOpacity(0.5),
                  ),
                  child: Text(
                    DailyLoginManager.isClaimedToday ? "今日已领" : "领取奖励",
                    style: TextStyle(
                      color: DailyLoginManager.isClaimedToday
                          ? Colors.white38
                          : Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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

  Widget _buildDayCard(DailyReward reward, bool isToday, bool isClaimed) {
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

    // Special styling for day 7
    if (reward.day == 7 && !isClaimed) {
      borderColor = Colors.purpleAccent;
      bgColor = Colors.purple.withOpacity(0.2);
    }

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
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
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "第${reward.day}天",
                  style: TextStyle(
                    color: isToday
                        ? Colors.amber
                        : (isClaimed ? Colors.green : Colors.white54),
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  reward.icon,
                  style: TextStyle(
                    fontSize: 22,
                    color: iconColor,
                    shadows: isToday
                        ? [const Shadow(color: Colors.amber, blurRadius: 10)]
                        : null,
                  ),
                ),
                const SizedBox(height: 2),
                if (reward.gold > 0)
                  Text(
                    "${reward.gold}",
                    style: const TextStyle(
                      color: Colors.amberAccent,
                      fontSize: 9,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                if (reward.items != null)
                  Text(
                    "${reward.items!.length}x 材料",
                    style: const TextStyle(color: Colors.white70, fontSize: 8),
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
                borderRadius: BorderRadius.circular(6),
              ),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.green, width: 2),
                  ),
                  child: const Icon(Icons.check, color: Colors.green, size: 20),
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
    setState(() {});
  }
}
