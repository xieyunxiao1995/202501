import 'package:flutter/material.dart';

import 'settings_info_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) => const SettingsInfoScreen(
    title: 'Help',
    icon: Icons.help_outline_rounded,
    sections: [
      InfoSection(
        title: 'How to Play',
        body:
            'Move face-up cards between tableau piles in descending order while alternating red and black suits. Build each foundation from Ace to King. Tap the stock to draw a card and use the hint button when you need a suggestion.',
      ),
      InfoSection(
        title: 'Journey Levels',
        body:
            'Complete the current level to unlock the next one. Finish faster and use fewer moves to earn more stars. Open a level card to review your record before starting again.',
      ),
      InfoSection(
        title: 'Creative Modes',
        body:
            'Creative Modes add small twists to classic Solitaire. Each mode explains its goal before you start and records its own wins, best time, moves, and stars.',
      ),
      InfoSection(
        title: 'Themes and Progress',
        body:
            'Open Themes to choose a table style and background. Your selected theme and local progress are saved automatically on this device.',
      ),
      InfoSection(
        title: 'Troubleshooting',
        body:
            'If a saved game does not restore correctly, start a new deal from the game screen. If the app still behaves unexpectedly, restart it or clear its local data from your device settings.',
      ),
    ],
  );
}
