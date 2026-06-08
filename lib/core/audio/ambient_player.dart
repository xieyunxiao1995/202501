import 'dart:async';

import 'package:just_audio/just_audio.dart';

/// 环境音播放器
///
/// 基于 just_audio 实现的环境音播放器，支持循环播放、淡入淡出和音量控制。
/// 适用于战场氛围、风声、马嘶、雨声等持续性环境音效。
///
/// 音频资源路径约定：`assets/audio/ambient/`
///
/// 使用方式：
/// ```dart
/// final ambientPlayer = AmbientPlayer();
/// await ambientPlayer.play('assets/audio/ambient/battlefield.mp3');
/// await ambientPlayer.crossfadeTo('assets/audio/ambient/rain.mp3');
/// ```
class AmbientPlayer {
  /// just_audio 播放器实例
  final AudioPlayer _player = AudioPlayer();

  /// 当前播放的音频路径
  String? _currentSource;

  /// 音量（0.0 ~ 1.0）
  double _volume = 0.5;

  /// 是否循环播放
  bool _looping = true;

  /// 淡入淡出动画状态
  _FadeState _fadeState = _FadeState.idle;

  /// 当前音频路径
  String? get currentSource => _currentSource;

  /// 当前音量
  double get volume => _volume;

  /// 是否正在播放
  bool get isPlaying => _player.playing;

  /// 播放环境音
  ///
  /// [source] 音频资源路径，如 `assets/audio/ambient/battlefield.mp3`
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
      _logWarning('环境音播放失败: $source, 错误: $e');
    }
  }

  /// 淡入播放环境音
  ///
  /// 从静音渐变到目标音量，营造平滑的入场效果。
  ///
  /// [source] 音频资源路径
  /// [duration] 淡入时长，默认 3 秒
  /// [targetVolume] 目标音量，默认使用当前音量
  Future<void> fadeIn(
    String source, {
    Duration duration = const Duration(seconds: 3),
    double? targetVolume,
  }) async {
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
      _logWarning('环境音淡入播放失败: $source, 错误: $e');
    }
  }

  /// 淡出当前环境音
  ///
  /// [duration] 淡出时长，默认 3 秒
  Future<void> fadeOut({Duration duration = const Duration(seconds: 3)}) async {
    if (!isPlaying) return;

    await _animateVolume(from: _player.volume, to: 0.0, duration: duration);
    await _player.stop();
  }

  /// 场景切换：当前环境音渐出，新环境音渐入
  ///
  /// 用于场景过渡时平滑切换环境音，例如从战场切换到城池。
  ///
  /// [newSource] 新环境音音频路径
  /// [fadeOutDuration] 渐出时长，默认 2 秒
  /// [fadeInDuration] 渐入时长，默认 2 秒
  Future<void> crossfadeTo(
    String newSource, {
    Duration fadeOutDuration = const Duration(seconds: 2),
    Duration fadeInDuration = const Duration(seconds: 2),
  }) async {
    if (_currentSource == newSource) return;

    // 先淡出当前环境音
    if (isPlaying) {
      await _animateVolume(
        from: _player.volume,
        to: 0.0,
        duration: fadeOutDuration,
      );
      await _player.stop();
    }

    // 淡入新环境音
    await fadeIn(newSource, duration: fadeInDuration, targetVolume: _volume);
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

  /// 音量渐变动画
  Future<void> _animateVolume({
    required double from,
    required double to,
    required Duration duration,
  }) async {
    _fadeState = _FadeState.active;
    const steps = 20;
    final stepDuration = duration.inMilliseconds ~/ steps;
    final volumeStep = (to - from) / steps;

    for (int i = 1; i <= steps; i++) {
      if (_fadeState != _FadeState.active) break;
      final newVolume = (from + volumeStep * i).clamp(0.0, 1.0);
      await _player.setVolume(newVolume);
      await Future<void>.delayed(Duration(milliseconds: stepDuration));
    }

    _fadeState = _FadeState.idle;
  }

  /// 取消淡入淡出动画
  void cancelFade() {
    _fadeState = _FadeState.cancelled;
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
    print('[AmbientPlayer] $message');
  }
}

/// 淡入淡出动画状态
enum _FadeState {
  /// 空闲
  idle,

  /// 动画进行中
  active,

  /// 已取消
  cancelled,
}
