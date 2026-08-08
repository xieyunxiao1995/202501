import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/storage/game_storage.dart';
import '../../core/widgets/felt_scaffold.dart';
import '../../core/widgets/gold_panel.dart';
import '../creative/creative_controller.dart';
import '../creative/creative_mode.dart';
import '../creative/creative_progress.dart';
import '../home/home_controller.dart';
import '../levels/level_catalog.dart';
import 'game_controller.dart';
import 'models/card_model.dart';
import 'models/pile_location.dart';
import 'widgets/playing_card_view.dart';
import 'widgets/win_sheet.dart';

enum _DeadEndAction { close, undo, restart }

class SolitaireGameScreen extends StatefulWidget {
  const SolitaireGameScreen({
    super.key,
    this.seed,
    this.adventureTitle,
    this.level,
    this.targetTimeSeconds,
    this.targetMoves,
    this.isDaily = false,
    this.creativeMode,
    this.timeTrialLimitSeconds,
  });
  final int? seed;
  final String? adventureTitle;
  final int? level;
  final int? targetTimeSeconds;
  final int? targetMoves;
  final bool isDaily;
  final CreativeModeType? creativeMode;
  final int? timeTrialLimitSeconds;

  @override
  State<SolitaireGameScreen> createState() => _SolitaireGameScreenState();
}

class _SolitaireGameScreenState extends State<SolitaireGameScreen> {
  late SolitaireGameController _game;
  CreativeGameController? _creative;
  PileLocation? _selected;
  SuggestedMove? _hint;
  Timer? _hintTimer;
  GameStorage? _storage;
  PlayerProgress? _progress;
  CreativeProgress? _creativeProgress;
  Timer? _timer;
  bool _settled = false;
  bool _paused = false;
  bool _timeTrialExpired = false;
  bool _timeUpDialogShown = false;
  bool _recoveryDialogShown = false;
  int _lastTreasureCount = 0;
  bool _jokerRescueAnnounced = false;
  bool _shadowMemoryActive = false;
  int _shadowMemorySecondsRemaining = 0;
  List<String> _shadowMemoryCards = const <String>[];
  bool _gameStartRecorded = false;

