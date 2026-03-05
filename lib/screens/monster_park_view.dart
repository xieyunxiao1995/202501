import 'package:flutter/material.dart' hide Hero;
import 'dart:ui';
import 'dart:async';
import 'dart:math';
import '../models/models.dart';
import '../state/game_state.dart';
import '../widgets/game_background.dart';

/// 遊園地施設データモデル
class ParkFacility {
  final String id;
  final String name;
  final String desc;
  final IconData icon;
  final Color color;
  final String rewardType;
  final int baseReward;

  ParkFacility({
    required this.id,
    required this.name,
    required this.desc,
    required this.icon,
    required this.color,
    required this.rewardType,
    required this.baseReward,
  });
}

class MonsterParkView extends StatefulWidget {
  final GameState gameState;
  final VoidCallback onSave;

  const MonsterParkView({
    super.key,
    required this.gameState,
    required this.onSave,
  });

  @override
  State<MonsterParkView> createState() => _MonsterParkViewState();
}

class _MonsterParkViewState extends State<MonsterParkView>
    with TickerProviderStateMixin {
  final List<ParkFacility> _facilities = [
    ParkFacility(
      id: 'f1',
      name: 'スライムトランポリン',
      desc: '柔らかく弾力がある。英雄たちの大好物。大量の戦闘経験を獲得！',
      icon: Icons.sports_gymnastics_rounded,
      color: Colors.blueAccent,
      rewardType: '经验',
      baseReward: 1500,
    ),
    ParkFacility(
      id: 'f2',
      name: 'ミミックの迷路',
      desc: '幽闇で神秘的な迷宮。金币が散らばっている。噛まれないように！',
      icon: Icons.account_balance_wallet_rounded,
      color: Colors.amber,
      rewardType: '金币',
      baseReward: 800,
    ),
    ParkFacility(
      id: 'f3',
      name: '巨竜の観覧車',
      desc: '雲端から世界を俯瞰。高所は寒いが、レアな補給パックを獲得。',
      icon: Icons.attractions_rounded,
      color: Colors.purpleAccent,
      rewardType: '混合',
      baseReward: 1000,
    ),
  ];

  // プレイ中の施設状態を記録 { facilityId: {heroId, progress(0.0-1.0), timer} }
  final Map<String, Map<String, dynamic>> _activePlays = {};

  @override
  void dispose() {
    for (var play in _activePlays.values) {
      (play['timer'] as Timer?)?.cancel();
    }
    super.dispose();
  }

  void _openHeroSelector(ParkFacility facility) {
    if (_activePlays.containsKey(facility.id)) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('この施設は利用中です！')));
      return;
    }

    if (widget.gameState.inventory.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('英雄がいません。旅館で召喚しましょう！')));
      return;
    }

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => _buildHeroSelector(ctx, facility),
    );
  }

  Widget _buildHeroSelector(BuildContext ctx, ParkFacility facility) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: Color(0xff1a1c23),
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(color: Colors.black54, blurRadius: 20, spreadRadius: 5),
        ],
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 12, bottom: 8),
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '英雄を【${facility.name}】に派遣',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: widget.gameState.inventory.length,
              itemBuilder: (context, index) {
                final hero = widget.gameState.inventory[index];
                // 英雄が既に他の施設にいるかチェック
                final isBusy = _activePlays.values.any(
                  (p) => p['heroId'] == hero.uid,
                );
                return _buildHeroAvatar(hero, isBusy, () {
                  if (isBusy) return;
                  Navigator.pop(ctx);
                  _startPlay(facility, hero);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroAvatar(Hero hero, bool isBusy, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isBusy ? 0.4 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xff2a2d36),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isBusy ? Colors.grey : Colors.amber.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                hero.name.substring(0, 1),
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isBusy ? 'プレイ中' : 'Lv.${hero.level}',
                style: TextStyle(
                  fontSize: 10,
                  color: isBusy ? Colors.redAccent : Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startPlay(ParkFacility facility, Hero hero) {
    setState(() {
      _activePlays[facility.id] = {
        'heroId': hero.uid,
        'heroName': hero.name,
        'progress': 0.0,
      };
    });

    const totalDuration = 3000; // 3秒完成一次游玩
    const tick = 50;
    int elapsed = 0;

    Timer.periodic(const Duration(milliseconds: tick), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      elapsed += tick;
      setState(() {
        _activePlays[facility.id]!['progress'] = (elapsed / totalDuration)
            .clamp(0.0, 1.0);
      });

      if (elapsed >= totalDuration) {
        timer.cancel();
        _finishPlay(facility, hero);
      }
    });
  }

  void _finishPlay(ParkFacility facility, Hero hero) {
    // 随机浮动奖励
    final multiplier = 1.0 + (Random().nextDouble() * 0.5); // 1.0 ~ 1.5倍
    final rewardAmount = (facility.baseReward * multiplier).round();

    String rewardMsg = '';
    if (facility.rewardType == '金币') {
      widget.gameState.addGold(rewardAmount);
      rewardMsg = '$rewardAmount ゴールドを獲得！';
    } else if (facility.rewardType == '经验') {
      widget.gameState.addExp(rewardAmount);
      rewardMsg = '$rewardAmount 経験値を獲得！';
    } else {
      final gold = (rewardAmount * 0.4).round();
      final exp = (rewardAmount * 0.6).round();
      widget.gameState.addGold(gold);
      widget.gameState.addExp(exp);
      rewardMsg = '$gold ゴールドと$exp 経験値を獲得！';
    }

    setState(() {
      _activePlays.remove(facility.id);
    });

    widget.gameState.save();
    widget.onSave();

    // 弹窗提示
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xff2a170e),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: facility.color, width: 2),
        ),
        title: Row(
          children: [
            Icon(Icons.celebration, color: facility.color),
            const SizedBox(width: 8),
            const Text(
              'プレイ終了',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Text(
          '${hero.name} は【${facility.name}】で楽しく遊びました！\n\n$rewardMsg',
          style: const TextStyle(color: Colors.white70, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(
              '素敵！',
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: BackgroundUtil.getBgByScene('monster_park'),
      overlayOpacity: BackgroundUtil.getOverlayOpacityForScene('monster_park'),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: _facilities.length,
                    itemBuilder: (context, index) {
                      return _buildFacilityCard(_facilities[index]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Widget _buildBackground() {
    return Stack(
      children: [
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.purple.withValues(alpha: 0.3),
                  blurRadius: 100,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          bottom: -50,
          left: -50,
          child: Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.2),
                  blurRadius: 100,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          const Expanded(
            child: Text(
              '魔物遊園',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // 占位对称
        ],
      ),
    );
  }

  Widget _buildFacilityCard(ParkFacility facility) {
    final activeData = _activePlays[facility.id];
    final bool isPlaying = activeData != null;
    final double progress = activeData?['progress'] ?? 0.0;
    final String heroName = activeData?['heroName'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isPlaying ? facility.color : Colors.white10,
          width: isPlaying ? 2 : 1,
        ),
        boxShadow: isPlaying
            ? [
                BoxShadow(
                  color: facility.color.withValues(alpha: 0.3),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : [const BoxShadow(color: Colors.black26, blurRadius: 10)],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  facility.color.withValues(alpha: 0.2),
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: facility.color.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        facility.icon,
                        color: facility.color,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            facility.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '预期掉落: ${facility.rewardType}',
                            style: TextStyle(
                              fontSize: 12,
                              color: facility.color.withValues(alpha: 0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  facility.desc,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),

                if (isPlaying) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '[$heroName] が楽しんでプレイ中...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                      Text(
                        '${(progress * 100).toInt()}%',
                        style: TextStyle(
                          color: facility.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.white10,
                      valueColor: AlwaysStoppedAnimation<Color>(facility.color),
                    ),
                  ),
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () => _openHeroSelector(facility),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: facility.color.withValues(alpha: 0.8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '英雄を派遣',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
