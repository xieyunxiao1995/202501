import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';
import '../../services/game_service.dart';
import '../widgets/ink_button.dart';
import '../widgets/background_scaffold.dart';
import 'hub_screen.dart';

class TitleScreen extends StatelessWidget {
  final GameService gameService;

  const TitleScreen({super.key, required this.gameService});

  @override
  Widget build(BuildContext context) {
    return BackgroundScaffold(
      backgroundImage: AppAssets.bgAncientStoneCircle,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Title (Vertical)
                    Column(
                      children: [
                         Text(
                          '山海墨骨',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: Colors.white,
                            fontSize: MediaQuery.of(context).size.width < 380 ? 48 : 64,
                          ),
                        ).animate().fadeIn(duration: 1000.ms).moveY(begin: 20, end: 0),
                        const SizedBox(height: 20),
                         Text(
                          '山海',
                          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            color: AppColors.inkRed,
                            fontSize: MediaQuery.of(context).size.width < 380 ? 36 : 48,
                          ),
                        ).animate().fadeIn(delay: 500.ms, duration: 1000.ms),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 80),
                InkButton(
                  text: '启封',
                  onPressed: () async {
                    await gameService.createNewGame();
                    if (context.mounted) {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (_) => HubScreen(gameService: gameService),
                        ),
                      );
                    }
                  },
                ).animate().fadeIn(delay: 1500.ms),
              ],
            ),
          ),
    );
  }
}
