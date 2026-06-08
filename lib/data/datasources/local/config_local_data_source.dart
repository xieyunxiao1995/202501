import 'dart:convert';
import 'package:flutter/services.dart';

/// 配置本地数据源
///
/// 从 assets/data/ 目录加载 JSON 配置文件，提供游戏配置数据的读取能力。
/// 支持缓存机制，避免重复加载同一配置文件。
class ConfigLocalDataSource {
  /// JSON 配置文件缓存
  final Map<String, dynamic> _cache = {};

  /// 资源根路径
  static const String _basePath = 'assets/data';

  /// 加载指定配置文件
  ///
  /// 从 assets/data/ 目录读取 JSON 配置文件并解析为 Map。
  /// 如果该文件已加载过，则直接返回缓存结果。
  ///
  /// [fileName] 配置文件名（不含路径），如 'generals.json'
  /// 返回解析后的 JSON 数据
  Future<Map<String, dynamic>> loadConfig(String fileName) async {
    // 检查缓存
    if (_cache.containsKey(fileName)) {
      return _cache[fileName] as Map<String, dynamic>;
    }

    // 从 assets 加载
    final String path = '$_basePath/$fileName';
    final String jsonString = await rootBundle.loadString(path);
    final Map<String, dynamic> data = json.decode(jsonString) as Map<String, dynamic>;

    // 写入缓存
    _cache[fileName] = data;

    return data;
  }

  /// 加载指定配置文件（列表类型）
  ///
  /// 从 assets/data/ 目录读取 JSON 配置文件并解析为 List。
  /// 如果该文件已加载过，则直接返回缓存结果。
  ///
  /// [fileName] 配置文件名（不含路径），如 'formations.json'
  /// 返回解析后的 JSON 列表数据
  Future<List<dynamic>> loadListConfig(String fileName) async {
    // 检查缓存
    if (_cache.containsKey(fileName)) {
      return _cache[fileName] as List<dynamic>;
    }

    // 从 assets 加载
    final String path = '$_basePath/$fileName';
    final String jsonString = await rootBundle.loadString(path);
    final List<dynamic> data = json.decode(jsonString) as List<dynamic>;

    // 写入缓存
    _cache[fileName] = data;

    return data;
  }

  /// 清除所有缓存
  ///
  /// 清空已加载的配置文件缓存，通常在热重载或配置更新时调用。
  void clearCache() {
    _cache.clear();
  }

  /// 清除指定文件的缓存
  ///
  /// 清除指定配置文件的缓存，下次加载时将重新读取。
  ///
  /// [fileName] 要清除缓存的配置文件名
  void invalidateCache(String fileName) {
    _cache.remove(fileName);
  }

  /// 检查指定配置是否已缓存
  ///
  /// [fileName] 配置文件名
  /// 返回是否已缓存
  bool isCached(String fileName) {
    return _cache.containsKey(fileName);
  }
}
