/// 装备配置单例
///
/// 提供 O(1) 时间复杂度的装备配置查询，支持按ID、部位、品质查询。
class EquipmentConfig {
  static final EquipmentConfig _instance = EquipmentConfig._();
  static EquipmentConfig get instance => _instance;
  EquipmentConfig._();

  final Map<String, Map<String, dynamic>> _equipmentById = {};

  /// 初始化配置
  void init(List<dynamic> data) {
    _equipmentById.clear();
    for (final item in data) {
      final map = item as Map<String, dynamic>;
      _equipmentById[map['id'] as String] = map;
    }
  }

  /// 根据ID获取装备配置
  Map<String, dynamic>? getById(String id) => _equipmentById[id];

  /// 获取所有装备配置
  List<Map<String, dynamic>> get all => _equipmentById.values.toList();

  /// 按部位筛选（如：武器、防具、饰品）
  List<Map<String, dynamic>> getBySlot(String slot) =>
      all.where((e) => e['slot'] == slot).toList();

  /// 按品质筛选
  List<Map<String, dynamic>> getByQuality(String quality) =>
      all.where((e) => e['quality'] == quality).toList();
}
