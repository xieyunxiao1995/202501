import 'package:flutter/material.dart';

import '../shell_page.dart';
import 'consent_login_page.dart';
import 'onboarding_page.dart';

enum LaunchStage { onboarding, consent, app }

class LaunchFlowPage extends StatefulWidget {
  const LaunchFlowPage({super.key});

  @override
  State<LaunchFlowPage> createState() => _LaunchFlowPageState();
}

class _LaunchFlowPageState extends State<LaunchFlowPage> {
  LaunchStage _stage = LaunchStage.onboarding;

  void _showConsent() => setState(() => _stage = LaunchStage.consent);

  void _enterApp() => setState(() => _stage = LaunchStage.app);

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : const Duration(milliseconds: 360),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      child: switch (_stage) {
        LaunchStage.onboarding => OnboardingPage(
          key: const ValueKey('onboarding'),
          onSkip: _showConsent,
          onFinished: _showConsent,
        ),
        LaunchStage.consent => ConsentLoginPage(
          key: const ValueKey('consent'),
          onLogin: _enterApp,
        ),
        LaunchStage.app => const ShellPage(key: ValueKey('app')),
      },
    );
  }
}
