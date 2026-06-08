/// 战斗回放本地数据源
///
/// 提供战斗回放数据的本地持久化存储能力，包括回放录制和回放数据读取。
class ReplayLocalDataSource {
  /// 保存战斗回放数据
  ///
  /// [battleId] 战斗 ID
  /// [replayData] 回放序列化数据
  Future<void> saveReplay({
    required String battleId,
    required Map<String, dynamic> replayData,
  }) async {
    // TODO: 实现战斗回放数据本地存储
    throw UnimplementedError();
  }

  /// 读取战斗回放数据
  ///
  /// [battleId] 战斗 ID
  /// 返回回放序列化数据，若不存在返回 null
  Future<Map<String, dynamic>?> getReplay(String battleId) async {
    // TODO: 实现战斗回放数据读取
    throw UnimplementedError();
  }

  /// 获取所有回放列表
  ///
  /// 返回已保存的回放摘要列表
  Future<List<Map<String, dynamic>>> getReplayList() async {
    // TODO: 实现回放列表读取
    throw UnimplementedError();
  }

  /// 删除指定回放
  ///
  /// [battleId] 战斗 ID
  Future<void> deleteReplay(String battleId) async {
    // TODO: 实现回放数据删除
    throw UnimplementedError();
  }

  /// 清除所有回放数据
  Future<void> clearAll() async {
    // TODO: 清除所有回放数据
    throw UnimplementedError();
  }
}
