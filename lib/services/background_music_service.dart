import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 背景音乐播放服务
/// 支持播放、暂停、切换曲目、循环播放，并在 iOS 上支持后台播放
class BackgroundMusicService extends ChangeNotifier {
  static final BackgroundMusicService _instance = BackgroundMusicService._internal();
  factory BackgroundMusicService() => _instance;
  BackgroundMusicService._internal();

  final AudioPlayer _player = AudioPlayer();

  /// 所有可用的背景音乐（assets/mp3 目录下的文件）
  static const List<String> _tracks = [
    'Autumn_Glow',
    'Dawn_Whisper',
    'Desert_Wind',
    'Forest_Deep',
    'Ocean_Gaze',
    'Petal_Drift',
    'Rain_Path',
    'Snow_Silence',
    'Starfall',
    'Summer_Night',
    'Tide_Moon',
    'Winter_Fire',
  ];

  static const String _enabledKey = 'bgm_enabled';
  static const String _trackIndexKey = 'bgm_track_index';
  static const String _volumeKey = 'bgm_volume';

  int _currentIndex = 0;
  double _volume = 0.5;
  bool _enabled = false;
  bool _isPlaying = false;
  bool _initialized = false;

  /// 当前曲目名称
  String get currentTrack => _tracks[_currentIndex];

  /// 所有曲目列表
  List<String> get tracks => List.unmodifiable(_tracks);

  /// 当前曲目索引
  int get currentIndex => _currentIndex;

  /// 是否启用背景音乐
  bool get enabled => _enabled;

  /// 是否正在播放
  bool get isPlaying => _isPlaying;

  /// 当前音量 (0.0 ~ 1.0)
  double get volume => _volume;

  /// 初始化服务，从本地存储恢复状态
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool(_enabledKey) ?? false;
    _currentIndex = prefs.getInt(_trackIndexKey) ?? 0;
    _volume = prefs.getDouble(_volumeKey) ?? 0.5;

    if (_currentIndex >= _tracks.length) _currentIndex = 0;

    _player.setVolume(_volume);

    // 监听播放状态
    _player.playingStream.listen((playing) {
      _isPlaying = playing;
      notifyListeners();
    });

    // 监听播放完成，自动播放下一首
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _playNext();
      }
    });

    if (_enabled) {
      await _loadAndPlay();
    }

    notifyListeners();
  }

  /// 切换启用/禁用状态
  Future<void> toggleEnabled() async {
    _enabled = !_enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_enabledKey, _enabled);

    if (_enabled) {
      await _loadAndPlay();
    } else {
      await _player.stop();
    }
    notifyListeners();
  }

  /// 播放/暂停
  Future<void> togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      if (!_enabled) {
        _enabled = true;
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool(_enabledKey, true);
      }
      if (_player.audioSource == null) {
        await _loadAndPlay();
      } else {
        await _player.play();
      }
    }
    notifyListeners();
  }

  /// 切换到指定曲目
  Future<void> selectTrack(int index) async {
    if (index < 0 || index >= _tracks.length) return;
    _currentIndex = index;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_trackIndexKey, _currentIndex);

    if (_enabled) {
      await _loadAndPlay();
    }
    notifyListeners();
  }

  /// 播放下一首
  Future<void> _playNext() async {
    _currentIndex = (_currentIndex + 1) % _tracks.length;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_trackIndexKey, _currentIndex);
    await _loadAndPlay();
    notifyListeners();
  }

  /// 设置音量
  Future<void> setVolume(double value) async {
    _volume = value.clamp(0.0, 1.0);
    await _player.setVolume(_volume);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_volumeKey, _volume);
    notifyListeners();
  }

  /// 加载并播放当前曲目
  Future<void> _loadAndPlay() async {
    try {
      await _player.setAsset('assets/mp3/${_tracks[_currentIndex]}.mp3');
      await _player.play();
    } catch (e) {
      debugPrint('背景音乐加载失败: $e');
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}
