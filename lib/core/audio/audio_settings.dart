import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 音频设置键名常量
class _AudioSettingsKeys {
  static const String bgmVolume = 'audio_bgm_volume';
  static const String sfxVolume = 'audio_sfx_volume';
  static const String voiceVolume = 'audio_voice_volume';
  static const String ambientVolume = 'audio_ambient_volume';
  static const String isMuted = 'audio_is_muted';
}

/// 音频设置管理
///
/// 管理各类音频的音量、静音开关，并通过 [SharedPreferences] 持久化。
/// 使用 [ValueNotifier] 监听音量变化，UI 层可监听实时更新。
///
/// 使用方式：
/// ```dart
/// final settings = AudioSettings(prefs: sharedPreferences);
/// await settings.load();
/// settings.bgmVolumeNotifier.addListener(() { ... });
/// settings.setBgmVolume(0.8);
/// ```
class AudioSettings {
  /// 创建音频设置
  AudioSettings({required SharedPreferences prefs})
      : _prefs = prefs,
        bgmVolumeNotifier = ValueNotifier(prefs.getDouble(_AudioSettingsKeys.bgmVolume) ?? 0.7),
        sfxVolumeNotifier = ValueNotifier(prefs.getDouble(_AudioSettingsKeys.sfxVolume) ?? 1.0),
        voiceVolumeNotifier = ValueNotifier(prefs.getDouble(_AudioSettingsKeys.voiceVolume) ?? 1.0),
        ambientVolumeNotifier = ValueNotifier(prefs.getDouble(_AudioSettingsKeys.ambientVolume) ?? 0.5),
        isMutedNotifier = ValueNotifier(prefs.getBool(_AudioSettingsKeys.isMuted) ?? false);

  final SharedPreferences _prefs;

  /// BGM 音量监听器（0.0 ~ 1.0）
  final ValueNotifier<double> bgmVolumeNotifier;

  /// SFX 音量监听器（0.0 ~ 1.0）
  final ValueNotifier<double> sfxVolumeNotifier;

  /// 语音音量监听器（0.0 ~ 1.0）
  final ValueNotifier<double> voiceVolumeNotifier;

  /// 环境音音量监听器（0.0 ~ 1.0）
  final ValueNotifier<double> ambientVolumeNotifier;

  /// 总静音开关监听器
  final ValueNotifier<bool> isMutedNotifier;

  /// 从 SharedPreferences 加载设置
  Future<void> load() async {
    bgmVolumeNotifier.value = _prefs.getDouble(_AudioSettingsKeys.bgmVolume) ?? 0.7;
    sfxVolumeNotifier.value = _prefs.getDouble(_AudioSettingsKeys.sfxVolume) ?? 1.0;
    voiceVolumeNotifier.value = _prefs.getDouble(_AudioSettingsKeys.voiceVolume) ?? 1.0;
    ambientVolumeNotifier.value = _prefs.getDouble(_AudioSettingsKeys.ambientVolume) ?? 0.5;
    isMutedNotifier.value = _prefs.getBool(_AudioSettingsKeys.isMuted) ?? false;
  }

  /// 当前 BGM 音量
  double get bgmVolume => bgmVolumeNotifier.value;

  /// 当前 SFX 音量
  double get sfxVolume => sfxVolumeNotifier.value;

  /// 当前语音音量
  double get voiceVolume => voiceVolumeNotifier.value;

  /// 当前环境音音量
  double get ambientVolume => ambientVolumeNotifier.value;

  /// 是否静音
  bool get isMuted => isMutedNotifier.value;

  /// 设置 BGM 音量（0.0 ~ 1.0）
  Future<void> setBgmVolume(double volume) async {
    final clamped = volume.clamp(0.0, 1.0);
    bgmVolumeNotifier.value = clamped;
    await _prefs.setDouble(_AudioSettingsKeys.bgmVolume, clamped);
  }

  /// 设置 SFX 音量（0.0 ~ 1.0）
  Future<void> setSfxVolume(double volume) async {
    final clamped = volume.clamp(0.0, 1.0);
    sfxVolumeNotifier.value = clamped;
    await _prefs.setDouble(_AudioSettingsKeys.sfxVolume, clamped);
  }

  /// 设置语音音量（0.0 ~ 1.0）
  Future<void> setVoiceVolume(double volume) async {
    final clamped = volume.clamp(0.0, 1.0);
    voiceVolumeNotifier.value = clamped;
    await _prefs.setDouble(_AudioSettingsKeys.voiceVolume, clamped);
  }

  /// 设置环境音音量（0.0 ~ 1.0）
  Future<void> setAmbientVolume(double volume) async {
    final clamped = volume.clamp(0.0, 1.0);
    ambientVolumeNotifier.value = clamped;
    await _prefs.setDouble(_AudioSettingsKeys.ambientVolume, clamped);
  }

  /// 设置总静音开关
  Future<void> setMuted(bool muted) async {
    isMutedNotifier.value = muted;
    await _prefs.setBool(_AudioSettingsKeys.isMuted, muted);
  }

  /// 切换静音状态
  Future<void> toggleMuted() async {
    await setMuted(!isMuted);
  }

  /// 获取实际播放音量（考虑静音状态）
  double getEffectiveBgmVolume() => isMuted ? 0.0 : bgmVolume;

  /// 获取实际 SFX 播放音量（考虑静音状态）
  double getEffectiveSfxVolume() => isMuted ? 0.0 : sfxVolume;

  /// 获取实际语音播放音量（考虑静音状态）
  double getEffectiveVoiceVolume() => isMuted ? 0.0 : voiceVolume;

  /// 获取实际环境音播放音量（考虑静音状态）
  double getEffectiveAmbientVolume() => isMuted ? 0.0 : ambientVolume;

  /// 释放资源
  void dispose() {
    bgmVolumeNotifier.dispose();
    sfxVolumeNotifier.dispose();
    voiceVolumeNotifier.dispose();
    ambientVolumeNotifier.dispose();
    isMutedNotifier.dispose();
  }
}
