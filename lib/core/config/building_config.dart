/// 建筑配置单例
///
/// 提供 O(1) 时间复杂度的建筑配置查询，支持按ID、类型查询。
class BuildingConfig {
  static final BuildingConfig _instance = BuildingConfig._();
  static BuildingConfig get instance => _instance;
  BuildingConfig._();

  final Map<String, Map<String, dynamic>> _buildingsById = {};

  /// 初始化配置
  void init(List<dynamic> data) {
    _buildingsById.clear();
    for (final item in data) {
      final map = item as Map<String, dynamic>;
      _buildingsById[map['id'] as String] = map;
    }
  }

  /// 根据ID获取建筑配置
  Map<String, dynamic>? getById(String id) => _buildingsById[id];

  /// 获取所有建筑配置
  List<Map<String, dynamic>> get all => _buildingsById.values.toList();

  /// 按类型筛选（如：资源建筑、军事建筑、功能建筑）
  List<Map<String, dynamic>> getByType(String type) =>
      all.where((b) => b['type'] == type).toList();

  /// 获取指定等级的建筑配置
  List<Map<String, dynamic>> getByLevel(int level) =>
      all.where((b) => b['level'] == level).toList();
}
