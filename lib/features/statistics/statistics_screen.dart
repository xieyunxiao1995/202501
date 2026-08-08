import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/storage/game_storage.dart';
import '../../core/widgets/felt_scaffold.dart';
import '../../core/widgets/gold_panel.dart';
import '../creative/creative_mode.dart';
import '../creative/creative_progress.dart';
import '../home/home_controller.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});
  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  PlayerProgress _progress = PlayerProgress.initial();
  CreativeProgress _creativeProgress = CreativeProgress.initial();
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final storage = GameStorage(await SharedPreferences.getInstance());
    final p = await storage.loadProgress();
    final creative = await storage.loadCreativeProgress();
    if (mounted) {
      setState(() {
        _progress = p;
        _creativeProgress = creative;
      });
    }
  }

  String _time(int? seconds) => seconds == null
      ? '--:--'
      : '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  @override
  Widget build(BuildContext context) {
    final s = _progress.statistics;
    final hasCreativeWins = CreativeModeCatalog.visible.any(
      (mode) => _creativeProgress.winsFor(mode.type) > 0,
    );
    final isEmpty =
        s.gamesPlayed == 0 &&
        s.totalWins == 0 &&
        s.totalMoves == 0 &&
        !hasCreativeWins;
    return FeltScaffold(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _header(context, 'My Journey'),
          const SizedBox(height: 18),
          if (isEmpty) ...[
            GoldPanel(
              color: const Color(0xFF214B2C).withValues(alpha: .92),
              child: Column(
                children: [
                  const Icon(
                    Icons.explore_rounded,
                    color: Color(0xFFFFD34F),
                    size: 42,
                  ),
                  const SizedBox(height: 9),
                  const Text(
                    'Your journey begins here.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFFFE7A3),
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Play your first game!',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Color(0xFFE7EAD5)),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(
                      context,
                    ).popUntil((route) => route.isFirst),
                    icon: const Icon(Icons.play_arrow_rounded),
                    label: const Text('Play your first game!'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
          ],
          GoldPanel(
            child: Column(
              children: [
                _row('Games Played', '${s.gamesPlayed}'),
                _row('Wins', '${s.totalWins}'),
                _row('Win Rate', '${(_progress.winRate * 100).round()}%'),
                _row('Fastest Time', _time(s.fastestWinSeconds)),
                _row('Total Moves', '${s.totalMoves}'),
              ],
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Creative Journey',
            style: TextStyle(
              color: Color(0xFFFFE7A3),
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 9),
          GoldPanel(
            child: Column(
              children: [
                for (final mode in CreativeModeCatalog.visible)
                  _creativeRow(mode),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 12),
    child: Row(
      children: [
        Text(label, style: const TextStyle(color: Color(0xFFD5DECA))),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );

  Widget _creativeRow(CreativeModeDefinition mode) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            mode.title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Wins ${_creativeProgress.winsFor(mode.type)}',
              style: const TextStyle(color: Color(0xFFD5DECA)),
            ),
            Text(
              'Best ${_time(_creativeProgress.bestTimeFor(mode.type))}',
              style: const TextStyle(color: Color(0xFFD5DECA)),
            ),
            Text(
              'Moves ${_creativeProgress.bestMovesFor(mode.type) ?? '--'}',
              style: const TextStyle(color: Color(0xFFD5DECA)),
            ),
            Text(
              'Score ${_creativeProgress.highestScoreFor(mode.type)}',
              style: const TextStyle(color: Color(0xFFD5DECA)),
            ),
            Text(
              'Stars ${_creativeProgress.bestStarsFor(mode.type)}/3',
              style: const TextStyle(color: Color(0xFFD5DECA)),
            ),
          ],
        ),
      ],
    ),
  );
}

Widget _header(BuildContext context, String title) => Row(
  children: [
    IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
    ),
    Expanded(
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
    const SizedBox(width: 48),
  ],
);
