/// List 扩展方法
///
/// 提供安全的列表访问、分块、去重、求和等常用操作。
library;

extension ListExtensions<T> on List<T> {
  /// 安全获取指定索引的元素，越界时返回 null
  ///
  /// ```dart
  /// [1, 2, 3].safeGet(0); // 1
  /// [1, 2, 3].safeGet(5); // null
  /// ```
  T? safeGet(int index) {
    if (index < 0 || index >= length) return null;
    return this[index];
  }

  /// 将列表按指定大小分块
  ///
  /// ```dart
  /// [1, 2, 3, 4, 5].chunk(2); // [[1, 2], [3, 4], [5]]
  /// ```
  List<List<T>> chunk(int size) {
    if (size <= 0) return [List<T>.from(this)];
    final chunks = <List<T>>[];
    for (var i = 0; i < length; i += size) {
      final end = i + size;
      chunks.add(List<T>.from(sublist(i, end > length ? length : end)));
    }
    return chunks;
  }

  /// 按选择器字段去重
  ///
  /// 保留首次出现的元素，后续重复的会被过滤。
  /// ```dart
  /// [{'name': 'a'}, {'name': 'b'}, {'name': 'a'}].distinctBy((e) => e['name'])
  /// // [{'name': 'a'}, {'name': 'b'}]
  /// ```
  List<T> distinctBy<R>(R Function(T) selector) {
    final seen = <R>{};
    return where((element) => seen.add(selector(element))).toList();
  }

  /// 获取第一个元素，列表为空时返回默认值
  ///
  /// ```dart
  /// [1, 2, 3].firstOrDefault(0); // 1
  /// <int>[].firstOrDefault(0); // 0
  /// ```
  T firstOrDefault(T defaultValue) {
    if (isEmpty) return defaultValue;
    return first;
  }

  /// 按选择器求和
  ///
  /// ```dart
  /// [{'value': 10}, {'value': 20}].sumBy((e) => e['value'] as int); // 30
  /// ```
  num sumBy(num Function(T) selector) {
    return fold<num>(0, (sum, element) => sum + selector(element));
  }

  /// 列表是否为空或 null（适用于可空 List）
  ///
  /// 注意：此扩展在非空 List 上，始终等价于 [isEmpty]。
  bool get isNullOrEmpty => isEmpty;

  /// 列表是否非空
  bool get isNotNullOrEmpty => isNotEmpty;

  /// 将列表元素用 [separator] 连接为字符串
  ///
  /// 类似 [join]，但接受一个转换函数。
  /// ```dart
  /// [1, 2, 3].mapJoin(', ', (e) => '[$e]'); // '[1], [2], [3]'
  /// ```
  String mapJoin(String separator, String Function(T) transform) {
    return map(transform).join(separator);
  }
}
