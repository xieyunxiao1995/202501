import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/creative/creative_progress.dart';
import '../../features/home/home_controller.dart';
import '../../features/solitaire/models/game_state.dart';

class GameStorage {
  GameStorage(this._preferences);

  static const _gameKey = 'solitaire.active_game';
  static const _progressKey = 'solitaire.progress';
  static const _creativeProgressKey = 'solitaire.creative';
  final SharedPreferences _preferences;

  Future<void> saveGame(SolitaireGameState state) async {
    await _preferences.setString(_gameKey, jsonEncode(state.toJson()));
  }

  Future<SavedGameLoadResult> loadGameResult() async {
    final raw = _preferences.getString(_gameKey);
    if (raw == null) return const SavedGameLoadResult.empty();
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return SavedGameLoadResult.restored(SolitaireGameState.fromJson(decoded));
    } catch (_) {
      return const SavedGameLoadResult.failed();
    }
  }

  Future<SolitaireGameState?> loadGame() async =>
      (await loadGameResult()).state;

  Future<bool> hasActiveGame() async => (await loadGameResult()).state != null;

  Future<void> clearActiveGame() async {
    await _preferences.remove(_gameKey);
  }

  Future<void> saveProgress(PlayerProgress progress) async {
    await _preferences.setString(_progressKey, jsonEncode(progress.toJson()));
  }

  Future<PlayerProgress> loadProgress() async {
    final raw = _preferences.getString(_progressKey);
    if (raw == null) return PlayerProgress.initial();
    try {
      return PlayerProgress.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      await _preferences.remove(_progressKey);
      return PlayerProgress.initial();
    }
  }

  Future<void> saveCreativeProgress(CreativeProgress progress) async {
    await _preferences.setString(
      _creativeProgressKey,
      jsonEncode(progress.toJson()),
    );
  }

  Future<CreativeProgress> loadCreativeProgress() async {
    final raw = _preferences.getString(_creativeProgressKey);
    if (raw == null) return CreativeProgress.initial();
    try {
      return CreativeProgress.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      await _preferences.remove(_creativeProgressKey);
      return CreativeProgress.initial();
    }
  }
}

class SavedGameLoadResult {
  const SavedGameLoadResult._({this.state, required this.failed});

  const SavedGameLoadResult.empty() : this._(failed: false);

  const SavedGameLoadResult.failed() : this._(failed: true);

  SavedGameLoadResult.restored(SolitaireGameState state)
    : this._(state: state, failed: false);

  final SolitaireGameState? state;
  final bool failed;
}
