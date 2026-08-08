import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/storage/game_storage.dart';
import '../../core/widgets/felt_scaffold.dart';
import '../../core/widgets/gold_panel.dart';
import '../creative/creative_mode.dart';
import '../creative/creative_progress.dart';
import '../home/home_controller.dart';

class AchievementScreen extends StatefulWidget {
  const AchievementScreen({super.key});
  @override
  State<AchievementScreen> createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
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

  @override
  Widget build(BuildContext context) {
    final s = _progress.statistics;
    final entries = [
      (
        'First Victory',
        'Win your first game',
        s.totalWins >= 1,
        Icons.emoji_events_rounded,
      ),
      (
        'Solitaire Master',
        'Win 50 games',
        s.totalWins >= 50,
        Icons.workspace_premium_rounded,
      ),
      (
        'Speed Demon',
        'Finish a game in under 5 minutes',
        (s.fastestWinSeconds ?? 999999) <= 300,
        Icons.bolt_rounded,
      ),
      (
        'Perfect Completion',
        'Earn three stars on 10 levels',
        _progress.completedStars.values.where((stars) => stars == 3).length >=
            10,
        Icons.stars_rounded,
      ),
      (
        'Treasure Hunter',
        'Find 50 treasures',
        _creativeProgress.treasuresFoundTotal >= 50,
        Icons.inventory_2_rounded,
      ),
      (
        'Speed Runner',
        'Finish Time Trial under 2 minutes',
        (_creativeProgress.bestTimeFor(CreativeModeType.timeTrial) ?? 999999) <=
            120,
        Icons.timer_rounded,
      ),
      (
        'Memory Master',
        'Complete Shadow Cards',
        _creativeProgress.winsFor(CreativeModeType.shadowSolitaire) > 0,
        Icons.style_rounded,
      ),
    ];
    return FeltScaffold(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _header(context, 'Achievements'),
          const SizedBox(height: 14),
          for (final e in entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GoldPanel(
                child: ListTile(
                  leading: Icon(
                    e.$4,
                    size: 35,
                    color: e.$3 ? const Color(0xFFFFD44D) : Colors.white30,
                  ),
                  title: Text(
                    e.$1,
                    style: TextStyle(
                      color: e.$3 ? Colors.white : Colors.white54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    e.$2,
                    style: const TextStyle(color: Color(0xFFC8D3BD)),
                  ),
                  trailing: Icon(
                    e.$3
                        ? Icons.check_circle_rounded
                        : Icons.lock_outline_rounded,
                    color: e.$3 ? const Color(0xFF8FC44D) : Colors.white30,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
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
