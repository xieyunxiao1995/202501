import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/storage/game_storage.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/felt_scaffold.dart';
import '../../core/widgets/gold_panel.dart';
import '../creative/creative_screen.dart';
import '../daily_challenge/daily_challenge_screen.dart';
import '../achievement/achievement_screen.dart';
import '../levels/level_catalog.dart';
import '../levels/level_screen.dart';
import '../solitaire/game_screen.dart';
import '../settings/settings_screen.dart';
import '../statistics/statistics_screen.dart';
import '../themes/theme_screen.dart';
import 'home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PlayerProgress _progress = PlayerProgress.initial();
  bool _hasActiveGame = false;
  bool _savedGameUnavailable = false;
  bool _checkedOnboarding = false;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final preferences = await SharedPreferences.getInstance();
    final storage = GameStorage(preferences);
    final progress = await storage.loadProgress();
    final savedGame = await storage.loadGameResult();
    if (mounted) {
      setState(() {
        _progress = progress;
        _hasActiveGame = savedGame.state != null;
        _savedGameUnavailable = savedGame.failed;
      });
    }
    if (!_checkedOnboarding &&
        preferences.getBool('solitaire.onboarding_seen') != true) {
      _checkedOnboarding = true;
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _showOnboarding(preferences),
      );
    }
  }

  Future<void> _showOnboarding(SharedPreferences preferences) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const _OnboardingDialog(),
    );
    await preferences.setBool('solitaire.onboarding_seen', true);
  }

  Future<void> _push(BuildContext context, Widget page) async {
    await Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
    _loadProgress();
  }

  @override
  Widget build(BuildContext context) {
    final currentChapter = _progress.currentChapter;
    final nextLevel = LevelCatalog.level(_progress.unlockedLevel);
    final completedInChapter = LevelCatalog.completedLevels(
      currentChapter,
      _progress.completedStars,
    );
    final selectedTheme = ThemeOption.byId(_progress.selectedTheme);

    return FeltScaffold(
      accent: Color(selectedTheme.tableColor),
      backgroundAsset: selectedTheme.backgroundAsset,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        children: [
          Row(
            children: [
              GoldPanel(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 7,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.stars_rounded, color: Color(0xFFFFD34F)),
                    const SizedBox(width: 5),
                    Text(
                      '${_progress.completedStars.values.fold<int>(0, (sum, stars) => sum + stars)} stars',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              _RoundIcon(
                Icons.settings_rounded,
                onTap: () => _push(context, const SettingsScreen()),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Solitaire',
            style: TextStyle(
              fontFamily: 'serif',
              color: Color(0xFFF6F0D4),
              fontSize: 55,
              fontWeight: FontWeight.w600,
              height: .85,
              shadows: [Shadow(color: Colors.black, blurRadius: 6)],
            ),
          ),
          const Text(
            'Journey',
            style: TextStyle(
              fontFamily: 'serif',
              color: Color(0xFFF2C444),
              fontSize: 35,
              fontWeight: FontWeight.w700,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 18),
          _homePanel(
            icon: Icons.calendar_month_rounded,
            iconColor: const Color(0xFFF05B47),
            title: 'Daily Challenge',
            subtitle: 'A new challenge every day!',
            onTap: () => _push(context, const DailyChallengeScreen()),
          ),
          const SizedBox(height: 10),
          _homePanel(
            icon: _savedGameUnavailable
                ? Icons.warning_amber_rounded
                : _hasActiveGame
                ? Icons.play_circle_fill_rounded
                : Icons.workspace_premium_rounded,
            iconColor: _savedGameUnavailable
                ? const Color(0xFFFFB74D)
                : const Color(0xFFFFD34F),
            title: _savedGameUnavailable
                ? 'Saved game unavailable'
                : _hasActiveGame
                ? 'Continue Game'
                : 'Start Adventure',
            subtitle: _savedGameUnavailable
                ? 'Start a new adventure?'
                : _hasActiveGame
                ? 'Resume your unfinished game'
                : 'Chapter ${currentChapter.number} · Level ${_progress.unlockedLevel}',
            onTap: () => _push(
              context,
              _hasActiveGame
                  ? const SolitaireGameScreen()
                  : _savedGameUnavailable
                  ? const SolitaireGameScreen()
                  : SolitaireGameScreen(
                      seed: nextLevel.seed,
                      adventureTitle:
                          'Level ${nextLevel.number.toString().padLeft(2, '0')} · ${nextLevel.title}',
                      level: nextLevel.number,
                      targetTimeSeconds: nextLevel.targetTimeSeconds,
                      targetMoves: nextLevel.targetMoves,
                    ),
            ),
          ),
          const SizedBox(height: 14),
          const _SectionTitle('Start Playing'),
          const SizedBox(height: 8),
          _gameButton(
            context,
            Icons.style_rounded,
            'Classic Solitaire',
            'Draw-one Klondike, ready anytime',
            const Color(0xFF528A27),
            () => _push(context, const SolitaireGameScreen()),
          ),
          const SizedBox(height: 9),
          _gameButton(
            context,
            Icons.lightbulb_rounded,
            'Creative Modes',
            'Explore unique and fun ways to play',
            const Color(0xFF683EAB),
            () => _push(context, const CreativeScreen()),
          ),
          const SizedBox(height: 14),
          const _SectionTitle('Journey Progress'),
          const SizedBox(height: 8),
          GoldPanel(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Text(
                      'Chapter ${currentChapter.number}: ${currentChapter.title}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$completedInChapter/${LevelCatalog.levelsPerChapter}',
                      style: const TextStyle(color: Color(0xFFFFE095)),
                    ),
                  ],
                ),
                const SizedBox(height: 9),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: completedInChapter / LevelCatalog.levelsPerChapter,
                    minHeight: 11,
                    color: const Color(0xFFE4AA27),
                    backgroundColor: const Color(0xFF0A2415),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _journeyButton(
                  Icons.emoji_events_rounded,
                  'Achievements',
                  () => _push(context, const AchievementScreen()),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _journeyButton(
                  Icons.insights_rounded,
                  'Statistics',
                  () => _push(context, const StatisticsScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          JourneyBottomNav(
            onSettings: () => _push(context, const SettingsScreen()),
            onLevels: () => _push(context, const LevelScreen()),
            onTheme: () => _push(context, const ThemeScreen()),
          ),
        ],
      ),
    );
  }

  Widget _homePanel({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(16),
    child: GoldPanel(
      child: Row(
        children: [
          Icon(icon, size: 39, color: iconColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFFE4E8D6),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
    ),
  );

  Widget _gameButton(
    BuildContext context,
    IconData icon,
    String title,
    String subtitle,
    Color color,
    VoidCallback onTap,
  ) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(15),
    child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [color, color.withValues(alpha: .64)]),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xFFF0D970).withValues(alpha: .6),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFFFF6D7), size: 37),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 19,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
    ),
  );

  Widget _journeyButton(IconData icon, String label, VoidCallback onTap) =>
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(13),
        child: GoldPanel(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            children: [
              Icon(icon, color: const Color(0xFFFFD54D)),
              const SizedBox(height: 4),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
}

class _RoundIcon extends StatelessWidget {
  const _RoundIcon(this.icon, {this.onTap});
  final IconData icon;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(24),
    child: Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF8EB26A)),
      ),
      child: Icon(icon, color: Colors.white),
    ),
  );
}