  @override
  void initState() {
    super.initState();
    _game = SolitaireGameController.newGame(
      seed: widget.seed,
      maxStockRecycles: _stockRecycleLimit,
    );
    _initializeCreativeSession();
    _restoreLocalGame();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  int? get _stockRecycleLimit =>
      widget.creativeMode == CreativeModeType.oneDrawSprint ? 0 : null;

  void _initializeCreativeSession() {
    final mode = widget.creativeMode;
    _creative = mode == null
        ? null
        : CreativeGameController.fromState(mode, _game.state);
    _lastTreasureCount = _creative?.treasuresFound(_game.state) ?? 0;
    _jokerRescueAnnounced = false;
    _shadowMemoryCards = _creative?.memoryCardLabels ?? const <String>[];
    _shadowMemoryActive = mode == CreativeModeType.shadowSolitaire;
    _shadowMemorySecondsRemaining = _shadowMemoryActive ? 5 : 0;
  }

  void _tick() {
    if (!mounted) return;
    if (_shadowMemoryActive) {
      setState(() {
        if (_shadowMemorySecondsRemaining <= 1) {
          _shadowMemoryActive = false;
          _shadowMemorySecondsRemaining = 0;
        } else {
          _shadowMemorySecondsRemaining--;
        }
      });
      return;
    }
    if (_game.state.completed || _paused || _timeTrialExpired) {
      return;
    }
    setState(_game.tick);
    final limit = widget.timeTrialLimitSeconds;
    if (_creative?.isTimeTrial == true &&
        limit != null &&
        _game.state.elapsedSeconds >= limit) {
      setState(() => _timeTrialExpired = true);
      _showTimeTrialExpired();
      return;
    }
    if (_creative?.isTimeTrial == true &&
        limit == null &&
        (_game.state.elapsedSeconds == 30 ||
            _game.state.elapsedSeconds == 60)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _game.state.elapsedSeconds == 30 ? 'Great pace!' : 'Keep going!',
          ),
        ),
      );
    }
    if (_game.state.elapsedSeconds % 15 == 0) _persist();
  }

  Future<void> _restoreLocalGame() async {
    final storage = GameStorage(await SharedPreferences.getInstance());
    _storage = storage;
    final progress = await storage.loadProgress();
    if (mounted) setState(() => _progress = progress);
    if (widget.creativeMode != null) {
      final creativeProgress = await storage.loadCreativeProgress();
      if (mounted) setState(() => _creativeProgress = creativeProgress);
    }
    if (widget.seed != null) {
      await _recordGameStart(progress);
      return;
    }
    final saved = await storage.loadGameResult();
    if (saved.state != null && mounted) {
      setState(() => _game = SolitaireGameController.fromState(saved.state!));
    } else if (saved.failed && mounted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _showSavedGameRecovery();
      });
    } else {
      await _recordGameStart(progress);
    }
  }

  Future<void> _recordGameStart([PlayerProgress? loadedProgress]) async {
    if (widget.creativeMode != null || _gameStartRecorded) return;
    _gameStartRecorded = true;
    final storage =
        _storage ?? GameStorage(await SharedPreferences.getInstance());
    _storage = storage;
    final progress =
        loadedProgress ?? _progress ?? await storage.loadProgress();
    final updated = progress.recordGameStart();
    if (mounted) setState(() => _progress = updated);
    await storage.saveProgress(updated);
  }

  Future<void> _showSavedGameRecovery() async {
    if (!mounted || _recoveryDialogShown) return;
    _recoveryDialogShown = true;
    final startNew = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF173C25),
        title: const Text(
          'Saved game unavailable',
          style: TextStyle(color: Color(0xFFFFE7A3)),
        ),
        content: const Text(
          'Start a new adventure?',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Back'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Start New Adventure'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    _recoveryDialogShown = false;
    if (startNew == true) {
      await _storage?.clearActiveGame();
      await _recordGameStart();
      _persist();
    } else {
      Navigator.pop(context);
    }
  }

  void _persist() {
    if (widget.creativeMode != null) return;
    _storage?.saveGame(_game.state);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _hintTimer?.cancel();
    super.dispose();
  }

  void _draw() {
    if (_timeTrialExpired || _shadowMemoryActive) return;
    var moved = false;
    var blockedRecycle = false;
    setState(() {
      blockedRecycle =
          widget.creativeMode == CreativeModeType.oneDrawSprint &&
          _game.state.stock.isEmpty &&
          _game.state.waste.isNotEmpty &&
          !_game.canDrawFromStock;
      moved = _game.drawFromStock();
      _selected = null;
      _clearHint();
    });
    if (moved) {
      _announceCreativeProgress();
      _persist();
      _checkForNoMoves();
    } else if (blockedRecycle) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'One Draw Sprint allows only one pass through the stock.',
          ),
        ),
      );
    }
  }

  void _choose(PileLocation location) {
    if (_timeTrialExpired || _shadowMemoryActive) return;
    if (location.type == PileType.stock) {
      _draw();
      return;
    }
    var moved = false;
    setState(() {
      if (_selected == null) {
        final cards = _cardsAt(location);
        if (cards == null || cards.isEmpty || !cards.first.isFaceUp) return;
        _selected = location;
        return;
      }
      moved = _game.moveCards(_selected!, location);
      if (moved) {
        _selected = null;
        _clearHint();
      } else if (_sameLocation(_selected!, location)) {
        _selected = null;
      }
    });
    if (!moved) return;
    _announceCreativeProgress();
    _persist();
    if (_game.state.completed) {
      _showWin();
    } else {
      _checkForNoMoves();
    }
  }

  void _handleDrop(PileLocation source, PileLocation target) {
    if (_timeTrialExpired || _shadowMemoryActive) return;
    var moved = false;
    setState(() {
      moved = _game.moveCards(source, target);
      if (moved) {
        _selected = null;
        _clearHint();
      }
    });
    if (!moved) return;
    _announceCreativeProgress();
    _persist();
    if (_game.state.completed) {
      _showWin();
    } else {
      _checkForNoMoves();
    }
  }

  List<PlayingCard>? _cardsAt(PileLocation location) {
    switch (location.type) {
      case PileType.waste:
        return _game.state.waste.isEmpty ? null : [_game.state.waste.last];
      case PileType.tableau:
        final pile = _game.state.tableau[location.index!];
        if (location.cardIndex == null || location.cardIndex! >= pile.length) {
          return null;
        }
        return pile.sublist(location.cardIndex!);
      case PileType.foundation:
        final pile = _game.state.foundations[Suit.values[location.index!]]!;
        return pile.isEmpty ? null : [pile.last];
      case PileType.stock:
        return null;
    }
  }

  bool _sameLocation(PileLocation a, PileLocation b) => a == b;

  int get _stars {
    if (_creative?.isTimeTrial == true) {
      if (_game.state.elapsedSeconds < 30) return 3;
      if (_game.state.elapsedSeconds < 60) return 2;
      return 1;
    }
    if (widget.level != null &&
        widget.targetTimeSeconds != null &&
        widget.targetMoves != null) {
      final movesOnTarget = _game.state.moves < widget.targetMoves!;
      final timeOnTarget =
          _game.state.elapsedSeconds < widget.targetTimeSeconds!;
      if (movesOnTarget && timeOnTarget) return 3;
      if (movesOnTarget) return 2;
      return 1;
    }
    return _game.state.elapsedSeconds <= 180 && _game.state.moves <= 60
        ? 3
        : _game.state.elapsedSeconds <= 360 && _game.state.moves <= 110
        ? 2
        : 1;
  }

  int get _score =>
      _game.state.foundations.values.fold<int>(
        0,
        (value, pile) => value + pile.length,
      ) *
      10;

  String get _timeLabel {
    final limit = widget.timeTrialLimitSeconds;
    final seconds = limit == null
        ? _game.state.elapsedSeconds
        : (limit - _game.state.elapsedSeconds).clamp(0, limit);
    return '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  String get _bestTimeLabel {
    final mode = widget.creativeMode;
    if (mode == null) return '--:--';
    final seconds = _creativeProgress?.bestTimeFor(mode);
    if (seconds == null) return '--:--';
    return '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
  }

  Future<void> _showWin() async {
    if (_settled) return;
    _settled = true;
    final storage = _storage;
    var creativeIsNewBest = false;
    int? creativeTreasuresFound;
    int? creativeTotalTreasures;
    bool creativeJokerRescued = false;
    if (widget.creativeMode == null) {
      final progress =
          _progress ??
          (storage == null
              ? PlayerProgress.initial()
              : await storage.loadProgress());
      final updated = progress.recordWin(
        elapsedSeconds: _game.state.elapsedSeconds,
        moves: _game.state.moves,
        level: widget.level,
        stars: _stars,
      );
      _progress = updated;
      await storage?.saveProgress(updated);
      await storage?.clearActiveGame();
    } else {
      final mode = widget.creativeMode!;
      final progress = storage == null
          ? CreativeProgress.initial()
          : await storage.loadCreativeProgress();
      final previousBest = progress.bestTimeFor(mode);
      creativeTreasuresFound = _creative?.treasuresFound(_game.state) ?? 0;
      creativeTotalTreasures = _creative?.totalTreasures ?? 0;
      creativeJokerRescued = _creative?.jokerUnlocked(_game.state) ?? false;
      final updated = progress.recordWin(
        mode,
        elapsedSeconds: _game.state.elapsedSeconds,
        moves: _game.state.moves,
        score: _score,
        treasuresFound: creativeTreasuresFound,
        stars: _stars,
      );
      _creativeProgress = updated;
      creativeIsNewBest =
          previousBest == null || _game.state.elapsedSeconds < previousBest;
      await storage?.saveCreativeProgress(updated);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      showModalBottomSheet<void>(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (context) => WinSheet(
          elapsedSeconds: _game.state.elapsedSeconds,
          moves: _game.state.moves,
          stars: _stars,
          creativeMode: widget.creativeMode,
          creativeTreasuresFound: creativeTreasuresFound,
          creativeTotalTreasures: creativeTotalTreasures,
          creativeJokerRescued: creativeJokerRescued,
          creativeIsNewBest: creativeIsNewBest,
          onMap: () => _leaveWinSheetToHome(context),
          onHome: () => _leaveWinSheetToHome(context),
          onReplay: () => _replayFromWinSheet(context),
          onNext: () => _nextFromWinSheet(context),
        ),
      );
    });
  }

  void _leaveWinSheetToHome(BuildContext sheetContext) {
    Navigator.pop(sheetContext);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  void _replayFromWinSheet(BuildContext sheetContext) {
    Navigator.pop(sheetContext);
    if (widget.creativeMode != null) _recordCreativePlay();
    _newDeal();
  }

  void _nextFromWinSheet(BuildContext sheetContext) {
    Navigator.pop(sheetContext);
    if (widget.creativeMode != null || widget.level == null) {
      _recordCreativePlay();
      _newDeal();
      return;
    }
    final currentLevel = widget.level!;
    if (currentLevel >= LevelCatalog.totalLevels) {
      Navigator.of(context).pop();
      return;
    }
    final nextLevel = LevelCatalog.level(currentLevel + 1);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => SolitaireGameScreen(
          seed: nextLevel.seed,
          adventureTitle:
              'Level ${nextLevel.number.toString().padLeft(2, '0')} · ${nextLevel.title}',
          level: nextLevel.number,
          targetTimeSeconds: nextLevel.targetTimeSeconds,
          targetMoves: nextLevel.targetMoves,
        ),
      ),
    );
  }

  void _newDeal() {
    setState(() {
      _game = SolitaireGameController.newGame(
        seed: widget.seed == null ? null : widget.seed! + _game.state.moves + 1,
        maxStockRecycles: _stockRecycleLimit,
      );
      _initializeCreativeSession();
      _selected = null;
      _clearHint();
      _settled = false;
      _timeTrialExpired = false;
      _timeUpDialogShown = false;
    });
    _gameStartRecorded = false;
    _recordGameStart();
    _persist();
  }

  void _undo() {
    if (_timeTrialExpired || !_game.canUndo) return;
    var undone = false;
    setState(() {
      undone = _game.undo();
      _selected = null;
      _clearHint();
      if (undone) {
        _lastTreasureCount = _creative?.treasuresFound(_game.state) ?? 0;
      }
    });
    if (undone) _persist();
  }

  Future<void> _confirmNewDeal() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Restart?'),
        content: const Text(
          'Your current progress will be replaced by a new deal.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Restart'),
          ),
        ],
      ),
    );
    if (confirmed == true) _newDeal();
  }

  Future<void> _showPauseMenu() async {
    if (_game.state.completed || _timeTrialExpired || _shadowMemoryActive) {
      return;
    }
    if (widget.creativeMode == null) {
      await _storage?.saveGame(_game.state);
    }
    if (!mounted) return;
    setState(() => _paused = true);
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF173C25),
        title: const Text(
          'Game Paused',
          style: TextStyle(color: Color(0xFFFFE7A3)),
        ),
        content: const Text(
          'Your game is safe. Resume whenever you are ready.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Resume'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              _confirmNewDeal();
            },
            child: const Text('Restart'),
          ),
          FilledButton(
            onPressed: () async {
              final leave = await _confirmExit();
              if (leave && mounted) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              }
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
    if (mounted && !_game.state.completed) setState(() => _paused = false);
  }

  Future<void> _showTimeTrialExpired() async {
    if (!mounted || _timeUpDialogShown) return;
    _timeUpDialogShown = true;
    final retry = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF173C25),
        title: const Text(
          'Time Up',
          style: TextStyle(color: Color(0xFFFFE7A3)),
        ),
        content: const Text(
          'The countdown ended before the table was cleared.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Back'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    _timeUpDialogShown = false;
    if (retry == true) {
      _newDeal();
    } else {
      Navigator.pop(context);
    }
  }

  Future<void> _recordCreativePlay() async {
    final mode = widget.creativeMode;
    if (mode == null) return;
    final storage =
        _storage ?? GameStorage(await SharedPreferences.getInstance());
    final progress = (await storage.loadCreativeProgress()).recordPlay(mode);
    await storage.saveCreativeProgress(progress);
  }

  void _showHint() {
    if (_paused ||
        _timeTrialExpired ||
        _shadowMemoryActive ||
        _game.state.completed) {
      return;
    }
    _hintTimer?.cancel();
    final hint = _game.findHint();
    if (hint == null) {
      setState(_clearHint);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No more moves. Try Undo or Restart.')),
      );
      return;
    }
    setState(() => _hint = hint);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(_hintMessage(hint))));
    _hintTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _hint = null);
    });
  }

  String _hintMessage(SuggestedMove hint) {
    final cards = _cardsAt(hint.source);
    final card = cards == null || cards.isEmpty ? null : cards.first;
    final cardLabel = card == null ? 'the highlighted card' : _cardLabel(card);
    final destination = switch (hint.destination.type) {
      PileType.foundation => 'the foundation',
      PileType.tableau => 'the tableau',
      PileType.stock => 'the stock',
      PileType.waste => 'the waste',
    };
    return 'Move $cardLabel to $destination';
  }

  String _cardLabel(PlayingCard card) =>
      '${card.rank.label}${card.suit.symbol}';

  void _announceCreativeProgress() {
    final creative = _creative;
    if (creative == null) return;
    if (creative.jokerUnlocked(_game.state) && !_jokerRescueAnnounced) {
      _jokerRescueAnnounced = true;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('🃏 Joker Rescued!')));
    }
    final found = creative.treasuresFound(_game.state);
    if (found <= _lastTreasureCount) {
      _lastTreasureCount = found;
      return;
    }
    _lastTreasureCount = found;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Treasure found! $found/${creative.totalTreasures}'),
      ),
    );
  }

  void _clearHint() {
    _hintTimer?.cancel();
    _hintTimer = null;
    _hint = null;
  }

  Future<void> _checkForNoMoves() async {
    if (!mounted || _game.state.completed || _game.hasAvailableMove) return;
    final action = await showDialog<_DeadEndAction>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF173C25),
        title: const Text(
          'No More Moves',
          style: TextStyle(color: Color(0xFFFFE7A3)),
        ),
        content: const Text(
          'There are no legal moves left in this deal.',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, _DeadEndAction.close),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, _DeadEndAction.undo),
            child: const Text('Undo'),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialogContext, _DeadEndAction.restart),
            child: const Text('Restart'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    switch (action) {
      case _DeadEndAction.undo:
        _undo();
      case _DeadEndAction.restart:
        _newDeal();
      case _DeadEndAction.close:
      case null:
        break;
    }
  }

  Future<bool> _confirmExit() async =>
      await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Exit game?'),
          content: const Text(
            'Your progress is saved and can be resumed from the home screen.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Resume'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Exit'),
            ),
          ],
        ),
      ) ??
      false;

  @override
  Widget build(BuildContext context) {
    final selectedTheme = ThemeOption.byId(
      _progress?.selectedTheme ?? 'emerald',
    );
    return FeltScaffold(
      accent: Color(selectedTheme.tableColor),
      backgroundAsset: selectedTheme.backgroundAsset,
      child: Stack(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = ((constraints.maxWidth - 40) / 7).clamp(
                42.0,
                74.0,
              );
              final cardHeight = cardWidth * 1.42;
              return Column(
                children: [
                  _header(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                      child: Column(
                        children: [
                          if (widget.adventureTitle != null ||
                              widget.creativeMode != null)
                            _adventureTag(),
                          _topPiles(cardWidth),
                          const SizedBox(height: 18),
                          SizedBox(
                            height: 470,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                7,
                                (index) => Expanded(
                                  child: _tableau(index, cardWidth, cardHeight),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _actions(),
                ],
              );
            },
          ),
          if (_shadowMemoryActive) _shadowMemoryOverlay(),
        ],
      ),
    );
  }

  Widget _header() => Padding(
    padding: const EdgeInsets.fromLTRB(14, 8, 14, 2),
    child: Row(
      children: [
        IconButton(
          onPressed: _showPauseMenu,
          icon: const Icon(
            Icons.pause_circle_outline_rounded,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        _stat('Score', '$_score'),
        if (_creative?.isTimeTrial != true) _stat('Time', _timeLabel),
        _stat('Moves', '${_game.state.moves}'),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            '★' * _stars,
            style: const TextStyle(color: Color(0xFFFFD54D), fontSize: 16),
          ),
        ),
      ],
    ),
  );

  Widget _stat(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 9),
    child: Column(
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFFE9E2C1),
            fontSize: 11,
            letterSpacing: .6,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: 17,
          ),
        ),
      ],
    ),
  );

  Widget _adventureTag() => Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: GoldPanel(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.adventureTitle ??
                CreativeModeCatalog.forType(widget.creativeMode!).title,
            style: const TextStyle(
              color: Color(0xFFFFE7A3),
              fontWeight: FontWeight.bold,
            ),
          ),
          if (_creative != null) ...[
            const SizedBox(height: 6),
            _creativeStatus(),
          ],
        ],
      ),
    ),
  );

  Widget _creativeStatus() {
    switch (_creative!.mode) {
      case CreativeModeType.treasureHunt:
        return Row(
          children: [
            const Text(
              'Treasure',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              '🎁 $_lastTreasureCount / ${_creative!.totalTreasures}',
              style: const TextStyle(
                color: Color(0xFFFFE7A3),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        );
      case CreativeModeType.timeTrial:
        return Row(
          children: [
            const Text(
              'TIME',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: .6,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _timeLabel,
              style: const TextStyle(
                color: Color(0xFFFFE7A3),
                fontSize: 15,
                fontWeight: FontWeight.w800,
              ),
            ),
            const Spacer(),
            Text(
              'Best: $_bestTimeLabel',
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ],
        );
      case CreativeModeType.oneDrawSprint:
        return Row(
          children: [
            const Text(
              'Stock',
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '${_game.state.stock.length} cards left',
              style: const TextStyle(color: Color(0xFFFFE7A3), fontSize: 12),
            ),
            const Spacer(),
            const Text(
              'NO RECYCLE',
              style: TextStyle(
                color: Color(0xFFFFD454),
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: .5,
              ),
            ),
          ],
        );
      case CreativeModeType.jokerRescue:
        final rescued = _creative!.jokerUnlocked(_game.state);
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Text(
                  'Joker Status',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Text(
                  rescued ? '🃏 Joker Rescued!' : '🔒 Locked',
                  style: const TextStyle(
                    color: Color(0xFFFFE7A3),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              'Moves: ${_creative!.jokerMoves(_game.state)} / ${CreativeGameController.jokerUnlockMoves}',
              style: const TextStyle(color: Colors.white, fontSize: 11),
            ),
          ],
        );
      case CreativeModeType.shadowSolitaire:
        return const Text(
          'Memory phase complete',
          style: TextStyle(color: Color(0xFFFFE7A3), fontSize: 12),
        );
      case CreativeModeType.chainDeck:
        return const SizedBox.shrink();
    }
  }

  Widget _shadowMemoryOverlay() => Positioned.fill(
    key: const ValueKey('shadow-memory-overlay'),
    child: ColoredBox(
      color: Color(0xCC071A10),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: GoldPanel(
            color: const Color(0xFF173C25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Remember these cards',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFFFE7A3),
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 8,
                  children: [
                    for (final card in _shadowMemoryCards)
                      Text(
                        card,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  '$_shadowMemorySecondsRemaining',
                  style: const TextStyle(
                    color: Color(0xFFFFD454),
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _topPiles(double cardWidth) => Row(
    children: [
      KeyedSubtree(
        key: const ValueKey('stock-pile'),
        child: _target(
          const PileLocation(PileType.stock),
          _game.state.stock.isEmpty
              ? _emptySlot(cardWidth, Icons.replay_rounded)
              : GestureDetector(
                  onTap: _draw,
                  child: PlayingCardView(
                    card: const PlayingCard(
                      suit: Suit.clubs,
                      rank: Rank.ace,
                      isFaceUp: false,
                    ),
                    width: cardWidth,
                  ),
                ),
        ),
      ),
      const SizedBox(width: 8),
      _target(
        const PileLocation(PileType.waste),
        _game.state.waste.isEmpty
            ? _emptySlot(cardWidth, Icons.style_outlined)
            : _draggableCard(
                const PileLocation(PileType.waste),
                _game.state.waste.last,
                cardWidth,
              ),
      ),
      const Spacer(),
      for (var index = 0; index < 4; index++) ...[
        KeyedSubtree(
          key: ValueKey('foundation-$index'),
          child: _target(
            PileLocation(PileType.foundation, index: index),
            _game.state.foundations[Suit.values[index]]!.isEmpty
                ? _emptySlot(
                    cardWidth,
                    Icons.add,
                    symbol: Suit.values[index].symbol,
                  )
                : _draggableCard(
                    PileLocation(PileType.foundation, index: index),
                    _game.state.foundations[Suit.values[index]]!.last,
                    cardWidth,
                  ),
          ),
        ),
        if (index != 3) const SizedBox(width: 5),
      ],
    ],
  );

  Widget _tableau(int pileIndex, double width, double height) {
    final pile = _game.state.tableau[pileIndex];
    final target = PileLocation(PileType.tableau, index: pileIndex);
    return DragTarget<PileLocation>(
      onAcceptWithDetails: (details) => _handleDrop(details.data, target),
      builder: (context, candidates, _) => GestureDetector(
        onTap: () => _choose(target),
        child: Container(
          key: ValueKey('tableau-$pileIndex'),
          height: 455,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: candidates.isNotEmpty
                ? Border.all(color: const Color(0xFFF5D054), width: 2)
                : null,
          ),
          child: Stack(
            children: [
              if (pile.isEmpty)
                Positioned(
                  top: 0,
                  left: 3,
                  child: _emptySlot(width, Icons.add),
                ),
              for (var cardIndex = 0; cardIndex < pile.length; cardIndex++)
                Positioned(
                  top: cardIndex * (height * .22),
                  left: 3,
                  child: _draggableCard(
                    PileLocation(
                      PileType.tableau,
                      index: pileIndex,
                      cardIndex: cardIndex,
                    ),
                    pile[cardIndex],
                    width,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _target(PileLocation target, Widget child) => DragTarget<PileLocation>(
    onAcceptWithDetails: (details) => _handleDrop(details.data, target),
    builder: (context, candidates, _) => GestureDetector(
      onTap: () => _choose(target),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          boxShadow: candidates.isNotEmpty || _hint?.destination == target
              ? [const BoxShadow(color: Color(0xFFF9D862), blurRadius: 12)]
              : null,
        ),
        child: child,
      ),
    ),
  );

  Widget _draggableCard(PileLocation location, PlayingCard card, double width) {
    final selected =
        _selected == location || (_hint != null && _hint!.source == location);
    final view = PlayingCardView(card: card, width: width, selected: selected);
    if (!card.isFaceUp) {
      return GestureDetector(onTap: () => _choose(location), child: view);
    }
    return Draggable<PileLocation>(
      data: location,
      feedback: Material(
        color: Colors.transparent,
        child: Opacity(opacity: .86, child: view),
      ),
      childWhenDragging: Opacity(opacity: .18, child: view),
      child: GestureDetector(onTap: () => _choose(location), child: view),
    );
  }

  Widget _emptySlot(double width, IconData icon, {String? symbol}) => Container(
    width: width,
    height: width * 1.42,
    decoration: BoxDecoration(
      color: const Color(0xFF071B11).withValues(alpha: .36),
      borderRadius: BorderRadius.circular(7),
      border: Border.all(color: const Color(0xFFBDD18A).withValues(alpha: .33)),
    ),
    child: Center(
      child: symbol == null
          ? Icon(icon, color: const Color(0xFFB8C994).withValues(alpha: .55))
          : Text(
              symbol,
              style: TextStyle(
                fontSize: width * .48,
                color: const Color(0xFFB8C994).withValues(alpha: .55),
              ),
            ),
    ),
  );

  Widget _actions() => Padding(
    padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
    child: GoldPanel(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _action(Icons.lightbulb_rounded, 'Hint', _showHint),
          _action(
            Icons.undo_rounded,
            'Undo',
            _game.canUndo ? _undo : null,
            detail: 'Remaining: ${_game.historyCount}',
          ),
          _action(Icons.refresh_rounded, 'New Deal', _confirmNewDeal),
        ],
      ),
    ),
  );

  Widget _action(
    IconData icon,
    String label,
    VoidCallback? onTap, {
    String? detail,
  }) => InkWell(
    key: label == 'Undo' ? const ValueKey('undo-action') : null,
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: onTap == null
                ? const Color(0xFFFFD454).withValues(alpha: .3)
                : const Color(0xFFFFD454),
            size: 29,
          ),
          Text(
            label,
            style: TextStyle(
              color: onTap == null ? Colors.white38 : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (detail != null)
            Text(
              detail,
              style: const TextStyle(
                color: Color(0xFFBFCDB1),
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    ),
  );
}
