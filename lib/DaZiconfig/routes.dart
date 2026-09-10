import 'package:flutter/material.dart';
import '../screens/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/eula_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/detail/repair_detail_screen.dart';
import '../screens/detail/photo_fullscreen.dart';
import '../screens/detail/technique_analysis_screen.dart';
import '../screens/detail/repair_log_screen.dart';
import '../screens/detail/add_repair_log_screen.dart';
import '../screens/settings/about_screen.dart';
import '../screens/settings/user_agreement_screen.dart';
import '../screens/settings/privacy_policy_screen.dart';
import '../screens/settings/help_tutorial_screen.dart';
import '../screens/settings/feedback_screen.dart';
import '../screens/statistics_screen.dart';
import '../DaZiIAP/RestartMissedMetadataCache.dart';

class AppRoutes {
  // Route Names
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String eula = '/eula';
  static const String main = '/main';
  static const String repairDetail = '/repair-detail';
  static const String photoFullscreen = '/photo-fullscreen';
  static const String techniqueAnalysis = '/technique-analysis';
  static const String repairLog = '/repair-log';
  static const String addRepairLog = '/add-repair-log';
  static const String statistics = '/statistics';
  static const String about = '/about';
  static const String userAgreement = '/user-agreement';
  static const String privacyPolicy = '/privacy-policy';
  static const String helpTutorial = '/help-tutorial';
  static const String feedback = '/feedback';
  static const String store = '/store';

  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => const SplashScreen(),
    onboarding: (context) => const OnboardingScreen(),
    eula: (context) => const EulaScreen(),
    main: (context) => const MainScreen(),
    repairDetail: (context) => const RepairDetailScreen(),
    photoFullscreen: (context) => const PhotoFullscreenScreen(),
    techniqueAnalysis: (context) => const TechniqueAnalysisScreen(),
    repairLog: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      return RepairLogScreen(projectId: args as String);
    },
    addRepairLog: (context) {
      final args = ModalRoute.of(context)!.settings.arguments;
      return AddRepairLogScreen(arguments: args);
    },
    statistics: (context) => const StatisticsScreen(),
    about: (context) => const AboutScreen(),
    userAgreement: (context) => const UserAgreementScreen(),
    privacyPolicy: (context) => const PrivacyPolicyScreen(),
    helpTutorial: (context) => const HelpTutorialScreen(),
    feedback: (context) => const FeedbackScreen(),
    store: (context) => const InitializeKeyCoordProtocol(),
  };
}
