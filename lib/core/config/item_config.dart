/// 物品配置单例
///
/// 提供 O(1) 时间复杂度的物品配置查询，支持按ID、类型、品质查询。
/// 涵盖装备、马匹、道具等物品的统一查询入口。
class ItemConfig {
  static final ItemConfig _instance = ItemConfig._();
  static ItemConfig get instance => _instance;
  ItemConfig._();

  final Map<String, Map<String, dynamic>> _itemsById = {};

  /// 初始化配置
  void init(List<dynamic> data) {
    _itemsById.clear();
    for (final item in data) {
      final map = item as Map<String, dynamic>;
      _itemsById[map['id'] as String] = map;
    }
  }

  /// 根据ID获取物品配置
  Map<String, dynamic>? getById(String id) => _itemsById[id];

  /// 获取所有物品配置
  List<Map<String, dynamic>> get all => _itemsById.values.toList();

  /// 按类型筛选（如：消耗品、材料、宝物）
  List<Map<String, dynamic>> getByType(String type) =>
      all.where((i) => i['type'] == type).toList();

  /// 按品质筛选
  List<Map<String, dynamic>> getByQuality(String quality) =>
      all.where((i) => i['quality'] == quality).toList();
}
