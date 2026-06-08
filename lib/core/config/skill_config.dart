/// 技能配置单例
///
/// 提供 O(1) 时间复杂度的技能配置查询，支持按ID、类型查询。
class SkillConfig {
  static final SkillConfig _instance = SkillConfig._();
  static SkillConfig get instance => _instance;
  SkillConfig._();

  final Map<String, Map<String, dynamic>> _skillsById = {};

  /// 初始化配置
  void init(List<dynamic> data) {
    _skillsById.clear();
    for (final item in data) {
      final map = item as Map<String, dynamic>;
      _skillsById[map['id'] as String] = map;
    }
  }

  /// 根据ID获取技能配置
  Map<String, dynamic>? getById(String id) => _skillsById[id];

  /// 获取所有技能配置
  List<Map<String, dynamic>> get all => _skillsById.values.toList();

  /// 按类型筛选（如：主动、被动、觉醒）
  List<Map<String, dynamic>> getByType(String type) =>
      all.where((s) => s['type'] == type).toList();

  /// 按目标类型筛选（如：单体、群体、自身）
  List<Map<String, dynamic>> getByTargetType(String targetType) =>
      all.where((s) => s['targetType'] == targetType).toList();
}
