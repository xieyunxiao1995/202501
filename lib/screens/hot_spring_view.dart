import 'package:flutter/material.dart' hide Hero;
import 'dart:ui';
import 'dart:async';
import 'dart:math';
import '../models/models.dart';
import '../state/game_state.dart';
import '../widgets/game_background.dart';

class HotSpringView extends StatefulWidget {
  final GameState gameState;
  final VoidCallback onSave;

  const HotSpringView({
    super.key,
    required this.gameState,
    required this.onSave,
  });

  @override
  State<HotSpringView> createState() => _HotSpringViewState();
}

class _HotSpringViewState extends State<HotSpringView>
    with TickerProviderStateMixin {
  // 温泉スロット数を定義
  static const int maxSlots = 5;

  // 记录槽位状态：key为槽位索引(0~4)
  final Map<int, Map<String, dynamic>> _activeSlots = {};

  @override
  void dispose() {
    for (var slot in _activeSlots.values) {
      (slot['timer'] as Timer?)?.cancel();
    }
    super.dispose();
  }

  void _openHeroSelector(int slotIndex) {
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
      builder: (ctx) => _buildHeroSelector(ctx, slotIndex),
    );
  }

  Widget _buildHeroSelector(BuildContext ctx, int slotIndex) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: Color(0xff0d1b2a),
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
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              '入浴する英雄を選択',
              style: TextStyle(
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
                // 英雄が既に温泉にいるかチェック
                final isSoaking = _activeSlots.values.any(
                  (s) => (s['hero'] as Hero).uid == hero.uid,
                );
                return _buildHeroAvatar(hero, isSoaking, () {
                  if (isSoaking) return;
                  Navigator.pop(ctx);
                  _startSoaking(slotIndex, hero);
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroAvatar(Hero hero, bool isSoaking, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: isSoaking ? 0.4 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueGrey.shade800, Colors.blueGrey.shade900],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSoaking
                  ? Colors.transparent
                  : Colors.cyan.withValues(alpha: 0.5),
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
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                isSoaking ? '入浴中' : 'Lv.${hero.level}',
                style: TextStyle(
                  fontSize: 10,
                  color: isSoaking ? Colors.cyanAccent : Colors.white70,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _startSoaking(int slotIndex, Hero hero) {
    setState(() {
      _activeSlots[slotIndex] = {'hero': hero, 'progress': 0.0, 'done': false};
    });

    const totalDuration = 6000; // 泡澡时长：6秒 (演示用)
    const tick = 50;
    int elapsed = 0;

    Timer.periodic(const Duration(milliseconds: tick), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      elapsed += tick;
      setState(() {
        _activeSlots[slotIndex]!['progress'] = (elapsed / totalDuration).clamp(
          0.0,
          1.0,
        );
      });

      if (elapsed >= totalDuration) {
        timer.cancel();
        setState(() {
          _activeSlots[slotIndex]!['done'] = true;
        });
      }
    });

    // 保存Timer以便组件销毁时可以清理
    _activeSlots[slotIndex]!['timer'] = Timer(
      const Duration(seconds: 0),
      () {},
    );
  }

  void _claimReward(int slotIndex) {
    final slotData = _activeSlots[slotIndex];
    if (slotData == null || !slotData['done']) return;

    final Hero hero = slotData['hero'];
    // 報酬計算：英雄レベル×50 経験値 + 200 基礎経験値
    final int expReward = (hero.level * 50) + 200;

    widget.gameState.addExp(expReward);

    setState(() {
      _activeSlots.remove(slotIndex);
    });

    widget.gameState.save();
    widget.onSave();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.cyan.shade800,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Row(
          children: [
            const Icon(Icons.auto_awesome, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              '${hero.name} はお風呂を堪能しました。$expReward の経験値を獲得！',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameBackground(
      backgroundImage: BackgroundUtil.getBgByScene('hot_spring'),
      overlayOpacity: BackgroundUtil.getOverlayOpacityForScene('hot_spring'),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            // 動的バブル/スチーム背景
            const SteamBackground(),

          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 20),
                const Text(
                  '英雄を温泉に入れて、リラックスして経験値を獲得',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
                const Spacer(),
                _buildHotSpringPool(),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ],
      ),
    ),
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
              '温泉疗愈',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w900,
                color: Colors.cyanAccent,
                letterSpacing: 2,
                shadows: [Shadow(color: Colors.cyan, blurRadius: 10)],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48), // 位置対称
        ],
      ),
    );
  }

  Widget _buildHotSpringPool() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: Colors.cyan.withValues(alpha: 0.3), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.cyan.withValues(alpha: 0.15),
            blurRadius: 40,
            spreadRadius: 10,
          ),
          const BoxShadow(
            color: Color(0xff0d1b2a), // 内部水体色
            blurRadius: 20,
            spreadRadius: -10,
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.cyan.withValues(alpha: 0.2),
            Colors.blue.withValues(alpha: 0.05),
          ],
        ),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 20,
        runSpacing: 30,
        children: List.generate(maxSlots, (index) => _buildPoolSlot(index)),
      ),
    );
  }

  Widget _buildPoolSlot(int index) {
    final slotData = _activeSlots[index];
    final bool isEmpty = slotData == null;

    return GestureDetector(
      onTap: () {
        if (isEmpty) {
          _openHeroSelector(index);
        } else if (slotData['done']) {
          _claimReward(index);
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: 80,
        height: 100,
        decoration: BoxDecoration(
          color: isEmpty
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.cyan.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isEmpty
                ? Colors.white.withValues(alpha: 0.2)
                : (slotData['done'] ? Colors.greenAccent : Colors.cyanAccent),
            width: 2,
            style: isEmpty ? BorderStyle.solid : BorderStyle.solid,
          ),
          boxShadow: !isEmpty && slotData['done']
              ? [const BoxShadow(color: Colors.greenAccent, blurRadius: 10)]
              : [],
        ),
        child: isEmpty ? _buildEmptySlot() : _buildFilledSlot(slotData),
      ),
    );
  }

  Widget _buildEmptySlot() {
    return const Center(
      child: Icon(Icons.add_rounded, color: Colors.white38, size: 36),
    );
  }

  Widget _buildFilledSlot(Map<String, dynamic> data) {
    final Hero hero = data['hero'];
    final double progress = data['progress'];
    final bool done = data['done'];

    return Stack(
      alignment: Alignment.center,
      children: [
        // 英雄識別
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              hero.name.substring(0, 1),
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w900,
                color: done
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: 8),
            if (!done)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.black45,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.cyanAccent,
                    ),
                  ),
                ),
              )
            else
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'クリックして受取',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        // 水紋シェーダーを模擬 (入浴効果)
        if (!done)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(18),
                ),
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.cyan.withValues(alpha: 0.6),
                    Colors.cyan.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// 温泉背景バブル/スチームパーティクルエフェクト
class SteamBackground extends StatefulWidget {
  const SteamBackground({super.key});

  @override
  State<SteamBackground> createState() => _SteamBackgroundState();
}

class _SteamBackgroundState extends State<SteamBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: SteamPainter(_controller.value),
          size: Size.infinite,
        );
      },
    );
  }
}

class SteamPainter extends CustomPainter {
  final double progress;
  SteamPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    // 複数の疑似ランダムバブルを生成 (固定パラメータベース)
    for (int i = 0; i < 20; i++) {
      // 固定数値を使用して毎回再描画時の軌跡を一致させる
      double startX = (size.width / 20) * i + (sin(i) * 20);
      double speedOffset = (i % 5) * 0.2;
      double currentProgress = (progress + speedOffset) % 1.0;

      double y = size.height - (size.height * currentProgress * 1.5);
      double x = startX + sin(currentProgress * pi * 4 + i) * 30; // 左右漂浮
      double radius = 5.0 + (i % 15);

      // 上に行くほど透明に
      paint.color = Colors.cyanAccent.withValues(
        alpha: (0.15 * (1 - currentProgress)).clamp(0.0, 1.0),
      );

      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(SteamPainter oldDelegate) => true;
}
