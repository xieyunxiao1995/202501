import 'package:flutter/material.dart';

import 'settings_info_screen.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) => const SettingsInfoScreen(
    title: 'User Agreement',
    icon: Icons.handshake_outlined,
    sections: [
      InfoSection(
        title: 'Acceptance',
        body:
            'By using Solitaire Journey, you agree to use the app for personal entertainment and to follow the rules described on this page. If you do not agree, please stop using the app.',
      ),
      InfoSection(
        title: 'Using Solitaire Journey',
        body:
            'You may play the available Solitaire deals, explore Creative Modes, and use the included themes on your device. Please do not attempt to disrupt the app, its data, or another person\'s use of the game.',
      ),
      InfoSection(
        title: 'Progress and Themes',
        body:
            'Level progress, stars, records, and selected themes are stored locally. Clearing app data or uninstalling the app may remove that information.',
      ),
      InfoSection(
        title: 'Updates',
        body:
            'The app may be updated to improve gameplay, correct issues, or add new content. These updates may change individual features while keeping the overall experience familiar.',
      ),
    ],
  );
}
