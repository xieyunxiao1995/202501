import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'services/game_service.dart';
import 'ui/screens/title_screen.dart';
import 'ui/screens/hub_screen.dart';
import 'ui/screens/splash_screen.dart';

final gameService = GameService();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '山海墨骨',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: _showSplash
          ? SplashScreen(
              gameService: gameService,
              onFinished: () {
                if (mounted) {
                  setState(() {
                    _showSplash = false;
                  });
                }
              },
            )
          : ListenableBuilder(
              listenable: gameService,
              builder: (context, _) {
                if (gameService.player != null) {
                  return HubScreen(gameService: gameService);
                }
                return TitleScreen(gameService: gameService);
              },
            ),
    );
  }
}
