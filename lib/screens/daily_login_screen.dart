import 'package:flutter/material.dart';
import '../widgets/background_wrapper.dart';
import '../utils/daily_login_manager.dart';

class DailyReward {
  final int day;
  final String label;
  final String imagePath;
  final int gold;
  final Map<String, int>? items; // itemId -> count

  const DailyReward({
    required this.day,
    required this.label,
    required this.imagePath,
    required this.gold,
    this.items,
  });
}

const List<DailyReward> dailyRewards = [
  DailyReward(day: 1, label: "初入大荒", imagePath: "assets/item/item1.png", gold: 100),
  DailyReward(
    day: 2,
    label: "灵草补给",
    imagePath: "assets/item/item2.png",
    gold: 0,
    items: {'spirit_grass': 5},
  ),
  DailyReward(
    day: 3,
    label: "天水洗礼",
    imagePath: "assets/item/item3.png",
    gold: 50,
    items: {'aqua_drop': 2},
  ),
  DailyReward(
    day: 4,
    label: "精金锻造",
    imagePath: "assets/item/item4.png",
    gold: 150,
    items: {'iron_ore': 3},
  ),
  DailyReward(
    day: 5,
    label: "地火淬体",
    imagePath: "assets/item/item5.png",
    gold: 200,
    items: {'fire_lotus': 2},
  ),
  DailyReward(
    day: 6,
    label: "月华凝练",
    imagePath: "assets/item/item6.png",
    gold: 0,
    items: {'moon_stone': 2, 'crimson_crystal': 1},
  ),
  DailyReward(
    day: 7,
    label: "混沌赐福",
    imagePath: "assets/item/item7.png",
    gold: 500,
    items: {'void_dust': 1, 'dragon_scale': 1},
  ),
  DailyReward(
    day: 8,
    label: "轮回之赐",
    imagePath: "assets/item/item8.png",
    gold: 800,
    items: {'spirit_jade': 1},
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

class _DailyLoginScreenState extends State<DailyLoginScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.height < 700;

    return BackgroundWrapper(
      backgroundImage: 'assets/bg/Bg2.jpeg',
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Stack(
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  // If screen is very short, enable scrolling to prevent overflow
                  if (constraints.maxHeight < 500) {
                     return SingleChildScrollView(
                        child: Column(
                           children: [
                              SizedBox(
                                 height: 250, 
                                 child: _buildCharacterPanel(isSmallScreen)
                              ),
                              SizedBox(
                                 height: 400,
                                 child: _buildSignInList(isSmallScreen)
                              ),
                           ],
                        ),
                     );
                  }

                  // Normal layout
                  return Column(
                    children: [
                      // Top Side - Character Display
                      Expanded(
                        flex: 35,
                        child: _buildCharacterPanel(isSmallScreen),
                      ),

                      // Bottom Side - Sign In Grid
                      Expanded(
                        flex: 65,
                        child: _buildSignInList(isSmallScreen),
                      ),
                    ],
                  );
                }
              ),

              // Back Button
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 28),
                  onPressed: widget.onClose,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCharacterPanel(bool isSmallScreen) {
    return Stack(
      children: [
        // Character Image
        Positioned.fill(
          child: Image.asset(
            'assets/role/Role2.png', // Using Role2 as placeholder for Changxi
            fit: BoxFit.cover,
            alignment: Alignment.topCenter,
          ),
        ),
        
        // Character Info Overlay
        Positioned(
          left: 20,
          top: isSmallScreen ? 40 : 60,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SSR+ Label and Element
              Row(
                children: [
                  Text(
                    "SSR+",
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: isSmallScreen ? 24 : 32,
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.water_drop, color: Colors.blue, size: 24), // Element placeholder
                ],
              ),
              const SizedBox(height: 8),
              // Name and Role
              Row(
                children: [
                  Text(
                    "常羲",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 20 : 28,
                      fontWeight: FontWeight.bold,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      "辅助",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              // Stars
              Row(
                children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 18)),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSignInList(bool isSmallScreen) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "签到${DailyLoginManager.currentDay}天",
                  style: TextStyle(
                    color: Colors.amber,
                    fontSize: isSmallScreen ? 18 : 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  "送SSR+辅助异灵",
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Grid (Hui Shape)
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final availableWidth = constraints.maxWidth;
                final availableHeight = constraints.maxHeight;
                
                // Use the smaller dimension to ensure it fits, with a bit of margin
                // But don't let it be too small
                final size = (availableWidth < availableHeight ? availableWidth : availableHeight);
                
                return Center(
                  child: SizedBox(
                    width: size,
                    height: size,
                    child: GridView.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 6,
                      crossAxisSpacing: 6,
                      childAspectRatio: 1.0,
                      physics: const NeverScrollableScrollPhysics(),
                      children: _buildGridChildren(isSmallScreen),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildGridChildren(bool isSmallScreen) {
    // Mapping 3x3 grid to dailyRewards indices
    // 0 1 2
    // 7 C 3
    // 6 5 4
    final gridIndices = [0, 1, 2, 7, -1, 3, 6, 5, 4];
    
    return gridIndices.map((index) {
      if (index == -1) {
        return _buildCenterPanel(isSmallScreen);
      }
      
      final reward = dailyRewards[index];
      final day = index + 1;
      final isPast = day < DailyLoginManager.currentDay;
      final isToday = day == DailyLoginManager.currentDay;
      final isClaimed = isPast || (isToday && DailyLoginManager.isClaimedToday);

      return _buildGridItem(reward, isToday, isClaimed, isSmallScreen);
    }).toList();
  }
  
  Widget _buildCenterPanel(bool isSmallScreen) {
      if (!DailyLoginManager.isClaimedToday) {
         return GestureDetector(
            onTap: _handleClaim,
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                        BoxShadow(color: Colors.amber.withOpacity(0.5), blurRadius: 10, spreadRadius: 2)
                    ]
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        const Icon(Icons.touch_app, color: Colors.black, size: 32),
                        const SizedBox(height: 4),
                        const Text("领取", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16)),
                    ]
                ),
            ),
         );
      } else {
         return Container(
             decoration: BoxDecoration(
                 color: Colors.white10,
                 borderRadius: BorderRadius.circular(12),
                 border: Border.all(color: Colors.white24)
             ),
             child: const Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                     Icon(Icons.check_circle, color: Colors.green, size: 32),
                     SizedBox(height: 4),
                     Text("已领取", style: TextStyle(color: Colors.white70, fontSize: 14)),
                 ]
             ),
         );
      }
  }

  Widget _buildGridItem(DailyReward reward, bool isToday, bool isClaimed, bool isSmallScreen) {
    Color bgGradientStart = isToday ? Colors.amber.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.1);
    Color bgGradientEnd = isToday ? Colors.amber.withValues(alpha: 0.1) : Colors.transparent;
    Color borderColor = isToday ? Colors.amber : Colors.transparent;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [bgGradientStart, bgGradientEnd],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: borderColor, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Padding(
             padding: const EdgeInsets.all(4),
             child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    Text("第${reward.day}天", style: TextStyle(color: isToday ? Colors.amber : Colors.white70, fontSize: 12)),
                    Expanded(child: Image.asset(reward.imagePath, fit: BoxFit.contain)),
                    Text(
                        reward.gold > 0 ? "${reward.gold}" : (reward.items?.values.first.toString() ?? "1"),
                        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)
                    ),
                ],
             ),
          ),
          
          if (isClaimed)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Icon(Icons.check, color: Colors.green, size: 32),
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
