import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/storage/game_storage.dart';
import '../../core/widgets/felt_scaffold.dart';
import '../../core/widgets/gold_panel.dart';
import '../home/home_controller.dart';

class ThemeScreen extends StatefulWidget {
  const ThemeScreen({super.key});
  @override
  State<ThemeScreen> createState() => _ThemeScreenState();
}

class _ThemeScreenState extends State<ThemeScreen> {
  PlayerProgress _progress = PlayerProgress.initial();
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await GameStorage(
      await SharedPreferences.getInstance(),
    ).loadProgress();
    if (mounted) setState(() => _progress = p);
  }

  Future<void> _select(ThemeOption theme) async {
    final next = _progress.selectTheme(theme.id);
    await GameStorage(await SharedPreferences.getInstance()).saveProgress(next);
    if (mounted) setState(() => _progress = next);
  }

  @override
  Widget build(BuildContext context) {
    final selected = ThemeOption.byId(_progress.selectedTheme);
    return FeltScaffold(
      accent: Color(selected.tableColor),
      backgroundAsset: selected.backgroundAsset,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _themeTitle(context),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              'All themes are free to use',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFFFD54D),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          for (final theme in ThemeOption.all)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: InkWell(
                onTap: () => _select(theme),
                borderRadius: BorderRadius.circular(16),
                child: GoldPanel(
                  color: Color(theme.tableColor),
                  child: Row(
                    children: [
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          color: Color(theme.tableColor),
                          border: Border.all(color: const Color(0xFFFFD54D)),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Image.asset(
                          theme.backgroundAsset,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              theme.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              _progress.selectedTheme == theme.id
                                  ? 'Currently selected'
                                  : 'Free to use',
                              style: const TextStyle(color: Color(0xFFFFE29A)),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        _progress.selectedTheme == theme.id
                            ? Icons.check_circle_rounded
                            : Icons.palette_outlined,
                        color: const Color(0xFFFFD54D),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

Widget _themeTitle(BuildContext context) => Row(
  children: [
    IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
    ),
    const Expanded(
      child: Text(
        'Table Themes',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 25,
          fontWeight: FontWeight.w800,
        ),
      ),
    ),
    const SizedBox(width: 48),
  ],
);
