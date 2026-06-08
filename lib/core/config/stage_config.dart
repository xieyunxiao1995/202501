/// 关卡配置单例
///
/// 提供 O(1) 时间复杂度的关卡配置查询，支持按ID、章节查询。
class StageConfig {
  static final StageConfig _instance = StageConfig._();
  static StageConfig get instance => _instance;
  StageConfig._();

  final Map<String, Map<String, dynamic>> _stagesById = {};

  /// 初始化配置
  void init(List<dynamic> data) {
    _stagesById.clear();
    for (final item in data) {
      final map = item as Map<String, dynamic>;
      _stagesById[map['id'] as String] = map;
    }
  }

  /// 根据ID获取关卡配置
  Map<String, dynamic>? getById(String id) => _stagesById[id];

  /// 获取所有关卡配置
  List<Map<String, dynamic>> get all => _stagesById.values.toList();

  /// 按章节ID筛选
  List<Map<String, dynamic>> getByChapterId(String chapterId) =>
      all.where((s) => s['chapterId'] == chapterId).toList();

  /// 按难度筛选
  List<Map<String, dynamic>> getByDifficulty(String difficulty) =>
      all.where((s) => s['difficulty'] == difficulty).toList();

  /// 获取指定章节的关卡数量
  int getChapterStageCount(String chapterId) =>
      getByChapterId(chapterId).length;
}
