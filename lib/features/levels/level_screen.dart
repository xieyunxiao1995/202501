import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/storage/game_storage.dart';
import '../../core/widgets/felt_scaffold.dart';
import '../../core/widgets/gold_panel.dart';
import '../home/home_controller.dart';
import '../solitaire/game_screen.dart';
import 'level_catalog.dart';

class LevelScreen extends StatefulWidget {
  const LevelScreen({super.key});

  @override
  State<LevelScreen> createState() => _LevelScreenState();
}

class _LevelScreenState extends State<LevelScreen> {
  PlayerProgress _progress = PlayerProgress.initial();
  var _selectedChapterNumber = 1;
  var _selectedChapterInitialized = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final progress = await GameStorage(
      await SharedPreferences.getInstance(),
    ).loadProgress();
    if (!mounted) return;
    setState(() {
      _progress = progress;
      if (!_selectedChapterInitialized) {
        _selectedChapterNumber = progress.currentChapter.number;
        _selectedChapterInitialized = true;
      }
    });
  }

  LevelChapter get _selectedChapter =>
      LevelCatalog.chapters[_selectedChapterNumber - 1];

  bool _isChapterUnlocked(LevelChapter chapter) =>
      chapter.number == 1 ||
      _progress.unlockedLevel >= chapter.levels.first.number;

  void _selectChapter(LevelChapter chapter) {
    if (!_isChapterUnlocked(chapter)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complete the previous chapter first.')),
      );
      return;
    }
    setState(() => _selectedChapterNumber = chapter.number);
  }

  Future<void> _openLevel(LevelDefinition level) async {
    if (level.number > _progress.unlockedLevel) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This level is still locked.')),
      );
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (dialogContext) => _LevelDetailDialog(
        chapter: _selectedChapter,
        level: level,
        stars: _progress.completedStars[level.number] ?? 0,
        bestTimeSeconds: _progress.levelBestTimes[level.number],
        bestMoves: _progress.levelBestMoves[level.number],
        onStart: () {
          Navigator.of(dialogContext).pop();
          _startLevel(level);
        },
      ),
    );
  }

  Future<void> _startLevel(LevelDefinition level) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => SolitaireGameScreen(
          seed: level.seed,
          adventureTitle:
              'Level ${level.number.toString().padLeft(2, '0')} · ${level.title}',
          level: level.number,
          targetTimeSeconds: level.targetTimeSeconds,
          targetMoves: level.targetMoves,
        ),
      ),
    );
    if (mounted) _load();
  }

  @override
  Widget build(BuildContext context) {
    final chapter = _selectedChapter;
    final completed = LevelCatalog.completedLevels(
      chapter,
      _progress.completedStars,
    );
    final stars = LevelCatalog.starsInChapter(
      chapter,
      _progress.completedStars,
    );

    return FeltScaffold(
      accent: Color(chapter.color),
      child: Column(
        children: [
          _topBar(),
          Expanded(
            child: ChapterBackground(
              chapter: chapter,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(14, 4, 14, 22),
                child: Column(
                  children: [
                    ChapterHeader(
                      chapter: chapter,
                      completedLevels: completed,
                      stars: stars,
                    ),
                    const SizedBox(height: 14),
                    if (completed == LevelCatalog.levelsPerChapter)
                      _ChapterReward(chapter: chapter),
                    if (completed == LevelCatalog.levelsPerChapter)
                      const SizedBox(height: 14),
                    for (
                      var index = 0;
                      index < chapter.levels.length;
                      index++
                    ) ...[
                      Align(
                        alignment: _pathAlignment(index),
                        child: LevelCard(
                          key: ValueKey(
                            'level-card-${chapter.levels[index].number}',
                          ),
                          level: chapter.levels[index],
                          chapterSymbol: chapter.symbol,
                          unlocked:
                              chapter.levels[index].number <=
                              _progress.unlockedLevel,
                          current:
                              chapter.levels[index].number ==
                                  _progress.unlockedLevel &&
                              (_progress.completedStars[chapter
                                          .levels[index]
                                          .number] ??
                                      0) ==
                                  0,
                          stars:
                              _progress.completedStars[chapter
                                  .levels[index]
                                  .number] ??
                              0,
                          accent: Color(chapter.color),
                          onTap: () => _openLevel(chapter.levels[index]),
                        ),
                      ),
                      if (index != chapter.levels.length - 1)
                        const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
          ),
          _chapterStrip(),
        ],
      ),
    );
  }

  Widget _topBar() => Padding(
    padding: const EdgeInsets.fromLTRB(10, 8, 12, 3),
    child: Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
        ),
        const Expanded(
          child: Column(
            children: [
              Text(
                'SOLITAIRE JOURNEY',
                style: TextStyle(
                  color: Color(0xFFE1D7AD),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.4,
                ),
              ),
              Text(
                'Adventure Map',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
        GoldPanel(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          child: Text(
            '${_progress.completedStars.length}/${LevelCatalog.totalLevels}',
            style: const TextStyle(
              color: Color(0xFFFFE7A3),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _chapterStrip() => Container(
    height: 82,
    padding: const EdgeInsets.fromLTRB(10, 6, 10, 4),
    decoration: BoxDecoration(
      color: const Color(0xFF061A10).withValues(alpha: .82),
      border: Border(
        top: BorderSide(color: Colors.white.withValues(alpha: .12)),
      ),
    ),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (
            var index = 0;
            index < LevelCatalog.chapters.length;
            index++
          ) ...[
            SizedBox(
              width: 122,
              child: _ChapterTab(
                chapter: LevelCatalog.chapters[index],
                selected:
                    LevelCatalog.chapters[index].number ==
                    _selectedChapterNumber,
                unlocked: _isChapterUnlocked(LevelCatalog.chapters[index]),
                onTap: () => _selectChapter(LevelCatalog.chapters[index]),
              ),
            ),
            if (index != LevelCatalog.chapters.length - 1)
              const SizedBox(width: 7),
          ],
        ],
      ),
    ),
  );
}

Alignment _pathAlignment(int index) {
  switch (index % 4) {
    case 1:
      return Alignment.centerLeft;
    case 3:
      return Alignment.centerRight;
    default:
      return Alignment.center;
  }
}

class ChapterHeader extends StatelessWidget {
  const ChapterHeader({
    super.key,
    required this.chapter,
    required this.completedLevels,
    required this.stars,
  });

  final LevelChapter chapter;
  final int completedLevels;
  final int stars;

  @override
  Widget build(BuildContext context) => GoldPanel(
    color: Color(chapter.color).withValues(alpha: .9),
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
    child: Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(chapter.symbol, style: const TextStyle(fontSize: 38)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chapter ${chapter.number}',
                    style: const TextStyle(
                      color: Color(0xFFFFE59A),
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      letterSpacing: .8,
                    ),
                  ),
                  Text(
                    chapter.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    chapter.subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFE0EAD6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(chapter.icon, color: const Color(0xFFFFE28A), size: 28),
          ],
        ),
        const SizedBox(height: 13),
        Row(
          children: [
            Text(
              '$completedLevels / ${LevelCatalog.levelsPerChapter} Levels Complete',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            const Spacer(),
            Text(
              '$stars / ${LevelCatalog.levelsPerChapter * LevelCatalog.maxStarsPerLevel} Stars',
              style: const TextStyle(
                color: Color(0xFFFFE59A),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: completedLevels / LevelCatalog.levelsPerChapter,
            minHeight: 8,
            color: const Color(0xFFFFD34F),
            backgroundColor: Colors.black.withValues(alpha: .28),
          ),
        ),
      ],
    ),
  );
}

class ChapterBackground extends StatelessWidget {
  const ChapterBackground({
    super.key,
    required this.chapter,
    required this.child,
  });

  final LevelChapter chapter;
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(chapter.color).withValues(alpha: .2),
                Colors.black.withValues(alpha: .06),
              ],
            ),
          ),
        ),
      ),
      Positioned(
        top: 16,
        right: 22,
        child: IgnorePointer(
          child: Opacity(
            opacity: .1,
            child: Text(chapter.symbol, style: const TextStyle(fontSize: 82)),
          ),
        ),
      ),
      child,
    ],
  );
}

