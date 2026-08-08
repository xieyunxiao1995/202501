import 'package:flutter/material.dart';

import 'settings_info_screen.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) => const SettingsInfoScreen(
    title: 'About Us',
    icon: Icons.info_outline_rounded,
    sections: [
      InfoSection(
        title: 'Solitaire Journey',
        body:
            'Solitaire Journey is a calm, focused card game built for short breaks and thoughtful play. Follow the adventure, complete levels, and enjoy a collection of creative ways to play Solitaire.',
      ),
      InfoSection(
        title: 'Our Approach',
        body:
            'We keep the experience simple, welcoming, and easy to understand. Every screen is designed to help you get back to the table quickly, whether you want a classic deal or a new challenge.',
      ),
      InfoSection(
        title: 'A Free Experience',
        body:
            'Solitaire Journey is designed as a free, local-first experience. Your progress, themes, and level records stay on your device so the game can remain personal and easy to pick up anytime.',
      ),
    ],
  );
}
