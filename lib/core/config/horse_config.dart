/// 坐骑配置单例
///
/// 提供 O(1) 时间复杂度的坐骑配置查询，支持按ID、品质查询。
class HorseConfig {
  static final HorseConfig _instance = HorseConfig._();
  static HorseConfig get instance => _instance;
  HorseConfig._();

  final Map<String, Map<String, dynamic>> _horsesById = {};

  /// 初始化配置
  void init(List<dynamic> data) {
    _horsesById.clear();
    for (final item in data) {
      final map = item as Map<String, dynamic>;
      _horsesById[map['id'] as String] = map;
    }
  }

  /// 根据ID获取坐骑配置
  Map<String, dynamic>? getById(String id) => _horsesById[id];

  /// 获取所有坐骑配置
  List<Map<String, dynamic>> get all => _horsesById.values.toList();

  /// 按品质筛选
  List<Map<String, dynamic>> getByQuality(String quality) =>
      all.where((h) => h['quality'] == quality).toList();

  /// 按类型筛选（如：战马、坐骑、神驹）
  List<Map<String, dynamic>> getByType(String type) =>
      all.where((h) => h['type'] == type).toList();
}
