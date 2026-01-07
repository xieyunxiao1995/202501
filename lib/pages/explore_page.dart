import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../core/app_colors.dart';
import '../models/beast_model.dart';
import '../models/log_model.dart';
import '../widgets/common_widgets.dart';

import '../models/tribe_model.dart';

class ExplorePage extends StatefulWidget {
  final Function(int, int) onResourceGain;
  final Function(Beast) onBeastFound;
  final TribeData tribeData;

  const ExplorePage({
    super.key,
    required this.onResourceGain,
    required this.onBeastFound,
    required this.tribeData,
  });

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage>
    with SingleTickerProviderStateMixin {
  final List<Log> _logs = [];
  final List<Widget> _floatingTexts = [];
  Timer? _idleTimer;
  late AnimationController _pulseController;

  // 新增：主动探索冷却
  bool _canRoam = true;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    // 初始化日志
    _addLog("探索雷泽：发现一只受伤的 [百年·旋龟]。", "event");
    _addLog("获得：灵气 +120", "gain");

    _idleTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!mounted) return;
      _tickIdle();
    });
  }

  void _addLog(String text, String type) {
    setState(() {
      _logs.insert(
        0,
        Log(
          id:
              DateTime.now().millisecondsSinceEpoch.toString() +
              Random().nextInt(100).toString(),
          text: text,
          type: type,
          timestamp: DateTime.now(),
        ),
      );
      if (_logs.length > 50) _logs.removeLast();
    });
  }

  void _tickIdle() {
    final random = Random();
    // 基础图腾等级加成
    final totemBonus = 1 + (widget.tribeData.level * 0.1);
    // 赐福灵气加成
    final spiritBonus = widget.tribeData.spiritIncomeBonus;

    final spiritGain = (10 + random.nextInt(15) * totemBonus * spiritBonus)
        .toInt();
    final fleshGain = random.nextDouble() < (0.2 * totemBonus) ? 1 : 0;

    widget.onResourceGain(spiritGain, fleshGain);
    _addFloatingText("+$spiritGain 灵气");
    if (fleshGain > 0) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _addFloatingText("+1 血食");
      });
    }

    // 只有小概率才记录日志，避免刷屏
    if (random.nextDouble() < 0.2) {
      _addLog("挂机收益：获得 $spiritGain 灵气${fleshGain > 0 ? "，1 血食" : ""}", "gain");
    }
  }

  // 主动探索逻辑
  void _manualRoam() {
    if (!_canRoam) return;

    setState(() => _canRoam = false);

    // 冷却 1秒
    Future.delayed(const Duration(milliseconds: 1000), () {
      if (mounted) setState(() => _canRoam = true);
    });

    final random = Random();
    final roll = random.nextDouble();

    if (roll < 0.1) {
      // 奇遇：异兽
      final newBeast = Beast.generateRandom();
      widget.onBeastFound(newBeast);
      _addLog("神游太虚：偶然发现了一只 [${newBeast.tier}·${newBeast.name}]！", "event");
      _showEventDialog(
        "捕获异兽",
        "你发现了一只落单的 ${newBeast.name}，将其收入囊中！",
        newBeast.tier,
      );
    } else if (roll < 0.4) {
      // 奇遇：大量资源
      final spirit = 100 + random.nextInt(200);
      widget.onResourceGain(spirit, 0);
      _addLog("神游太虚：发现上古遗留的灵石碎片，灵气 +$spirit", "gain");
      _addFloatingText("+$spirit 灵气 (暴击)");
    } else if (roll < 0.6) {
      // 奇遇：危险
      _addLog("神游太虚：误入凶兽领地，仓皇逃窜，精神受到冲击...", "danger");
    } else {
      // 普通
      final spirit = 30 + random.nextInt(30);
      widget.onResourceGain(spirit, 0);
      _addLog("神游太虚：在荒原游荡，吸纳了些许天地元气。", "gain");
      _addFloatingText("+$spirit 灵气");
    }
  }

  void _showEventDialog(String title, String desc, String tier) {
    Color color = AppColors.secondary;
    if (tier == "千年") color = AppColors.primary;
    if (tier == "万年") color = AppColors.danger;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: color),
        ),
        title: Text(
          title,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
        content: Text(desc, style: const TextStyle(color: AppColors.textMain)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("收下"),
          ),
        ],
      ),
    );
  }

  void _addFloatingText(String text) {
    final id = DateTime.now().millisecondsSinceEpoch;
    final random = Random();
    final x = MediaQuery.of(context).size.width / 2 + random.nextInt(100) - 50;
    final y =
        MediaQuery.of(context).size.height / 2 - 100 + random.nextInt(40) - 20;

    setState(() {
      _floatingTexts.add(
        FloatingGainText(
          key: ValueKey(id),
          text: text,
          position: Offset(x, y),
          onComplete: () {
            setState(() {
              _floatingTexts.removeWhere(
                (w) => (w.key as ValueKey).value == id,
              );
            });
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _idleTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenHeight = constraints.maxHeight;
        final isSmallScreen = screenHeight < 600;

        return Stack(
          children: [
            // Background - Made transparent to show AppBackground
            const Positioned.fill(child: ScanningGrid()),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      AppColors.bg.withOpacity(0.5),
                      AppColors.bg.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: isSmallScreen ? 8 : 16),
                _buildApocalypseTimer(),
                SizedBox(height: isSmallScreen ? 10 : 20),
                _buildRegionHeader(),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: isSmallScreen ? 180 : double.infinity,
                      ),
                      child: _buildPulsingOrb(),
                    ),
                  ),
                ),
                _buildLogContainer(isSmallScreen),
              ],
            ),
            // 主动探索按钮
            Positioned(
              right: 16,
              bottom: isSmallScreen ? 190 : 250, // Adjusted for small screen
              child: _buildRoamButton(isSmallScreen),
            ),
            ..._floatingTexts,
          ],
        );
      },
    );
  }

  Widget _buildRoamButton(bool isSmallScreen) {
    final size = isSmallScreen ? 60.0 : 70.0;
    return GestureDetector(
      onTap: _canRoam ? _manualRoam : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _canRoam ? AppColors.primary : Colors.grey.withOpacity(0.2),
          boxShadow: _canRoam
              ? [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
              : [],
          border: Border.all(color: Colors.white24, width: 2),
        ),
        child: Center(
          child: _canRoam
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.directions_walk,
                      color: Colors.white,
                      size: isSmallScreen ? 20 : 24,
                    ),
                    Text(
                      "神游",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 9 : 10,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                )
              : const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.white54,
                    strokeWidth: 2,
                  ),
                ),
        ),
      ),
    );
  }

  // ... (保留原有的 _buildApocalypseTimer, _buildPulsingOrb 等 UI 方法，不做修改) ...
  // 为节省篇幅，假设原有的辅助UI方法依然存在，未删除

  Widget _buildApocalypseTimer() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF4C0519).withOpacity(0.3), // rose-950/30
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.danger.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "APOCALYPSE TIMER",
                  style: TextStyle(
                    fontSize: 9,
                    color: AppColors.danger.withOpacity(0.8),
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                const Row(
                  children: [
                    Icon(Icons.dangerous, color: AppColors.danger, size: 16),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        "天道大劫 · 倒计时",
                        style: TextStyle(
                          color: Color(0xFFFFE4E6), // rose-100
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          fontFamily: 'serif',
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: "92",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.danger,
                    fontFamily: 'monospace',
                  ),
                ),
                TextSpan(
                  text: " 年",
                  style: TextStyle(fontSize: 10, color: AppColors.textSub),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPulsingOrb() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer pulsing rings
            Container(
              width: 192 + (_pulseController.value * 48),
              height: 192 + (_pulseController.value * 48),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.secondary.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            Container(
              width: 128 + (_pulseController.value * 32),
              height: 128 + (_pulseController.value * 32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.secondary.withOpacity(0.2),
                  width: 2,
                ),
              ),
            ),
            // Main orb
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.secondary.withOpacity(0.4),
                    AppColors.secondary.withOpacity(0.1),
                  ],
                ),
                border: Border.all(
                  color: AppColors.secondary.withOpacity(0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  "🧘",
                  style: TextStyle(
                    fontSize: 48,
                    shadows: [
                      Shadow(color: AppColors.secondary, blurRadius: 10),
                    ],
                  ),
                ),
              ),
            ),
            // Floating text
            Positioned(
              top: -30,
              child: AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: _pulseController.value > 0.5 ? 1.0 : 0.5,
                child: Text(
                  "+12 灵气/s",
                  style: TextStyle(
                    color: AppColors.secondary.withOpacity(0.8),
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRegionHeader() {
    return Column(
      children: [
        const Text(
          "CURRENT REGION",
          style: TextStyle(
            letterSpacing: 2,
            fontSize: 9,
            color: AppColors.textSub,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [Color(0xFFFEF3C7), AppColors.primary],
          ).createShader(bounds),
          child: const Text(
            "雷泽 · 荒原",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'serif',
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (i) {
            return Container(
              width: 24,
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: i < 3 ? AppColors.secondary : Colors.white10,
                borderRadius: BorderRadius.circular(1),
                boxShadow: i < 3
                    ? [
                        BoxShadow(
                          color: AppColors.secondary.withOpacity(0.5),
                          blurRadius: 4,
                        ),
                      ]
                    : null,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildLogContainer(bool isSmallScreen) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          height: isSmallScreen ? 180 : 260,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.4),
            border: Border(
              top: BorderSide(color: AppColors.secondary.withOpacity(0.3)),
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.secondary,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          "SYSTEM LOG",
                          style: TextStyle(
                            fontSize: 10,
                            letterSpacing: 2,
                            color: AppColors.textSub,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: const Duration(milliseconds: 1000),
                      builder: (context, val, child) {
                        return Opacity(
                          opacity: val,
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      },
                      onEnd: () {},
                    ),
                  ],
                ),
              ),
              const Divider(height: 1, color: Colors.white10),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(16),
                  itemCount: _logs.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (ctx, idx) {
                    final log = _logs[idx];
                    Color color = AppColors.textMain;
                    IconData icon = Icons.info_outline;
                    if (log.type == 'gain') {
                      color = AppColors.secondary;
                      icon = Icons.add_circle_outline;
                    }
                    if (log.type == 'danger') {
                      color = AppColors.danger;
                      icon = Icons.warning_amber_rounded;
                    }
                    if (log.type == 'event') {
                      color = AppColors.primary;
                      icon = Icons.auto_awesome;
                    }

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(icon, size: 14, color: color.withOpacity(0.7)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: color,
                                fontSize: 12,
                                height: 1.4,
                              ),
                              children: [
                                TextSpan(
                                  text:
                                      "[${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}] ",
                                  style: const TextStyle(
                                    color: AppColors.textSub,
                                    fontSize: 10,
                                  ),
                                ),
                                TextSpan(text: log.text),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