class _OnboardingDialog extends StatefulWidget {
  const _OnboardingDialog();
  @override
  State<_OnboardingDialog> createState() => _OnboardingDialogState();
}

class _OnboardingDialogState extends State<_OnboardingDialog> {
  final _controller = PageController();
  var _page = 0;
  static const _pages = [
    (
      Icons.touch_app_rounded,
      'Tap a pile to draw',
      'Tap the stock to draw a card, or tap cards to move them.',
    ),
    (
      Icons.compare_arrows_rounded,
      'Alternate red and black',
      'Place a lower card of the opposite color on a higher card.',
    ),
    (
      Icons.workspace_premium_rounded,
      'Collect A to K',
      'Build each suit from Ace to King in the upper-right foundations to win.',
    ),
  ];
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF173C25),
      title: Text(
        'Getting Started ${_page + 1}/3',
        style: const TextStyle(color: Color(0xFFFFE7A3)),
      ),
      content: SizedBox(
        width: 280,
        height: 165,
        child: PageView.builder(
          controller: _controller,
          onPageChanged: (value) => setState(() => _page = value),
          itemCount: _pages.length,
          itemBuilder: (_, index) {
            final page = _pages[index];
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(page.$1, color: const Color(0xFFFFD54D), size: 48),
                const SizedBox(height: 12),
                Text(
                  page.$2,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  page.$3,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xFFD8E3CC)),
                ),
              ],
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Skip'),
        ),
        FilledButton(
          onPressed: () => _page == 2
              ? Navigator.pop(context)
              : _controller.nextPage(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOut,
                ),
          child: Text(_page == 2 ? 'Start Playing' : 'Next'),
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Expanded(child: Divider(color: Color(0xFFC9A841))),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'serif',
            color: Color(0xFFFFE7A3),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      const Expanded(child: Divider(color: Color(0xFFC9A841))),
    ],
  );
}
