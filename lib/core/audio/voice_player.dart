import 'dart:async';
import 'dart:collection';

import 'package:audioplayers/audioplayers.dart';

/// 语音优先级
///
/// 数值越大优先级越高，高优先级语音会打断低优先级语音。
enum VoicePriority {
  /// 剧情语音
  story(0),

  /// 战斗语音
  battle(1),

  /// 大招语音（最高优先级）
  ultimate(2);

  const VoicePriority(this.value);

  /// 优先级数值
  final int value;
}

/// 语音请求
class _VoiceRequest {
  _VoiceRequest({
    required this.generalId,
    required this.source,
    required this.priority,
  });

  /// 武将 ID
  final String generalId;

  /// 音频资源路径
  final String source;

  /// 优先级
  final VoicePriority priority;
}

/// 武将语音播放器
///
/// 按武将 ID 播放语音，支持优先级队列。
/// 大招语音 > 战斗语音 > 剧情语音，高优先级语音会打断低优先级语音。
///
/// 音频资源路径约定：`assets/audio/voice/{generalId}/`
///
/// 使用方式：
/// ```dart
/// final voicePlayer = VoicePlayer();
/// await voicePlayer.playVoice('guanyu', 'assets/audio/voice/guanyu/ultimate.mp3',
///     priority: VoicePriority.ultimate);
/// ```
class VoicePlayer {
  /// 播放器实例
  final AudioPlayer _player = AudioPlayer(playerId: 'voice_player');

  /// 语音优先级队列
  final Queue<_VoiceRequest> _queue = Queue<_VoiceRequest>();

  /// 当前正在播放的语音请求
  _VoiceRequest? _currentRequest;

  /// 当前播放的优先级
  VoicePriority? _currentPriority;

  /// 音量（0.0 ~ 1.0）
  double _volume = 1.0;

  /// 是否正在播放
  bool _isPlaying = false;

  /// 播放完成监听
  StreamSubscription? _onCompleteSubscription;

  /// 当前音量
  double get volume => _volume;

  /// 是否正在播放
  bool get isPlaying => _isPlaying;

  /// 当前播放的武将 ID
  String? get currentGeneralId => _currentRequest?.generalId;

  /// 当前播放的优先级
  VoicePriority? get currentPriority => _currentPriority;

  /// 初始化播放器
  Future<void> init() async {
    _onCompleteSubscription = _player.onPlayerComplete.listen((_) {
      _onPlayComplete();
    });
  }

  /// 播放武将语音
  ///
  /// [generalId] 武将 ID，如 `guanyu`、`zhaoyun`
  /// [source] 音频资源路径，如 `assets/audio/voice/guanyu/ultimate.mp3`
  /// [priority] 语音优先级，默认剧情语音
  ///
  /// 如果当前正在播放低优先级语音，会被打断并加入新语音。
  /// 如果当前正在播放同优先级或更高优先级语音，新语音加入队列。
  Future<void> playVoice(
    String generalId,
    String source, {
    VoicePriority priority = VoicePriority.story,
  }) async {
    final request = _VoiceRequest(
      generalId: generalId,
      source: source,
      priority: priority,
    );

    if (!_isPlaying) {
      // 当前没有播放，直接播放
      await _play(request);
    } else if (_currentPriority != null &&
        priority.value > _currentPriority!.value) {
      // 新语音优先级更高，打断当前语音
      await _interruptAndPlay(request);
    } else {
      // 新语音优先级不高于当前，加入队列
      _enqueue(request);
    }
  }

  /// 停止当前语音
  Future<void> stop() async {
    await _player.stop();
    _currentRequest = null;
    _currentPriority = null;
    _isPlaying = false;
  }

  /// 停止所有语音（包括队列）
  Future<void> stopAll() async {
    await stop();
    _queue.clear();
  }

  /// 设置音量（0.0 ~ 1.0）
  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _player.setVolume(_volume);
  }

  /// 跳过当前语音，播放队列中下一条
  Future<void> skip() async {
    await stop();
    await _playNext();
  }

  /// 队列中等待播放的数量
  int get queueLength => _queue.length;

  /// 清空等待队列
  void clearQueue() {
    _queue.clear();
  }

  /// 将请求加入优先级队列
  void _enqueue(_VoiceRequest request) {
    _queue.add(request);
    // 按优先级排序，高优先级在前
    final list = _queue.toList()
      ..sort((a, b) => b.priority.value.compareTo(a.priority.value));
    _queue.clear();
    _queue.addAll(list);
  }

  /// 直接播放语音请求
  Future<void> _play(_VoiceRequest request) async {
    try {
      _currentRequest = request;
      _currentPriority = request.priority;
      _isPlaying = true;
      await _player.setVolume(_volume);
      await _player.play(AssetSource(request.source.replaceFirst('assets/', '')));
    } catch (e) {
      _isPlaying = false;
      _currentRequest = null;
      _currentPriority = null;
      _logWarning('语音播放失败: ${request.source}, 错误: $e');
      // 播放失败，尝试下一条
      await _playNext();
    }
  }

  /// 打断当前语音，播放新语音
  Future<void> _interruptAndPlay(_VoiceRequest request) async {
    // 将当前语音重新入队（降低优先级）
    if (_currentRequest != null) {
      _enqueue(_currentRequest!);
    }
    await _player.stop();
    _isPlaying = false;
    await _play(request);
  }

  /// 播放完成回调
  void _onPlayComplete() {
    _currentRequest = null;
    _currentPriority = null;
    _isPlaying = false;
    _playNext();
  }

  /// 播放下一条队列中的语音
  Future<void> _playNext() async {
    if (_queue.isEmpty) return;
    final next = _queue.removeFirst();
    await _play(next);
  }

  /// 释放资源
  Future<void> dispose() async {
    await _onCompleteSubscription?.cancel();
    await _player.dispose();
    _queue.clear();
    _currentRequest = null;
    _currentPriority = null;
    _isPlaying = false;
  }

  /// 打印警告日志（内部使用）
  void _logWarning(String message) {
    // ignore: avoid_print
    print('[VoicePlayer] $message');
  }
}
