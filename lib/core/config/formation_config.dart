/// 阵法配置单例
///
/// 提供 O(1) 时间复杂度的阵法配置查询，支持按ID、类型查询。
class FormationConfig {
  static final FormationConfig _instance = FormationConfig._();
  static FormationConfig get instance => _instance;
  FormationConfig._();

  final Map<String, Map<String, dynamic>> _formationsById = {};

  /// 初始化配置
  void init(List<dynamic> data) {
    _formationsById.clear();
    for (final item in data) {
      final map = item as Map<String, dynamic>;
      _formationsById[map['id'] as String] = map;
    }
  }

  /// 根据ID获取阵法配置
  Map<String, dynamic>? getById(String id) => _formationsById[id];

  /// 获取所有阵法配置
  List<Map<String, dynamic>> get all => _formationsById.values.toList();

  /// 按类型筛选（如：攻击阵、防御阵、平衡阵）
  List<Map<String, dynamic>> getByType(String type) =>
      all.where((f) => f['type'] == type).toList();

  /// 按解锁条件筛选
  List<Map<String, dynamic>> getByUnlockLevel(int level) =>
      all.where((f) => (f['unlockLevel'] as int? ?? 0) <= level).toList();
}
