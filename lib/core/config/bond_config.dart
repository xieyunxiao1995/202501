/// 羁绊配置单例
///
/// 提供 O(1) 时间复杂度的羁绊配置查询，支持按ID、关联武将查询。
class BondConfig {
  static final BondConfig _instance = BondConfig._();
  static BondConfig get instance => _instance;
  BondConfig._();

  final Map<String, Map<String, dynamic>> _bondsById = {};

  /// 初始化配置
  void init(List<dynamic> data) {
    _bondsById.clear();
    for (final item in data) {
      final map = item as Map<String, dynamic>;
      _bondsById[map['id'] as String] = map;
    }
  }

  /// 根据ID获取羁绊配置
  Map<String, dynamic>? getById(String id) => _bondsById[id];

  /// 获取所有羁绊配置
  List<Map<String, dynamic>> get all => _bondsById.values.toList();

  /// 按关联武将ID筛选（查找包含指定武将的所有羁绊）
  List<Map<String, dynamic>> getByGeneralId(String generalId) =>
      all.where((b) {
        final members = b['members'] as List<dynamic>?;
        return members?.contains(generalId) ?? false;
      }).toList();

  /// 按羁绊类型筛选（如：攻击加成、防御加成、生命加成）
  List<Map<String, dynamic>> getByType(String type) =>
      all.where((b) => b['type'] == type).toList();
}
