import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 设置本地数据源
///
/// 基于 SharedPreferences 的本地设置读写，提供键值对形式的持久化存储。
/// 支持基础类型（bool、int、double、String）及 JSON 序列化对象的存储。
class SettingsLocalDataSource {
  /// SharedPreferences 实例
  final SharedPreferences _prefs;

  /// 键名前缀，避免与其他存储冲突
  static const String _prefix = 'sanguo_settings_';

  SettingsLocalDataSource(this._prefs);

  // ============ 通用方法 ============

  /// 读取布尔值设置
  ///
  /// [key] 设置键名（不含前缀）
  /// [defaultValue] 默认值，默认 false
  bool getBool(String key, {bool defaultValue = false}) {
    return _prefs.getBool('$_prefix$key') ?? defaultValue;
  }

  /// 写入布尔值设置
  ///
  /// [key] 设置键名（不含前缀）
  /// [value] 要写入的值
  Future<bool> setBool(String key, bool value) {
    return _prefs.setBool('$_prefix$key', value);
  }

  /// 读取整数值设置
  ///
  /// [key] 设置键名（不含前缀）
  /// [defaultValue] 默认值，默认 0
  int getInt(String key, {int defaultValue = 0}) {
    return _prefs.getInt('$_prefix$key') ?? defaultValue;
  }

  /// 写入整数值设置
  ///
  /// [key] 设置键名（不含前缀）
  /// [value] 要写入的值
  Future<bool> setInt(String key, int value) {
    return _prefs.setInt('$_prefix$key', value);
  }

  /// 读取双精度浮点数设置
  ///
  /// [key] 设置键名（不含前缀）
  /// [defaultValue] 默认值，默认 0.0
  double getDouble(String key, {double defaultValue = 0.0}) {
    return _prefs.getDouble('$_prefix$key') ?? defaultValue;
  }

  /// 写入双精度浮点数设置
  ///
  /// [key] 设置键名（不含前缀）
  /// [value] 要写入的值
  Future<bool> setDouble(String key, double value) {
    return _prefs.setDouble('$_prefix$key', value);
  }

  /// 读取字符串设置
  ///
  /// [key] 设置键名（不含前缀）
  /// [defaultValue] 默认值，默认空字符串
  String getString(String key, {String defaultValue = ''}) {
    return _prefs.getString('$_prefix$key') ?? defaultValue;
  }

  /// 写入字符串设置
  ///
  /// [key] 设置键名（不含前缀）
  /// [value] 要写入的值
  Future<bool> setString(String key, String value) {
    return _prefs.setString('$_prefix$key', value);
  }

  /// 读取 JSON 对象设置
  ///
  /// [key] 设置键名（不含前缀）
  /// 返回解析后的 Map，若不存在或解析失败返回空 Map
  Map<String, dynamic> getJson(String key) {
    final String? jsonString = _prefs.getString('$_prefix$key');
    if (jsonString == null || jsonString.isEmpty) {
      return {};
    }
    try {
      return json.decode(jsonString) as Map<String, dynamic>;
    } catch (_) {
      return {};
    }
  }

  /// 写入 JSON 对象设置
  ///
  /// [key] 设置键名（不含前缀）
  /// [value] 要写入的 Map 对象
  Future<bool> setJson(String key, Map<String, dynamic> value) {
    return _prefs.setString('$_prefix$key', json.encode(value));
  }

  /// 删除指定设置项
  ///
  /// [key] 设置键名（不含前缀）
  Future<bool> remove(String key) {
    return _prefs.remove('$_prefix$key');
  }

  /// 检查指定设置项是否存在
  ///
  /// [key] 设置键名（不含前缀）
  bool containsKey(String key) {
    return _prefs.containsKey('$_prefix$key');
  }

  /// 清除所有本应用的设置
  ///
  /// 仅清除带前缀的设置项，不影响其他存储。
  Future<void> clearAll() async {
    final Set<String> keys = _prefs.getKeys();
    for (final String key in keys) {
      if (key.startsWith(_prefix)) {
        await _prefs.remove(key);
      }
    }
  }

  // ============ 常用设置项快捷方法 ============

  /// 音效开关
  bool get soundEnabled => getBool('sound_enabled', defaultValue: true);
  Future<bool> setSoundEnabled(bool value) => setBool('sound_enabled', value);

  /// 背景音乐开关
  bool get bgmEnabled => getBool('bgm_enabled', defaultValue: true);
  Future<bool> setBgmEnabled(bool value) => setBool('bgm_enabled', value);

  /// 音效音量（0.0 - 1.0）
  double get soundVolume => getDouble('sound_volume', defaultValue: 1.0);
  Future<bool> setSoundVolume(double value) => setDouble('sound_volume', value);

  /// 背景音乐音量（0.0 - 1.0）
  double get bgmVolume => getDouble('bgm_volume', defaultValue: 0.8);
  Future<bool> setBgmVolume(double value) => setDouble('bgm_volume', value);

  /// 推送通知开关
  bool get notificationEnabled => getBool('notification_enabled', defaultValue: true);
  Future<bool> setNotificationEnabled(bool value) => setBool('notification_enabled', value);

  /// 已选服务器 ID
  String get selectedServerId => getString('selected_server_id');
  Future<bool> setSelectedServerId(String value) => setString('selected_server_id', value);

  /// 语言设置
  String get language => getString('language', defaultValue: 'zh_CN');
  Future<bool> setLanguage(String value) => setString('language', value);
}
