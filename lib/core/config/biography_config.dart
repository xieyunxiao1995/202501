/// 传记配置单例
///
/// 提供 O(1) 时间复杂度的传记配置查询，支持按ID、关联武将查询。
class BiographyConfig {
  static final BiographyConfig _instance = BiographyConfig._();
  static BiographyConfig get instance => _instance;
  BiographyConfig._();

  final Map<String, Map<String, dynamic>> _biographiesById = {};

  /// 初始化配置
  void init(List<dynamic> data) {
    _biographiesById.clear();
    for (final item in data) {
      final map = item as Map<String, dynamic>;
      _biographiesById[map['id'] as String] = map;
    }
  }

  /// 根据ID获取传记配置
  Map<String, dynamic>? getById(String id) => _biographiesById[id];

  /// 获取所有传记配置
  List<Map<String, dynamic>> get all => _biographiesById.values.toList();

  /// 按关联武将ID筛选
  List<Map<String, dynamic>> getByGeneralId(String generalId) =>
      all.where((b) => b['generalId'] == generalId).toList();

  /// 按章节筛选
  List<Map<String, dynamic>> getByChapter(String chapter) =>
      all.where((b) => b['chapter'] == chapter).toList();
}
