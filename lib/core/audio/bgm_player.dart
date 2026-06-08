import 'dart:async';

import 'package:just_audio/just_audio.dart';

/// BGM 播放器
///
/// 基于 just_audio 实现的背景音乐播放器，支持播放/暂停/停止、
/// 淡入淡出、场景切换（渐出当前 BGM，渐入新 BGM）、循环播放和音量控制。
///
/// 音频资源路径约定：`assets/audio/bgm/`
///
/// 使用方式：
/// ```dart
/// final bgmPlayer = BgmPlayer();
/// await bgmPlayer.play('assets/audio/bgm/main_theme.mp3');
/// await bgmPlayer.crossfadeTo('assets/audio/bgm/battle.mp3');
/// ```
class BgmPlayer {
  /// just_audio 播放器实例
  final AudioPlayer _player = AudioPlayer();

  /// 淡入淡出动画器
  AudioFade _fade = AudioFade.idle;

  /// 当前播放的音频路径
  String? _currentSource;

  /// 音量（0.0 ~ 1.0）
  double _volume = 0.7;

  /// 是否循环播放（默认循环）
  bool _looping = true;

  /// 播放状态流
  Stream<PlayerState> get playerStateStream => _player.playerStateStream;

  /// 当前播放状态
  PlayerState? get playerState => _player.playerState;

  /// 是否正在播放
  bool get isPlaying => _player.playing;

  /// 当前音频路径
  String? get currentSource => _currentSource;

  /// 当前音量
  double get volume => _volume;

  /// 播放位置流
  Stream<Duration> get positionStream => _player.positionStream;

  /// 总时长流
  Stream<Duration?> get durationStream => _player.durationStream;

  /// 播放 BGM
  ///
  /// [source] 音频资源路径，如 `assets/audio/bgm/main_theme.mp3`
  /// [volume] 音量（0.0 ~ 1.0），默认使用当前音量
  /// [looping] 是否循环播放，默认 true
  Future<void> play(
    String source, {
    double? volume,
    bool? looping,
  }) async {
    _volume = volume ?? _volume;
    _looping = looping ?? _looping;

    try {
      await _player.setAsset(source);
      await _player.setVolume(_volume);
      await _player.setLoopMode(_looping ? LoopMode.one : LoopMode.off);
      _currentSource = source;
      await _player.play();
    } catch (e) {
      _currentSource = null;
      // BGM 加载失败不影响游戏运行，仅打印警告
      _logWarning('BGM 播放失败: $source, 错误: $e');
    }
  }

  /// 淡入播放 BGM
  ///
  /// 从静音渐变到目标音量，营造平滑的入场效果。
  ///
  /// [source] 音频资源路径
  /// [duration] 淡入时长，默认 2 秒
  /// [targetVolume] 目标音量，默认使用当前音量
  Future<void> fadeIn(
    String source, {
    Duration duration = const Duration(seconds: 2),
    double? targetVolume,
    bool looping = true,
  }) async {
    _looping = looping;
    final target = targetVolume ?? _volume;

    try {
      await _player.setAsset(source);
      await _player.setVolume(0.0);
      await _player.setLoopMode(_looping ? LoopMode.one : LoopMode.off);
      _currentSource = source;
      await _player.play();
      await _animateVolume(from: 0.0, to: target, duration: duration);
    } catch (e) {
      _currentSource = null;
      _logWarning('BGM 淡入播放失败: $source, 错误: $e');
    }
  }

  /// 淡出当前 BGM
  ///
  /// 从当前音量渐变到静音，然后停止播放。
  ///
  /// [duration] 淡出时长，默认 2 秒
  Future<void> fadeOut({Duration duration = const Duration(seconds: 2)}) async {
    if (!isPlaying) return;

    await _animateVolume(from: _player.volume, to: 0.0, duration: duration);
    await _player.stop();
  }

  /// 场景切换：当前 BGM 渐出，新 BGM 渐入
  ///
  /// 用于场景过渡时平滑切换背景音乐，例如从主城切换到战场。
  ///
  /// [newSource] 新 BGM 音频路径
  /// [fadeOutDuration] 渐出时长，默认 1.5 秒
  /// [fadeInDuration] 渐入时长，默认 1.5 秒
  /// [targetVolume] 新 BGM 目标音量
  Future<void> crossfadeTo(
    String newSource, {
    Duration fadeOutDuration = const Duration(milliseconds: 1500),
    Duration fadeInDuration = const Duration(milliseconds: 1500),
    double? targetVolume,
  }) async {
    if (_currentSource == newSource) return;

    // 如果当前正在播放，先淡出
    if (isPlaying) {
      await _animateVolume(
        from: _player.volume,
        to: 0.0,
        duration: fadeOutDuration,
      );
      await _player.stop();
    }

    // 淡入新 BGM
    await fadeIn(
      newSource,
      duration: fadeInDuration,
      targetVolume: targetVolume ?? _volume,
      looping: _looping,
    );
  }

  /// 暂停播放
  Future<void> pause() async {
    await _player.pause();
  }

  /// 恢复播放
  Future<void> resume() async {
    if (_player.playerState.processingState != ProcessingState.idle) {
      await _player.play();
    }
  }

  /// 停止播放
  Future<void> stop() async {
    await _player.stop();
    _currentSource = null;
  }

  /// 设置音量（0.0 ~ 1.0）
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _player.setVolume(_volume);
  }

  /// 设置循环模式
  Future<void> setLooping(bool looping) async {
    _looping = looping;
    await _player.setLoopMode(_looping ? LoopMode.one : LoopMode.off);
  }

  /// 寻道到指定位置
  Future<void> seek(Duration position) async {
    await _player.seek(position);
  }

  /// 音量渐变动画
  ///
  /// 在 [duration] 时间内将音量从 [from] 线性渐变到 [to]。
  Future<void> _animateVolume({
    required double from,
    required double to,
    required Duration duration,
  }) async {
    _fade = AudioFade.active;
    const steps = 20;
    final stepDuration = duration.inMilliseconds ~/ steps;
    final volumeStep = (to - from) / steps;

    for (int i = 1; i <= steps; i++) {
      if (_fade != AudioFade.active) break;
      final newVolume = (from + volumeStep * i).clamp(0.0, 1.0);
      await _player.setVolume(newVolume);
      await Future<void>.delayed(Duration(milliseconds: stepDuration));
    }

    _fade = AudioFade.idle;
  }

  /// 取消淡入淡出动画
  void cancelFade() {
    _fade = AudioFade.cancelled;
  }

  /// 释放资源
  Future<void> dispose() async {
    cancelFade();
    await _player.dispose();
    _currentSource = null;
  }

  /// 打印警告日志（内部使用）
  void _logWarning(String message) {
    // ignore: avoid_print
    print('[BgmPlayer] $message');
  }
}

/// 淡入淡出动画状态
enum AudioFade {
  /// 空闲
  idle,

  /// 动画进行中
  active,

  /// 已取消
  cancelled,
}
