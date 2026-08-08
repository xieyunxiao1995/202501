import 'package:flutter/material.dart';

import 'settings_info_screen.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({super.key});

  @override
  Widget build(BuildContext context) => const SettingsInfoScreen(
    title: 'Feedback & Suggestions',
    icon: Icons.feedback_outlined,
    sections: [
      InfoSection(
        title: 'What to Share',
        body:
            'Tell us what you enjoy, what feels confusing, and which parts of Solitaire Journey you would like to improve. Ideas for levels, themes, accessibility, and Creative Modes are welcome.',
      ),
      InfoSection(
        title: 'Helpful Details',
        body:
            'When describing an issue, include what you were doing, what you expected to happen, and what happened instead. Mentioning the screen or level helps make feedback easier to understand.',
      ),
      InfoSection(
        title: 'Thank You',
        body:
            'Thoughtful feedback helps shape a clearer and more enjoyable Solitaire experience. Thank you for taking the time to help us improve the game.',
      ),
    ],
  );
}