class LevelCard extends StatelessWidget {
  const LevelCard({
    super.key,
    required this.level,
    required this.chapterSymbol,
    required this.unlocked,
    required this.current,
    required this.stars,
    required this.accent,
    required this.onTap,
  });

  final LevelDefinition level;
  final String chapterSymbol;
  final bool unlocked;
  final bool current;
  final int stars;
  final Color accent;
  final VoidCallback onTap;

  String get _stars => '★' * stars + '☆' * (3 - stars);

  @override
  Widget build(BuildContext context) {
    final textColor = unlocked
        ? Colors.white
        : Colors.white.withValues(alpha: .5);
    final secondaryColor = unlocked
        ? const Color(0xFFF0E3BF)
        : Colors.white.withValues(alpha: .38);
    final width = (MediaQuery.sizeOf(context).width - 28)
        .clamp(190.0, 228.0)
        .toDouble();
    final card = Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          width: width,
          height: 96,
          padding: const EdgeInsets.fromLTRB(13, 6, 10, 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: unlocked
                  ? [
                      Color.lerp(const Color(0xFF9B6B36), accent, .18)!,
                      const Color(0xFF674224),
                    ]
                  : [
                      const Color(0xFF4A4A43).withValues(alpha: .78),
                      const Color(0xFF2C342E).withValues(alpha: .82),
                    ],
            ),
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: current
                  ? const Color(0xFFFFD85A)
                  : unlocked && stars > 0
                  ? const Color(0xFFE7B744).withValues(alpha: .8)
                  : Colors.white.withValues(alpha: .2),
              width: current ? 2 : 1,
            ),
            boxShadow: current
                ? const [
                    BoxShadow(
                      color: Color(0x99FFD84D),
                      blurRadius: 18,
                      spreadRadius: 1,
                    ),
                  ]
                : const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 38,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (unlocked)
                      Text(
                        chapterSymbol,
                        style: TextStyle(fontSize: 20, color: secondaryColor),
                      )
                    else
                      Icon(Icons.lock_rounded, color: secondaryColor, size: 24),
                    if (current) ...[
                      const SizedBox(height: 3),
                      const Icon(
                        Icons.auto_awesome,
                        color: Color(0xFFFFE99A),
                        size: 13,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Level ${level.number.toString().padLeft(2, '0')}',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      level.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: secondaryColor, fontSize: 11),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _stars,
                      style: TextStyle(
                        color: stars > 0
                            ? const Color(0xFFFFD34F)
                            : Colors.white.withValues(alpha: .58),
                        fontSize: 14,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
              ),
              if (current)
                FilledButton.tonal(
                  onPressed: onTap,
                  style: FilledButton.styleFrom(
                    foregroundColor: const Color(0xFF5A3A19),
                    backgroundColor: const Color(0xFFFFD85A),
                    minimumSize: const Size(0, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 9),
                    textStyle: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  child: const Text('PLAY'),
                ),
            ],
          ),
        ),
      ),
    );
    return Opacity(opacity: unlocked ? 1 : .66, child: card);
  }
}

