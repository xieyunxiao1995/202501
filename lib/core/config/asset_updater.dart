/// 资源更新器
///
/// 管理资源文件的增量更新，支持按文件级别更新，
/// 避免全量更新带来的流量和性能开销。
class AssetUpdater {
  static final AssetUpdater _instance = AssetUpdater._();
  static AssetUpdater get instance => _instance;
  AssetUpdater._();

  /// 获取需要更新的资源列表
  Future<List<AssetUpdateInfo>> getUpdateList() async {
    // TODO: 对比本地和远程资源版本，返回需要更新的资源列表
    throw UnimplementedError();
  }

  /// 更新指定资源
  Future<void> updateAsset(String assetId) async {
    // TODO: 下载并替换指定资源文件
  }

  /// 批量更新资源
  Future<void> updateAssets(List<String> assetIds) async {
    // TODO: 批量下载并替换资源文件
  }

  /// 获取更新总大小
  Future<int> getTotalUpdateSize() async {
    // TODO: 计算所有待更新资源的总大小
    throw UnimplementedError();
  }
}

/// 资源更新信息
class AssetUpdateInfo {
  /// 资源ID
  final String assetId;

  /// 资源名称
  final String name;

  /// 文件大小（字节）
  final int size;

  /// 远程版本号
  final String remoteVersion;

  /// 本地版本号
  final String localVersion;

  const AssetUpdateInfo({
    required this.assetId,
    required this.name,
    required this.size,
    required this.remoteVersion,
    required this.localVersion,
  });
}
