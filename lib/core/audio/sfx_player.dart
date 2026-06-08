import 'package:audioplayers/audioplayers.dart';

/// SFX 音效播放器
///
/// 基于 audioplayers 实现的音效播放器，支持多通道并发播放。
/// 适用于短音效，如兵器碰撞、马蹄声、战鼓、UI 点击音效等。
///
/// 音频资源路径约定：`assets/audio/sfx/`
///
/// 使用方式：
/// ```dart
/// final sfxPlayer = SfxPlayer();
/// await sfxPlayer.play('assets/audio/sfx/sword_clash.mp3');
/// await sfxPlayer.play('assets/audio/sfx/horse_gallop.mp3'); // 可同时播放
/// ```
class SfxPlayer {
  /// 最大并发通道数
  static const int _maxChannels = 8;

  /// 音效播放器通道池
  final List<AudioPlayer> _channels = [];

  /// 当前活跃的通道索引映射（音效路径 -> 通道）
  final Map<String, AudioPlayer> _activeSounds = {};

  /// 音量（0.0 ~ 1.0）
  double _volume = 1.0;

  /// 当前音量
  double get volume => _volume;

  /// 初始化通道池
  ///
  /// 预先创建 [_maxChannels] 个 [AudioPlayer] 实例，
  /// 避免播放音效时创建开销。
  Future<void> init() async {
    for (int i = 0; i < _maxChannels; i++) {
      final player = AudioPlayer(playerId: 'sfx_channel_$i');
      _channels.add(player);
    }
  }

  /// 播放短音效
  ///
  /// [source] 音频资源路径，如 `assets/audio/sfx/sword_clash.mp3`
  /// [volume] 本次播放音量，不传则使用全局音量
  ///
  /// 音效会自动寻找空闲通道播放，如果所有通道都在使用中，
  /// 则复用最早完成的通道。
  Future<void> play(String source, {double? volume}) async {
    final playVolume = (volume ?? _volume).clamp(0.0, 1.0);

    // 清理已完成的音效
    _cleanupFinished();

    // 查找空闲通道
    final channel = _findFreeChannel();
    if (channel == null) {
      // 所有通道都在使用，强制停止最旧的音效
      if (_activeSounds.isNotEmpty) {
        final oldestKey = _activeSounds.keys.first;
        final oldestPlayer = _activeSounds.remove(oldestKey);
        await oldestPlayer?.stop();
        if (oldestPlayer != null) {
          _playOnChannel(oldestPlayer, source, playVolume);
          _activeSounds[source] = oldestPlayer;
        }
      }
      return;
    }

    _playOnChannel(channel, source, playVolume);
    _activeSounds[source] = channel;
  }

  /// 在指定通道上播放音效
  Future<void> _playOnChannel(AudioPlayer channel, String source, double volume) async {
    try {
      await channel.setVolume(volume);
      await channel.play(AssetSource(source.replaceFirst('assets/', '')));
    } catch (e) {
      _logWarning('SFX 播放失败: $source, 错误: $e');
    }
  }

  /// 停止指定音效
  ///
  /// [source] 要停止的音效资源路径
  Future<void> stop(String source) async {
    final player = _activeSounds.remove(source);
    await player?.stop();
  }

  /// 停止所有音效
  Future<void> stopAll() async {
    for (final player in _activeSounds.values) {
      await player.stop();
    }
    _activeSounds.clear();
  }

  /// 设置全局音量（0.0 ~ 1.0）
  ///
  /// 影响后续播放的音效，不会影响正在播放的音效。
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    // 同时更新所有活跃通道的音量
    for (final player in _activeSounds.values) {
      await player.setVolume(_volume);
    }
  }

  /// 查找空闲通道
  AudioPlayer? _findFreeChannel() {
    final activePlayers = _activeSounds.values.toSet();
    for (final channel in _channels) {
      if (!activePlayers.contains(channel)) {
        return channel;
      }
    }
    return null;
  }

  /// 清理已完成的音效映射
  void _cleanupFinished() {
    _activeSounds.removeWhere((source, player) {
      return player.state == PlayerState.completed ||
          player.state == PlayerState.stopped;
    });
  }

  /// 释放所有资源
  Future<void> dispose() async {
    await stopAll();
    for (final channel in _channels) {
      await channel.dispose();
    }
    _channels.clear();
  }

  /// 打印警告日志（内部使用）
  void _logWarning(String message) {
    // ignore: avoid_print
    print('[SfxPlayer] $message');
  }
}
