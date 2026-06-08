import 'dart:convert';
import 'package:flutter/services.dart';

/// 配置加载器
///
/// 在应用启动时预加载所有 JSON 配置文件到内存中，
/// 提供同步访问接口，避免运行时异步加载的性能问题。
class ConfigLoader {
  static final Map<String, dynamic> _configs = {};
  static bool _isLoaded = false;

  static bool get isLoaded => _isLoaded;

  /// 加载所有配置文件
  static Future<void> loadAll() async {
    final configFiles = [
      'generals', 'skills', 'tactics', 'formations', 'stages',
      'equipment', 'horses', 'items', 'buildings', 'biographies', 'bonds',
    ];
    for (final name in configFiles) {
      final jsonStr = await rootBundle.loadString('assets/data/$name.json');
      _configs[name] = json.decode(jsonStr);
    }
    _isLoaded = true;
  }

  /// 获取配置数据
  static T get<T>(String name) {
    if (!_isLoaded) throw StateError('配置尚未加载，请先调用 ConfigLoader.loadAll()');
    return _configs[name] as T;
  }

  /// 获取配置数据的 data 字段
  static List<dynamic> getData(String name) {
    final config = get<Map<String, dynamic>>(name);
    return config['data'] as List<dynamic>;
  }

  /// 获取配置版本号
  static String getVersion(String name) {
    final config = get<Map<String, dynamic>>(name);
    return config['version'] as String? ?? '1.0.0';
  }

  /// 清除所有配置缓存
  static void clear() {
    _configs.clear();
    _isLoaded = false;
  }
}