class _ChapterTab extends StatelessWidget {
  const _ChapterTab({
    required this.chapter,
    required this.selected,
    required this.unlocked,
    required this.onTap,
  });

  final LevelChapter chapter;
  final bool selected;
  final bool unlocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(13),
    child: Container(
      height: 68,
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
      decoration: BoxDecoration(
        color: selected
            ? Color(chapter.color).withValues(alpha: .94)
            : const Color(0xFF092316).withValues(alpha: .78),
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: selected
              ? const Color(0xFFFFD957)
              : Colors.white.withValues(alpha: .12),
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            unlocked ? chapter.icon : Icons.lock_outline_rounded,
            color: unlocked
                ? const Color(0xFFFFDF69)
                : Colors.white.withValues(alpha: .45),
            size: 21,
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Chapter ${chapter.number}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  unlocked ? chapter.title : 'Locked',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: unlocked
                        ? const Color(0xFFE1E8D5)
                        : const Color(0xFFB9C0B6),
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _ChapterReward extends StatelessWidget {
  const _ChapterReward({required this.chapter});

  final LevelChapter chapter;

  @override
  Widget build(BuildContext context) => GoldPanel(
    color: Color(chapter.color).withValues(alpha: .82),
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
    child: Row(
      children: [
        const Icon(
          Icons.emoji_events_rounded,
          color: Color(0xFFFFD34F),
          size: 34,
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chapter Complete!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'A free journey reward is ready.',
                style: TextStyle(color: Color(0xFFE7EAD5), fontSize: 12),
              ),
            ],
          ),
        ),
        Text(
          chapter.rewardTitle,
          textAlign: TextAlign.end,
          style: const TextStyle(
            color: Color(0xFFFFE59A),
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}

class _LevelDetailDialog extends StatelessWidget {
  const _LevelDetailDialog({
    required this.chapter,
    required this.level,
    required this.stars,
    required this.bestTimeSeconds,
    required this.bestMoves,
    required this.onStart,
  });

  final LevelChapter chapter;
  final LevelDefinition level;
  final int stars;
  final int? bestTimeSeconds;
  final int? bestMoves;
  final VoidCallback onStart;

  String get _bestTime {
    final seconds = bestTimeSeconds;
    if (seconds == null) return '--:--';
    return '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  String get _stars => '★' * stars + '☆' * (3 - stars);

  String _targetTime(int seconds) =>
      '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.transparent,
    insetPadding: const EdgeInsets.all(22),
    child: ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.sizeOf(context).height * .84,
      ),
      child: SingleChildScrollView(
        child: GoldPanel(
          color: Color(chapter.color).withValues(alpha: .98),
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(chapter.symbol, style: const TextStyle(fontSize: 28)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Level ${level.number.toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
              Text(
                level.title,
                style: const TextStyle(
                  color: Color(0xFFFFE59A),
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                level.goal,
                style: const TextStyle(color: Color(0xFFE7EAD5), fontSize: 13),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Text(
                    'Difficulty',
                    style: TextStyle(color: Color(0xFFDBE5CE), fontSize: 11),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    '${'★' * level.difficulty}${'☆' * (5 - level.difficulty)}',
                    style: const TextStyle(
                      color: Color(0xFFFFD34F),
                      fontSize: 12,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Targets',
                style: TextStyle(
                  color: Color(0xFFFFE7A3),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              _GoalRow(label: 'Complete the level', complete: stars > 0),
              _GoalRow(
                label: '${level.targetMoves} moves or fewer',
                complete: bestMoves != null && bestMoves! <= level.targetMoves,
              ),
              _GoalRow(
                label: '${_targetTime(level.targetTimeSeconds)} or less',
                complete:
                    bestTimeSeconds != null &&
                    bestTimeSeconds! <= level.targetTimeSeconds,
              ),
              const SizedBox(height: 13),
              const Text(
                'Best',
                style: TextStyle(
                  color: Color(0xFFFFE7A3),
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: _Record(label: 'Time', value: _bestTime),
                  ),
                  Expanded(
                    child: _Record(
                      label: 'Moves',
                      value: bestMoves?.toString() ?? '--',
                    ),
                  ),
                  Expanded(
                    child: _Record(label: 'Stars', value: _stars),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onStart,
                  icon: const Icon(Icons.play_arrow_rounded),
                  label: const Text('Start'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD34F),
                    foregroundColor: const Color(0xFF553915),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    textStyle: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _GoalRow extends StatelessWidget {
  const _GoalRow({required this.label, required this.complete});

  final String label;
  final bool complete;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(
      children: [
        Icon(
          complete ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
          color: complete ? const Color(0xFFFFD34F) : const Color(0xFFB7C4AE),
          size: 18,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: Color(0xFFE7EAD5), fontSize: 13),
          ),
        ),
      ],
    ),
  );
}

class _Record extends StatelessWidget {
  const _Record({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: Color(0xFFDBE5CE), fontSize: 11),
      ),
      const SizedBox(height: 3),
      Text(
        value,
        style: const TextStyle(
          color: Color(0xFFFFE59A),
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    ],
  );
}
