/// 游戏进度本地数据源
///
/// 提供游戏进度数据的本地持久化存储能力，包括关卡进度、副本进度等。
class GameProgressLocalDataSource {
  /// 保存关卡进度
  ///
  /// [chapterId] 章节 ID
  /// [stageId] 关卡 ID
  /// [cleared] 是否已通关
  /// [threeStarred] 是否三星通关
  Future<void> saveStageProgress({
    required String chapterId,
    required String stageId,
    required bool cleared,
    bool threeStarred = false,
  }) async {
    // TODO: 实现关卡进度本地存储
    throw UnimplementedError();
  }

  /// 读取章节的关卡进度
  ///
  /// [chapterId] 章节 ID
  /// 返回关卡进度映射（关卡ID -> {cleared, threeStarred}）
  Future<Map<String, Map<String, dynamic>>> getStageProgress(String chapterId) async {
    // TODO: 实现关卡进度读取
    throw UnimplementedError();
  }

  /// 保存副本进度
  ///
  /// [dungeonId] 副本 ID
  /// [currentFloor] 当前层数
  Future<void> saveDungeonProgress({
    required String dungeonId,
    required int currentFloor,
  }) async {
    // TODO: 实现副本进度本地存储
    throw UnimplementedError();
  }

  /// 读取副本进度
  ///
  /// [dungeonId] 副本 ID
  /// 返回当前层数
  Future<int> getDungeonProgress(String dungeonId) async {
    // TODO: 实现副本进度读取
    throw UnimplementedError();
  }

  /// 保存试炼之塔进度
  ///
  /// [currentFloor] 当前层数
  Future<void> saveTowerProgress(int currentFloor) async {
    // TODO: 实现试炼之塔进度存储
    throw UnimplementedError();
  }

  /// 读取试炼之塔进度
  ///
  /// 返回当前层数
  Future<int> getTowerProgress() async {
    // TODO: 实现试炼之塔进度读取
    throw UnimplementedError();
  }

  /// 清除所有进度数据
  Future<void> clearAll() async {
    // TODO: 清除所有进度数据
    throw UnimplementedError();
  }
}
