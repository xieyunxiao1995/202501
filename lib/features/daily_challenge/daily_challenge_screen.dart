import 'package:flutter/material.dart';

import '../../core/widgets/felt_scaffold.dart';
import '../../core/widgets/gold_panel.dart';
import '../home/home_controller.dart';
import '../solitaire/game_screen.dart';

class DailyChallengeScreen extends StatelessWidget {
  const DailyChallengeScreen({super.key, this.date});

  final DateTime? date;

  @override
  Widget build(BuildContext context) {
    final daily = DailyChallenge.forDate(date ?? DateTime.now());
    final dateLabel = _formatDailyDate(daily.date);
    final difficulty = '★' * daily.difficulty + '☆' * (3 - daily.difficulty);

    return FeltScaffold(
      accent: Color(daily.accentColor),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          _header(context),
          const SizedBox(height: 22),
          GoldPanel(
            color: Color(daily.accentColor).withValues(alpha: .92),
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
            child: Column(
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black.withValues(alpha: .18),
                    border: Border.all(
                      color: const Color(0xFFFFE18A).withValues(alpha: .7),
                    ),
                  ),
                  child: Icon(
                    daily.icon,
                    color: const Color(0xFFFFE18A),
                    size: 39,
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  'Today\'s Challenge',
                  style: TextStyle(
                    color: Color(0xFFFFE7A3),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.6,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  daily.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'serif',
                    fontWeight: FontWeight.bold,
                    fontSize: 29,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  dateLabel,
                  style: const TextStyle(
                    color: Color(0xFFFFF1C4),
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Divider(color: Color(0x66FFE7A3)),
                ),
                Text(
                  daily.subtitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFFE1E9D7),
                    fontSize: 14,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Difficulty $difficulty',
                  style: const TextStyle(
                    color: Color(0xFFFFD650),
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 54,
            child: FilledButton.icon(
              onPressed: () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => SolitaireGameScreen(
                    seed: daily.seed,
                    adventureTitle: daily.title,
                    isDaily: true,
                  ),
                ),
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text(
                'Play Now',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          GoldPanel(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
            child: Row(
              children: [
                const Icon(
                  Icons.wb_sunny_outlined,
                  color: Color(0xFFFFD44D),
                  size: 28,
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Text(
                    'A fresh personal challenge is waiting every day. Come back tomorrow for a new deal.',
                    style: TextStyle(
                      color: Color(0xFFD4E0C8),
                      fontSize: 12,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) => Row(
    children: [
      IconButton(
        onPressed: () => Navigator.pop(context),
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
      ),
      const Expanded(
        child: Text(
          'Daily Challenge',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      const SizedBox(width: 48),
    ],
  );
}

String _formatDailyDate(DateTime date) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}, ${date.year}';
}
