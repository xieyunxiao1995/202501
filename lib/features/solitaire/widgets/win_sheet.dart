import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/widgets/gold_panel.dart';
import '../../creative/creative_mode.dart';

class WinSheet extends StatelessWidget {
  const WinSheet({
    super.key,
    required this.elapsedSeconds,
    required this.moves,
    required this.stars,
    required this.onNext,
    required this.onMap,
    this.onReplay,
    this.onHome,
    this.creativeMode,
    this.creativeTreasuresFound,
    this.creativeTotalTreasures,
    this.creativeJokerRescued = false,
    this.creativeIsNewBest = false,
  });

  final int elapsedSeconds;
  final int moves;
  final int stars;
  final VoidCallback onNext;
  final VoidCallback onMap;
  final VoidCallback? onReplay;
  final VoidCallback? onHome;
  final CreativeModeType? creativeMode;
  final int? creativeTreasuresFound;
  final int? creativeTotalTreasures;
  final bool creativeJokerRescued;
  final bool creativeIsNewBest;

  bool get isCreative => creativeMode != null;

  String get timeLabel =>
      '${(elapsedSeconds ~/ 60).toString().padLeft(2, '0')}:${(elapsedSeconds % 60).toString().padLeft(2, '0')}';

  String get creativeTitle {
    final mode = creativeMode;
    if (mode == null) return '';
    return switch (mode) {
      CreativeModeType.treasureHunt => 'Treasure Hunt Complete!',
      CreativeModeType.timeTrial => 'Speed Result',
      CreativeModeType.jokerRescue =>
        creativeJokerRescued ? 'Joker Rescued!' : 'Joker Rescue Complete!',
      CreativeModeType.shadowSolitaire => 'Shadow Cards Complete!',
      CreativeModeType.oneDrawSprint => 'One Draw Sprint Complete!',
      CreativeModeType.chainDeck => 'Creative Result',
    };
  }

  String get speedEvaluation => switch (stars) {
    3 => 'Amazing!',
    2 => 'Great pace!',
    _ => 'Keep practicing!',
  };

  @override
  Widget build(BuildContext context) => SafeArea(
    top: false,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: GoldPanel(
          color: const Color(0xFF163D26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _CelebrationHeader(
                title: 'Victory',
                subtitle: isCreative ? creativeTitle : null,
              ),
              if (isCreative)
                Text(
                  CreativeModeCatalog.forType(creativeMode!).title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              if (creativeMode == CreativeModeType.timeTrial)
                Text(
                  speedEvaluation,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              const SizedBox(height: 8),
              _row('Time', timeLabel),
              _row('Moves', '$moves'),
              _row('Stars', '★' * stars + '☆' * (3 - stars)),
              if (creativeMode == CreativeModeType.timeTrial)
                Text(
                  '$elapsedSeconds seconds',
                  style: const TextStyle(color: Color(0xFFC9D8B7)),
                ),
              if (creativeTreasuresFound != null)
                Column(
                  children: [
                    _row(
                      'Treasure',
                      '$creativeTreasuresFound/$creativeTotalTreasures',
                    ),
                    Text(
                      '🎁 $creativeTreasuresFound / $creativeTotalTreasures',
                      style: const TextStyle(color: Color(0xFFFFE7A3)),
                    ),
                  ],
                ),
              if (creativeJokerRescued)
                const Text(
                  '🃏 Joker Rescued!',
                  style: TextStyle(
                    color: Color(0xFFFFD64E),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              if (creativeIsNewBest)
                const Padding(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    'New Best!',
                    style: TextStyle(
                      color: Color(0xFFFFD64E),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth < 360 ? 2 : 3;
                  final buttonWidth =
                      (constraints.maxWidth - (columns - 1) * 8) / columns;
                  return Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      SizedBox(
                        width: buttonWidth,
                        child: OutlinedButton.icon(
                          onPressed: onReplay ?? onNext,
                          icon: const Icon(Icons.replay_rounded, size: 18),
                          label: const Text('Replay'),
                          style: _compactButtonStyle(),
                        ),
                      ),
                      SizedBox(
                        width: buttonWidth,
                        child: FilledButton.icon(
                          onPressed: onNext,
                          icon: const Icon(
                            Icons.arrow_forward_rounded,
                            size: 18,
                          ),
                          label: const Text('Next Level'),
                          style: _compactButtonStyle(
                            backgroundColor: const Color(0xFFFFD34F),
                            foregroundColor: const Color(0xFF553915),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: buttonWidth,
                        child: OutlinedButton.icon(
                          onPressed: onHome ?? onMap,
                          icon: const Icon(Icons.home_rounded, size: 18),
                          label: const Text('Home'),
                          style: _compactButtonStyle(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 5),
    child: Row(
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFC9D8B7))),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );

  ButtonStyle _compactButtonStyle({
    Color? backgroundColor,
    Color? foregroundColor,
  }) => OutlinedButton.styleFrom(
    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
    minimumSize: Size.zero,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    backgroundColor: backgroundColor,
    foregroundColor: foregroundColor,
    textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
  );
}

class _CelebrationHeader extends StatefulWidget {
  const _CelebrationHeader({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  State<_CelebrationHeader> createState() => _CelebrationHeaderState();
}

class _CelebrationHeaderState extends State<_CelebrationHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1250),
  )..forward();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SizedBox(
        height: 100,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            final progress = Curves.easeOutCubic.transform(_controller.value);
            return Stack(
              alignment: Alignment.center,
              children: [
                for (var index = 0; index < 5; index++)
                  _FlyingCard(index: index, progress: progress),
                Transform.scale(
                  scale: 1 + math.sin(progress * math.pi) * .06,
                  child: const Icon(
                    Icons.workspace_premium_rounded,
                    color: Color(0xFFFFD64E),
                    size: 54,
                  ),
                ),
              ],
            );
          },
        ),
      ),
      Text(
        widget.title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFFFFE7A3),
          fontFamily: 'serif',
          fontSize: 30,
          fontWeight: FontWeight.bold,
        ),
      ),
      if (widget.subtitle != null)
        Text(
          widget.subtitle!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
    ],
  );
}

class _FlyingCard extends StatelessWidget {
  const _FlyingCard({required this.index, required this.progress});

  final int index;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final startX = (index - 2) * 35.0;
    final startY = 42.0 + (index.isOdd ? 8 : 0);
    final endX = (index - 2) * 11.0;
    final endY = -5.0;
    return Opacity(
      opacity: (1 - progress).clamp(.12, .86),
      child: Transform.translate(
        offset: Offset(
          startX + (endX - startX) * progress,
          startY + (endY - startY) * progress,
        ),
        child: Transform.rotate(
          angle: (index - 2) * .18 * (1 - progress),
          child: Container(
            width: 20,
            height: 29,
            decoration: BoxDecoration(
              color: const Color(0xFFF7E5A1),
              borderRadius: BorderRadius.circular(3),
              border: Border.all(color: const Color(0xFFE0A72F)),
              boxShadow: const [
                BoxShadow(color: Colors.black38, blurRadius: 4),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Color(0xFFB47B1C),
              size: 10,
            ),
          ),
        ),
      ),
    );
  }
}
