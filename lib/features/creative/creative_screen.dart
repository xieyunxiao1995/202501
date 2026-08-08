import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/storage/game_storage.dart';
import '../../core/widgets/felt_scaffold.dart';
import 'creative_detail_screen.dart';
import 'creative_mode.dart';
import 'creative_progress.dart';

class CreativeScreen extends StatefulWidget {
  const CreativeScreen({super.key});

  @override
  State<CreativeScreen> createState() => _CreativeScreenState();
}

class _CreativeScreenState extends State<CreativeScreen> {
  CreativeProgress _progress = CreativeProgress.initial();

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final progress = await GameStorage(
      await SharedPreferences.getInstance(),
    ).loadCreativeProgress();
    if (mounted) setState(() => _progress = progress);
  }

  Future<void> _openDetail(
    BuildContext context,
    CreativeModeDefinition mode,
  ) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (_) =>
            CreativeDetailScreen(mode: mode, initialProgress: _progress),
      ),
    );
    await _loadProgress();
  }

  @override
  Widget build(BuildContext context) => FeltScaffold(
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                ),
              ),
              const Expanded(
                child: Text(
                  'Creative Modes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const Icon(Icons.auto_awesome_rounded, color: Color(0xFFFFD34A)),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            'Five complete ways to play.',
            style: TextStyle(color: Color(0xFFE9E2C1), fontSize: 13),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.only(bottom: 4),
              itemCount: CreativeModeCatalog.visible.length,
              separatorBuilder: (_, _) => const SizedBox(height: 7),
              itemBuilder: (context, index) {
                final mode = CreativeModeCatalog.visible[index];
                return _ModeCard(
                  mode: mode,
                  progress: _progress,
                  onTap: () => _openDetail(context, mode),
                  onStart: () => _openDetail(context, mode),
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.mode,
    required this.progress,
    required this.onTap,
    required this.onStart,
  });

  final CreativeModeDefinition mode;
  final CreativeProgress progress;
  final VoidCallback onTap;
  final VoidCallback onStart;

  String _time(int? seconds) => seconds == null
      ? '--:--'
      : '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';

  String _moves(int? moves) => moves == null ? '--' : '$moves';

  @override
  Widget build(BuildContext context) => InkWell(
    key: ValueKey('creative-mode-${mode.type.name}'),
    onTap: onTap,
    borderRadius: BorderRadius.circular(14),
    child: Container(
      constraints: const BoxConstraints(minHeight: 76),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [mode.accentColor, mode.accentColor.withValues(alpha: .62)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFF0D875).withValues(alpha: .55),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(mode.icon, color: const Color(0xFFFFDD65), size: 27),
          ),
          const SizedBox(width: 9),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        mode.section.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFFFFE7A3),
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .5,
                        ),
                      ),
                    ),
                    Text(
                      mode.difficultyLabel,
                      style: const TextStyle(
                        color: Color(0xFFFFE28A),
                        fontSize: 10,
                        letterSpacing: .5,
                      ),
                    ),
                  ],
                ),
                Text(
                  mode.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  mode.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
                const SizedBox(height: 2),
                Wrap(
                  spacing: 8,
                  runSpacing: 1,
                  children: [
                    _record('Wins', '${progress.winsFor(mode.type)}'),
                    _record('Best', _time(progress.bestTimeFor(mode.type))),
                    _record(
                      'Best Moves',
                      _moves(progress.bestMovesFor(mode.type)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 7),
          FilledButton.icon(
            key: ValueKey('creative-start-${mode.type.name}'),
            onPressed: onStart,
            icon: const Icon(Icons.play_arrow_rounded, size: 15),
            label: const Text('Start'),
            style: ButtonStyle(
              padding: const WidgetStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              ),
              minimumSize: const WidgetStatePropertyAll(Size.zero),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: const WidgetStatePropertyAll(
                TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _record(String label, String value) => Text(
    '$label $value',
    style: const TextStyle(
      color: Colors.white,
      fontSize: 9,
      fontWeight: FontWeight.w700,
    ),
  );
}
