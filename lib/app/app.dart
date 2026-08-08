import 'package:flutter/material.dart';

import '../features/launch/launch_splash_screen.dart';

class SolitaireApp extends StatelessWidget {
  const SolitaireApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Solitaire Journey',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFF071A10),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFFE6BC45),
        secondary: Color(0xFF78A83B),
      ),
    ),
    home: const LaunchSplashScreen(),
  );
}
