/// Widget 对象池
///
/// 复用频繁创建和销毁的 Widget 对象，减少 GC 压力和界面构建耗时。
/// 适用于战斗场景中大量重复的 UI 元素（如血条、状态图标等）。
class WidgetPool<T> {
  final T Function() _create;
  final int maxPoolSize;

  final List<T> _pool = [];

  WidgetPool({
    required T Function() create,
    this.maxPoolSize = 50,
  }) : _create = create;

  /// 从池中获取对象
  ///
  /// 池中有可用对象时复用，否则创建新对象
  T acquire() {
    // TODO: 从池中取出对象或创建新对象
    throw UnimplementedError();
  }

  /// 归还对象到池中
  ///
  /// 池未满时归还，池满时丢弃
  void release(T obj) {
    // TODO: 归还对象到池中，超满则丢弃
  }

  /// 预热对象池
  ///
  /// 提前创建指定数量的对象放入池中
  void warmUp(int count) {
    // TODO: 预创建对象填入池中
  }

  /// 清空对象池
  void clear() {
    // TODO: 清空池中所有对象
  }

  /// 池中可用对象数量
  int get availableCount => _pool.length;

  /// 池是否为空
  bool get isEmpty => _pool.isEmpty;
}
