import 'ambient_player.dart';
import 'audio_settings.dart';
import 'bgm_player.dart';
import 'sfx_player.dart';
import 'voice_player.dart';

/// 音频管理器，统一管理 BGM、SFX、Voice、Ambient 播放器
///
/// 作为音频子系统的总入口，协调各类音频播放器，
/// 提供初始化、暂停、恢复、释放等统一接口。
///
/// 使用方式：
/// ```dart
/// final audioManager = AudioManager(
///   bgmPlayer: BgmPlayer(),
///   sfxPlayer: SfxPlayer(),
///   voicePlayer: VoicePlayer(),
///   ambientPlayer: AmbientPlayer(),
///   settings: AudioSettings(prefs: sharedPreferences),
/// );
/// await audioManager.init();
/// ```
class AudioManager {
  /// 创建音频管理器
  AudioManager({
    required this.bgmPlayer,
    required this.sfxPlayer,
    required this.voicePlayer,
    required this.ambientPlayer,
    required this.settings,
  });

  /// BGM 播放器
  final BgmPlayer bgmPlayer;

  /// SFX 音效播放器
  final SfxPlayer sfxPlayer;

  /// 武将语音播放器
  final VoicePlayer voicePlayer;

  /// 环境音播放器
  final AmbientPlayer ambientPlayer;

  /// 音频设置
  final AudioSettings settings;

  /// 是否已初始化
  bool _initialized = false;

  /// 是否已暂停（应用切到后台时）
  bool _paused = false;

  /// 是否已初始化
  bool get isInitialized => _initialized;

  /// 是否处于暂停状态
  bool get isPaused => _paused;

  /// 初始化所有播放器
  ///
  /// 按顺序初始化各播放器，加载音频设置，
  /// 并监听设置变化实时更新各播放器音量。
  Future<void> init() async {
    if (_initialized) return;

    // 加载持久化的音频设置
    await settings.load();

    // 初始化 SFX 通道池
    await sfxPlayer.init();

    // 初始化语音播放器
    await voicePlayer.init();

    // 应用音频设置到各播放器
    await _applySettings();

    // 监听设置变化，实时更新播放器音量
    settings.bgmVolumeNotifier.addListener(_onBgmVolumeChanged);
    settings.sfxVolumeNotifier.addListener(_onSfxVolumeChanged);
    settings.voiceVolumeNotifier.addListener(_onVoiceVolumeChanged);
    settings.ambientVolumeNotifier.addListener(_onAmbientVolumeChanged);
    settings.isMutedNotifier.addListener(_onMutedChanged);

    _initialized = true;
  }

  /// 应用当前音频设置到所有播放器
  Future<void> _applySettings() async {
    await bgmPlayer.setVolume(settings.getEffectiveBgmVolume());
    await sfxPlayer.setVolume(settings.getEffectiveSfxVolume());
    await voicePlayer.setVolume(settings.getEffectiveVoiceVolume());
    await ambientPlayer.setVolume(settings.getEffectiveAmbientVolume());
  }

  /// BGM 音量变化回调
  void _onBgmVolumeChanged() {
    bgmPlayer.setVolume(settings.getEffectiveBgmVolume());
  }

  /// SFX 音量变化回调
  void _onSfxVolumeChanged() {
    sfxPlayer.setVolume(settings.getEffectiveSfxVolume());
  }

  /// 语音音量变化回调
  void _onVoiceVolumeChanged() {
    voicePlayer.setVolume(settings.getEffectiveVoiceVolume());
  }

  /// 环境音音量变化回调
  void _onAmbientVolumeChanged() {
    ambientPlayer.setVolume(settings.getEffectiveAmbientVolume());
  }

  /// 静音状态变化回调
  void _onMutedChanged() {
    _applySettings();
  }

  /// 暂停所有音频
  ///
  /// 通常在应用切到后台时调用。
  Future<void> pauseAll() async {
    if (_paused) return;
    _paused = true;

    await bgmPlayer.pause();
    await sfxPlayer.stopAll();
    await voicePlayer.stop();
    await ambientPlayer.pause();
  }

  /// 恢复所有音频
  ///
  /// 通常在应用回到前台时调用。
  /// 仅恢复 BGM 和环境音，SFX 和语音不自动恢复。
  Future<void> resumeAll() async {
    if (!_paused) return;
    _paused = false;

    await bgmPlayer.resume();
    await ambientPlayer.resume();
  }

  /// 释放所有资源
  ///
  /// 在应用退出时调用，释放所有播放器和设置监听器。
  Future<void> dispose() async {
    settings.bgmVolumeNotifier.removeListener(_onBgmVolumeChanged);
    settings.sfxVolumeNotifier.removeListener(_onSfxVolumeChanged);
    settings.voiceVolumeNotifier.removeListener(_onVoiceVolumeChanged);
    settings.ambientVolumeNotifier.removeListener(_onAmbientVolumeChanged);
    settings.isMutedNotifier.removeListener(_onMutedChanged);

    await bgmPlayer.dispose();
    await sfxPlayer.dispose();
    await voicePlayer.dispose();
    await ambientPlayer.dispose();
    settings.dispose();

    _initialized = false;
  }
}
