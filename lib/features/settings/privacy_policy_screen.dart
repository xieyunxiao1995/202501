import 'package:flutter/material.dart';

import 'settings_info_screen.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) => const SettingsInfoScreen(
    title: 'Privacy Policy',
    icon: Icons.privacy_tip_outlined,
    sections: [
      InfoSection(
        title: 'Local Data',
        body:
            'Solitaire Journey stores gameplay progress, level stars, personal records, selected themes, and basic preferences locally on your device so the app can remember your journey.',
      ),
      InfoSection(
        title: 'What We Do Not Require',
        body:
            'The game does not require an account, a name, a phone number, or a social profile to play. There are no online leaderboards or social sharing features in the current experience.',
      ),
      InfoSection(
        title: 'Your Control',
        body:
            'You can remove locally stored game data through your device settings by clearing the app data or uninstalling the app. This may also remove your saved progress.',
      ),
      InfoSection(
        title: 'Changes to This Policy',
        body:
            'If the way the app handles local data changes, this page will be updated so the information remains clear and easy to understand.',
      ),
    ],
  );
}
