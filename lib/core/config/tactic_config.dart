/// 战法配置单例
///
/// 提供 O(1) 时间复杂度的战法配置查询，支持按ID、类型查询。
class TacticConfig {
  static final TacticConfig _instance = TacticConfig._();
  static TacticConfig get instance => _instance;
  TacticConfig._();

  final Map<String, Map<String, dynamic>> _tacticsById = {};

  /// 初始化配置
  void init(List<dynamic> data) {
    _tacticsById.clear();
    for (final item in data) {
      final map = item as Map<String, dynamic>;
      _tacticsById[map['id'] as String] = map;
    }
  }

  /// 根据ID获取战法配置
  Map<String, dynamic>? getById(String id) => _tacticsById[id];

  /// 获取所有战法配置
  List<Map<String, dynamic>> get all => _tacticsById.values.toList();

  /// 按类型筛选（如：攻击、防御、辅助）
  List<Map<String, dynamic>> getByType(String type) =>
      all.where((t) => t['type'] == type).toList();

  /// 按品质筛选
  List<Map<String, dynamic>> getByQuality(String quality) =>
      all.where((t) => t['quality'] == quality).toList();
}
