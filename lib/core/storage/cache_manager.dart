/// 缓存管理器（骨架）
///
/// 提供图片/资源缓存的方法签名，具体实现待后续完善。
class CacheManager {
  CacheManager._();

  /// 缓存目录路径
  // ignore: unused_field
  static String? _cacheDir;

  /// 最大缓存大小（字节），默认 100MB
  // ignore: unused_field
  static int _maxCacheSize = 100 * 1024 * 1024;

  /// 初始化缓存管理器
  ///
  /// [cacheDir] 缓存目录路径
  /// [maxCacheSize] 最大缓存大小（字节）
  ///
  /// TODO: 实现缓存目录初始化逻辑
  static Future<void> init({String? cacheDir, int? maxCacheSize}) async {
    _cacheDir = cacheDir;
    if (maxCacheSize != null) {
      _maxCacheSize = maxCacheSize;
    }
    throw UnimplementedError('CacheManager.init 尚未实现');
  }

  /// 获取图片缓存
  ///
  /// [url] 图片 URL
  /// 返回本地缓存路径，未缓存返回 null
  ///
  /// TODO: 实现图片缓存读取逻辑
  static Future<String?> getImageCache(String url) async {
    throw UnimplementedError('getImageCache 尚未实现');
  }

  /// 保存图片到缓存
  ///
  /// [url] 图片 URL
  /// [bytes] 图片字节数据
  ///
  /// TODO: 实现图片缓存写入逻辑
  static Future<void> saveImageCache(String url, List<int> bytes) async {
    throw UnimplementedError('saveImageCache 尚未实现');
  }

  /// 获取资源缓存
  ///
  /// [key] 资源标识
  /// 返回本地缓存路径，未缓存返回 null
  ///
  /// TODO: 实现资源缓存读取逻辑
  static Future<String?> getResourceCache(String key) async {
    throw UnimplementedError('getResourceCache 尚未实现');
  }

  /// 保存资源到缓存
  ///
  /// [key] 资源标识
  /// [bytes] 资源字节数据
  ///
  /// TODO: 实现资源缓存写入逻辑
  static Future<void> saveResourceCache(String key, List<int> bytes) async {
    throw UnimplementedError('saveResourceCache 尚未实现');
  }

  /// 清除所有缓存
  ///
  /// TODO: 实现缓存清除逻辑
  static Future<void> clearAll() async {
    throw UnimplementedError('CacheManager.clearAll 尚未实现');
  }

  /// 清除过期缓存
  ///
  /// [maxAge] 最大保留时间（Duration）
  ///
  /// TODO: 实现过期缓存清除逻辑
  static Future<void> clearExpired(Duration maxAge) async {
    throw UnimplementedError('CacheManager.clearExpired 尚未实现');
  }

  /// 获取当前缓存大小（字节）
  ///
  /// TODO: 实现缓存大小计算逻辑
  static Future<int> getCacheSize() async {
    throw UnimplementedError('CacheManager.getCacheSize 尚未实现');
  }

  /// 获取缓存信息摘要
  ///
  /// 返回缓存大小、文件数等信息
  ///
  /// TODO: 实现缓存信息获取逻辑
  static Future<Map<String, dynamic>> getCacheInfo() async {
    throw UnimplementedError('CacheManager.getCacheInfo 尚未实现');
  }
}
