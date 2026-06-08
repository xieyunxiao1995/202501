import 'package:hive_ce/hive_ce.dart';

/// Hive 存储工具类
///
/// 基于 hive_ce 封装，提供 Box 的打开/关闭、泛型读写、批量操作、清除等功能。
class HiveStorage {
  HiveStorage();

  /// 已打开的 Box 缓存
  final Map<String, Box> _boxes = {};

  /// 获取 Box 名称前缀
  final String _prefix = 'sanguogame_';

  /// 添加前缀
  String _addPrefix(String boxName) => '$_prefix$boxName';

  // ==================== 初始化 ====================

  /// 初始化 Hive（需在 main 中调用 Hive.initFlutter 之后再使用）
  Future<void> init() async {
    // Hive 的初始化由 Hive.initFlutter() 完成，此处可做额外初始化
  }

  // ==================== Box 管理 ====================

  /// 打开一个 Box（如果已打开则直接返回缓存）
  ///
  /// [boxName] Box 名称
  Future<Box<T>> openBox<T>(String boxName) async {
    final prefixedName = _addPrefix(boxName);
    if (_boxes.containsKey(prefixedName)) {
      return _boxes[prefixedName] as Box<T>;
    }
    final box = await Hive.openBox<T>(prefixedName);
    _boxes[prefixedName] = box;
    return box;
  }

  /// 关闭指定 Box
  Future<void> closeBox(String boxName) async {
    final prefixedName = _addPrefix(boxName);
    final box = _boxes.remove(prefixedName);
    if (box != null && box.isOpen) {
      await box.close();
    }
  }

  /// 关闭所有 Box
  Future<void> closeAllBoxes() async {
    for (final box in _boxes.values.toList()) {
      if (box.isOpen) {
        await box.close();
      }
    }
    _boxes.clear();
  }

  /// 获取已打开的 Box（不自动打开）
  Box<T>? getBox<T>(String boxName) {
    final prefixedName = _addPrefix(boxName);
    return _boxes[prefixedName] as Box<T>?;
  }

  // ==================== 泛型读写 ====================

  /// 读取值
  ///
  /// [boxName] Box 名称
  /// [key] 键名
  /// [defaultValue] 默认值
  Future<T?> get<T>(String boxName, String key, {T? defaultValue}) async {
    final box = await openBox<T>(boxName);
    return box.get(key, defaultValue: defaultValue);
  }

  /// 写入值
  ///
  /// [boxName] Box 名称
  /// [key] 键名
  /// [value] 值
  Future<void> set<T>(String boxName, String key, T value) async {
    final box = await openBox<T>(boxName);
    await box.put(key, value);
  }

  /// 删除指定 key
  Future<void> delete<T>(String boxName, String key) async {
    final box = await openBox<T>(boxName);
    await box.delete(key);
  }

  /// 判断 key 是否存在
  Future<bool> containsKey<T>(String boxName, String key) async {
    final box = await openBox<T>(boxName);
    return box.containsKey(key);
  }

  // ==================== 批量操作 ====================

  /// 批量写入
  ///
  /// [boxName] Box 名称
  /// [entries] 键值对映射
  Future<void> putAll<T>(String boxName, Map<String, T> entries) async {
    final box = await openBox<T>(boxName);
    await box.putAll(entries);
  }

  /// 批量读取
  ///
  /// [boxName] Box 名称
  /// [keys] 键名列表
  /// 返回键值对映射（不存在的 key 不会出现在结果中）
  Future<Map<String, T>> getAll<T>(String boxName, Iterable<String> keys) async {
    final box = await openBox<T>(boxName);
    final result = <String, T>{};
    for (final key in keys) {
      final value = box.get(key);
      if (value != null) {
        result[key] = value;
      }
    }
    return result;
  }

  /// 批量删除
  ///
  /// [boxName] Box 名称
  /// [keys] 要删除的键名列表
  Future<void> deleteAll<T>(String boxName, Iterable<String> keys) async {
    final box = await openBox<T>(boxName);
    await box.deleteAll(keys);
  }

  // ==================== 清除 ====================

  /// 清空指定 Box 中的所有数据
  Future<void> clearBox<T>(String boxName) async {
    final box = await openBox<T>(boxName);
    await box.clear();
  }

  /// 删除指定 Box（数据+文件）
  Future<void> deleteBox(String boxName) async {
    final prefixedName = _addPrefix(boxName);
    await closeBox(boxName);
    await Hive.deleteBoxFromDisk(prefixedName);
  }

  /// 获取 Box 中的所有 key
  Future<Iterable<String>> getKeys<T>(String boxName) async {
    final box = await openBox<T>(boxName);
    return box.keys.cast<String>();
  }

  /// 获取 Box 中的数据条数
  Future<int> length<T>(String boxName) async {
    final box = await openBox<T>(boxName);
    return box.length;
  }

  // ==================== 便捷方法 ====================

  /// 监听 Box 中指定 key 的变化
  ///
  /// 返回 Stream，当 key 对应的值变化时触发
  Stream<BoxEvent> watch<T>(String boxName, {String? key}) async* {
    final box = await openBox<T>(boxName);
    yield* box.watch(key: key);
  }

  /// 使用事务批量操作（在单个事件循环中执行多个操作）
  ///
  /// [boxName] Box 名称
  /// [action] 批量操作回调
  Future<void> transaction<T>(String boxName, Future<void> Function(Box<T> box) action) async {
    final box = await openBox<T>(boxName);
    await action(box);
  }
}
