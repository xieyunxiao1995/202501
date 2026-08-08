import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/storage/game_storage.dart';
import '../../core/widgets/felt_scaffold.dart';
import '../../core/widgets/gold_panel.dart';
import '../solitaire/game_screen.dart';
import 'creative_mode.dart';
import 'creative_progress.dart';

class CreativeDetailScreen extends StatefulWidget {
  const CreativeDetailScreen({
    super.key,
    required this.mode,
    this.initialProgress,
  });

  final CreativeModeDefinition mode;
  final CreativeProgress? initialProgress;

  @override
  State<CreativeDetailScreen> createState() => _CreativeDetailScreenState();
}

class _CreativeDetailScreenState extends State<CreativeDetailScreen> {
  late CreativeProgress _progress;
  TimeTrialLimit _selectedTimeLimit = TimeTrialLimit.unlimited;

  CreativeModeDefinition get _mode => widget.mode;

  int get _seed => 5521 + _mode.type.index * 997;

  @override
  void initState() {
    super.initState();
    _progress = widget.initialProgress ?? CreativeProgress.initial();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await GameStorage(
      await SharedPreferences.getInstance(),
    ).loadCreativeProgress();
    if (mounted) setState(() => _progress = progress);
  }

  String _time(int? seconds) => seconds == null
      ? '--:--'
      : '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';

  String _moves(int? moves) => moves == null ? '--' : '$moves';

  Future<void> _start() async {
    final storage = GameStorage(await SharedPreferences.getInstance());
    final progress = (await storage.loadCreativeProgress()).recordPlay(
      _mode.type,
    );
    await storage.saveCreativeProgress(progress);
    if (!mounted) return;
    setState(() => _progress = progress);
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) => SolitaireGameScreen(
          seed: _seed,
          adventureTitle: _mode.title,
          creativeMode: _mode.type,
          timeTrialLimitSeconds: _mode.type == CreativeModeType.timeTrial
              ? _selectedTimeLimit.seconds
              : null,
        ),
      ),
    );
    await _loadProgress();
  }

  @override
  Widget build(BuildContext context) => FeltScaffold(
    accent: _mode.accentColor,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 8, 14, 2),
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Text(
                  _mode.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Icon(_mode.icon, color: const Color(0xFFFFD34A)),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GoldPanel(
                  color: Colors.black26,
                  child: Column(
                    children: [
                      Icon(
                        _mode.icon,
                        color: const Color(0xFFFFDD65),
                        size: 58,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _mode.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          height: 1.35,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Difficulty',
                        style: TextStyle(
                          color: Color(0xFFFFE7A3),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        _mode.difficultyLabel,
                        style: const TextStyle(
                          color: Color(0xFFFFE28A),
                          fontSize: 17,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _modePreview(),
                const SizedBox(height: 14),
                GoldPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Your Record',
                        style: TextStyle(
                          color: Color(0xFFFFE7A3),
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      _row('Wins', '${_progress.winsFor(_mode.type)}'),
                      _row(
                        'Best Time',
                        _time(_progress.bestTimeFor(_mode.type)),
                      ),
                      _row(
                        'Best Moves',
                        _moves(_progress.bestMovesFor(_mode.type)),
                      ),
                      _row(
                        'Best Score',
                        _progress.highestScoreFor(_mode.type) == 0
                            ? '--'
                            : '${_progress.highestScoreFor(_mode.type)}',
                      ),
                      _row('Stars', '${_progress.bestStarsFor(_mode.type)}/3'),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Goal',
                  style: TextStyle(
                    color: Color(0xFFFFE7A3),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                GoldPanel(
                  child: Text(
                    _mode.goal,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      height: 1.35,
                    ),
                  ),
                ),
                if (_mode.type == CreativeModeType.timeTrial) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'Challenge',
                    style: TextStyle(
                      color: Color(0xFFFFE7A3),
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 7),
                  GoldPanel(
                    padding: const EdgeInsets.all(10),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final limit in TimeTrialLimit.values)
                          ChoiceChip(
                            label: Text(limit.label),
                            selected: _selectedTimeLimit == limit,
                            onSelected: (_) =>
                                setState(() => _selectedTimeLimit = limit),
                            selectedColor: const Color(0xFFE4B52C),
                            labelStyle: TextStyle(
                              color: _selectedTimeLimit == limit
                                  ? const Color(0xFF18331E)
                                  : Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: 16),
                const Text(
                  'Rules',
                  style: TextStyle(
                    color: Color(0xFFFFE7A3),
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 7),
                GoldPanel(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      for (final rule in _mode.rules) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '• ',
                              style: TextStyle(color: Color(0xFFFFD454)),
                            ),
                            Expanded(
                              child: Text(
                                rule,
                                style: const TextStyle(
                                  color: Colors.white,
                                  height: 1.35,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (rule != _mode.rules.last) const SizedBox(height: 8),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: SizedBox(width: double.infinity, child: _startAction()),
        ),
      ],
    ),
  );

  Widget _startAction() {
    if (_mode.isPlayable) {
      return FilledButton.icon(
        key: const ValueKey('creative-detail-start'),
        onPressed: _start,
        icon: const Icon(Icons.play_arrow_rounded),
        label: const Text('Start'),
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFFE4B52C),
          foregroundColor: const Color(0xFF18331E),
          padding: const EdgeInsets.symmetric(vertical: 14),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800),
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black26,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        _mode.actionLabel,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _modePreview() {
    switch (_mode.type) {
      case CreativeModeType.treasureHunt:
        return GoldPanel(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              for (var index = 0; index < 5; index++)
                const Text('🎁', style: TextStyle(fontSize: 25)),
            ],
          ),
        );
      case CreativeModeType.timeTrial:
        return GoldPanel(
          child: const Row(
            children: [
              Icon(Icons.bolt_rounded, color: Color(0xFFFFD454)),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Three time limits. One best time to beat.',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      case CreativeModeType.oneDrawSprint:
        return GoldPanel(
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Only ONE pass through deck',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Draw one card. Plan carefully. No recycle.',
                style: TextStyle(color: Color(0xFFD5DECA)),
              ),
            ],
          ),
        );
      case CreativeModeType.jokerRescue:
        return GoldPanel(
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text('🃏', style: TextStyle(fontSize: 34)),
              Text('🔒', style: TextStyle(fontSize: 25)),
              Text(
                'Moves: 0 / 5',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        );
      case CreativeModeType.shadowSolitaire:
        return GoldPanel(
          child: const Column(
            children: [
              Text(
                'Remember hidden cards',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 5),
              Text(
                'Five seconds to memorize the opening.',
                style: TextStyle(color: Color(0xFFD5DECA)),
              ),
            ],
          ),
        );
      case CreativeModeType.chainDeck:
        return const SizedBox.shrink();
    }
  }

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
}
