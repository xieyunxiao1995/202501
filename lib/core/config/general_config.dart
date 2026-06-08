/// 武将配置单例
///
/// 提供 O(1) 时间复杂度的武将配置查询，支持按ID、稀有度、阵营查询。
class GeneralConfig {
  static final GeneralConfig _instance = GeneralConfig._();
  static GeneralConfig get instance => _instance;
  GeneralConfig._();

  final Map<String, Map<String, dynamic>> _generalsById = {};

  /// 初始化配置
  void init(List<dynamic> data) {
    _generalsById.clear();
    for (final item in data) {
      final map = item as Map<String, dynamic>;
      _generalsById[map['id'] as String] = map;
    }
  }

  /// 根据ID获取武将配置
  Map<String, dynamic>? getById(String id) => _generalsById[id];

  /// 获取所有武将配置
  List<Map<String, dynamic>> get all => _generalsById.values.toList();

  /// 按稀有度筛选
  List<Map<String, dynamic>> getByRarity(String rarity) =>
      all.where((g) => g['rarity'] == rarity).toList();

  /// 按阵营筛选
  List<Map<String, dynamic>> getByKingdom(String kingdom) =>
      all.where((g) => g['kingdom'] == kingdom).toList();
}
