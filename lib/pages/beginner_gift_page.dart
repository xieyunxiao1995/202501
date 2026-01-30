import 'package:flutter/material.dart';
import '../core/app_colors.dart';

class BeginnerGiftPage extends StatefulWidget {
  const BeginnerGiftPage({super.key});

  @override
  State<BeginnerGiftPage> createState() => _BeginnerGiftPageState();
}

class _BeginnerGiftPageState extends State<BeginnerGiftPage> {
  bool _isClaimedDay1 = false;

  void _claimDay1Reward() {
    if (_isClaimedDay1) return;

    setState(() {
      _isClaimedDay1 = true;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2D1B10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.amber, width: 2),
        ),
        title: const Text(
          '领取成功',
          style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '恭喜获得核心SSR+异灵：黄帝',
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Image.asset('assets/role/Role22.png', height: 150),
          ],
        ),
        actions: [
          Center(
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              child: const Text('确定'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. 全屏背景图/渐变
          _buildBackground(),

          // 2. 角色展示 (黄帝)
          _buildCharacterDisplay(context),

          // 3. 顶部标题区 (精简后)
          _buildTopTitleArea(context),

          // 4. 中间宣传文字
          _buildPromoText(),

          // 5. 底部奖励卡片区
          _buildBottomRewards(),

          // 6. 返回按钮
          Positioned(
            top: 50,
            left: 10,
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 28,
              ),
              style: IconButton.styleFrom(backgroundColor: Colors.black26),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackground() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF6B4226), // 暖色调背景
            Color(0xFF2D1B10),
            Color(0xFF000000),
          ],
        ),
      ),
      child: Stack(
        children: [
          // 增加一些光效纹理
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Opacity(
              opacity: 0.3,
              child: Container(
                height: 500,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Colors.orange.withOpacity(0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterDisplay(BuildContext context) {
    return Positioned(
      top: 80,
      left: 0,
      right: 0,
      bottom: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // 背后龙的轮廓或光环
          Opacity(
            opacity: 0.5,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.amber.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withOpacity(0.2),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          // 黄帝立绘
          Image.asset('assets/role/Role22.png', fit: BoxFit.contain),
        ],
      ),
    );
  }

  Widget _buildTopTitleArea(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.withOpacity(0),
                    Colors.orange.withOpacity(0.5),
                    Colors.orange.withOpacity(0),
                  ],
                ),
              ),
              child: const Text(
                '新手盛典',
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 4,
                  shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoText() {
    return Positioned(
      bottom: 300,
      left: 0,
      right: 0,
      child: Column(
        children: [
          const Text(
            '送核心SSR+黄帝',
            style: TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              shadows: [
                Shadow(color: Colors.orange, blurRadius: 10),
                Shadow(color: Colors.black, offset: Offset(2, 2)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.orange.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
            child: const Text(
              '境界直升炼气后期40阶',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '超强伤害爆发，夺命追击斩杀',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 16,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomRewards() {
    return Positioned(
      bottom: 70,
      left: 10,
      right: 10,
      child: Container(
        height: 200,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            _buildRewardCard(
              '登录1天',
              [
                {
                  'icon': 'assets/role/Role22.png',
                  'name': '黄帝',
                  'num': '1',
                  'isSSR': true,
                },
                {'icon': 'assets/item/item1.jpeg', 'num': '10万'},
                {'icon': 'assets/item/item2.jpeg', 'num': '30万'},
                {'icon': 'assets/item/item3.jpeg', 'num': '120'},
              ],
              isHot: true,
              canClaim: !_isClaimedDay1,
              isClaimed: _isClaimedDay1,
              onTap: _claimDay1Reward,
            ),
            const SizedBox(width: 8),
            _buildRewardCard('登录2天', [
              {'icon': 'assets/item/item4.jpeg', 'num': '1', 'isBox': true},
              {'icon': 'assets/item/item5.jpeg', 'num': '10'},
              {'icon': 'assets/item/item6.jpeg', 'num': '300'},
            ]),
            const SizedBox(width: 8),
            _buildRewardCard('登录3天', [
              {'icon': 'assets/item/item7.jpeg', 'num': '2', 'isCard': true},
              {'icon': 'assets/item/item2.jpeg', 'num': '3'},
              {'icon': 'assets/item/item3.jpeg', 'num': '500'},
            ]),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardCard(
    String title,
    List<Map<String, dynamic>> items, {
    bool isHot = false,
    bool canClaim = false,
    bool isClaimed = false,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: canClaim ? Border.all(color: Colors.amber, width: 2) : null,
          ),
          child: Column(
            children: [
              // 卡片标题
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 2),
                decoration: BoxDecoration(
                  color: isHot ? Colors.orange : Colors.orange.shade200,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // 奖品网格
              Expanded(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: GridView.builder(
                        padding: EdgeInsets.zero,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 2,
                          mainAxisSpacing: 2,
                        ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Image.asset(
                                      item['icon'],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                if (item['isSSR'] == true)
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 2,
                                      ),
                                      color: Colors.red,
                                      child: const Text(
                                        'SSR+',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: Text(
                                    item['num'],
                                    style: const TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    // 领取状态遮罩
                    if (isClaimed)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(12),
                          ),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check_circle_outline,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                    // 可领取动画提示 (简单模拟)
                    if (canClaim)
                      Positioned(
                        bottom: 4,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          color: Colors.orange.withOpacity(0.8),
                          child: const Text(
                            '点击领取',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
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
}
