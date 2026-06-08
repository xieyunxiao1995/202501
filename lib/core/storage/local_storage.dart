import 'package:shared_preferences/shared_preferences.dart';

/// 本地存储工具类
///
/// 基于 SharedPreferences 封装，提供泛型 get/set 操作，
/// 支持 String/int/double/bool/StringList 类型，所有 key 自动添加 storagePrefix 前缀。
class LocalStorage {
  LocalStorage({String storagePrefix = 'sanguogame_'}) : _prefix = storagePrefix;

  /// 存储前缀，用于避免 key 冲突
  final String _prefix;

  /// SharedPreferences 实例
  SharedPreferences? _prefs;

  /// 获取 SharedPreferences 实例（懒加载）
  Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// 添加前缀
  String _addPrefix(String key) => '$_prefix$key';

  // ==================== 初始化 ====================

  /// 初始化本地存储
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // ==================== 泛型读写 ====================

  /// 泛型读取
  ///
  /// 根据 [key] 读取值，支持 String/int/double/bool/StringList 类型。
  /// [defaultValue] 为默认值（当 key 不存在时返回）。
  T? get<T>(String key, {T? defaultValue}) {
    if (_prefs == null) return defaultValue;
    final prefixedKey = _addPrefix(key);

    if (T == String) {
      return (_prefs!.getString(prefixedKey) ?? defaultValue) as T?;
    } else if (T == int) {
      return (_prefs!.getInt(prefixedKey) ?? defaultValue) as T?;
    } else if (T == double) {
      return (_prefs!.getDouble(prefixedKey) ?? defaultValue) as T?;
    } else if (T == bool) {
      return (_prefs!.getBool(prefixedKey) ?? defaultValue) as T?;
    } else if (T == List<String>) {
      return (_prefs!.getStringList(prefixedKey) ?? defaultValue) as T?;
    }

    return defaultValue;
  }

  /// 泛型写入
  ///
  /// 根据 [key] 写入值，支持 String/int/double/bool/StringList 类型。
  Future<bool> set<T>(String key, T value) async {
    final prefs = await _instance;
    final prefixedKey = _addPrefix(key);

    if (value is String) {
      return prefs.setString(prefixedKey, value);
    } else if (value is int) {
      return prefs.setInt(prefixedKey, value);
    } else if (value is double) {
      return prefs.setDouble(prefixedKey, value);
    } else if (value is bool) {
      return prefs.setBool(prefixedKey, value);
    } else if (value is List<String>) {
      return prefs.setStringList(prefixedKey, value);
    }

    return false;
  }

  // ==================== String ====================

  /// 读取字符串
  String? getString(String key) {
    if (_prefs == null) return null;
    return _prefs!.getString(_addPrefix(key));
  }

  /// 写入字符串
  Future<bool> setString(String key, String value) async {
    final prefs = await _instance;
    return prefs.setString(_addPrefix(key), value);
  }

  // ==================== int ====================

  /// 读取整数
  int? getInt(String key) {
    if (_prefs == null) return null;
    return _prefs!.getInt(_addPrefix(key));
  }

  /// 写入整数
  Future<bool> setInt(String key, int value) async {
    final prefs = await _instance;
    return prefs.setInt(_addPrefix(key), value);
  }

  // ==================== double ====================

  /// 读取浮点数
  double? getDouble(String key) {
    if (_prefs == null) return null;
    return _prefs!.getDouble(_addPrefix(key));
  }

  /// 写入浮点数
  Future<bool> setDouble(String key, double value) async {
    final prefs = await _instance;
    return prefs.setDouble(_addPrefix(key), value);
  }

  // ==================== bool ====================

  /// 读取布尔值
  bool? getBool(String key) {
    if (_prefs == null) return null;
    return _prefs!.getBool(_addPrefix(key));
  }

  /// 写入布尔值
  Future<bool> setBool(String key, bool value) async {
    final prefs = await _instance;
    return prefs.setBool(_addPrefix(key), value);
  }

  // ==================== StringList ====================

  /// 读取字符串列表
  List<String>? getStringList(String key) {
    if (_prefs == null) return null;
    return _prefs!.getStringList(_addPrefix(key));
  }

  /// 写入字符串列表
  Future<bool> setStringList(String key, List<String> value) async {
    final prefs = await _instance;
    return prefs.setStringList(_addPrefix(key), value);
  }

  // ==================== 删除与清理 ====================

  /// 删除指定 key
  Future<bool> remove(String key) async {
    final prefs = await _instance;
    return prefs.remove(_addPrefix(key));
  }

  /// 判断 key 是否存在
  bool containsKey(String key) {
    if (_prefs == null) return false;
    return _prefs!.containsKey(_addPrefix(key));
  }

  /// 清除所有带前缀的数据
  Future<void> clear() async {
    final prefs = await _instance;
    final keys = prefs.getKeys().where((k) => k.startsWith(_prefix)).toList();
    for (final key in keys) {
      await prefs.remove(key);
    }
  }

  /// 获取所有带前缀的 key
  Set<String> getKeys() {
    if (_prefs == null) return {};
    return _prefs!.getKeys().where((k) => k.startsWith(_prefix)).toSet();
  }

  /// 重新加载数据
  Future<void> reload() async {
    final prefs = await _instance;
    await prefs.reload();
  }
}
