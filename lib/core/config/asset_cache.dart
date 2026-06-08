/// 资源缓存（LRU）
///
/// 基于最近最少使用（LRU）策略的资源缓存管理器，
/// 当缓存达到容量上限时自动淘汰最久未使用的资源。
class AssetCache<K, V> {
  final int maxSize;
  final Map<K, V> _cache = {};
  final List<K> _accessOrder = [];

  AssetCache({required this.maxSize});

  /// 获取缓存资源
  V? get(K key) {
    // TODO: 获取缓存资源并更新访问顺序
    throw UnimplementedError();
  }

  /// 存入缓存
  void put(K key, V value) {
    // TODO: 存入缓存，若超出容量则淘汰最久未使用的条目
  }

  /// 移除指定缓存
  V? remove(K key) {
    // TODO: 移除指定key的缓存
    throw UnimplementedError();
  }

  /// 清空所有缓存
  void clear() {
    // TODO: 清空缓存和访问顺序记录
  }

  /// 当前缓存数量
  int get size => _cache.length;

  /// 缓存是否已满
  bool get isFull => _cache.length >= maxSize;

  /// 是否包含指定key
  bool contains(K key) => _cache.containsKey(key);
}
