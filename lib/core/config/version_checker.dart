/// 版本检查器
///
/// 与服务器通信，检查当前客户端版本是否需要更新，
/// 获取更新信息（版本号、更新内容、补丁大小等）。
class VersionChecker {
  static final VersionChecker _instance = VersionChecker._();
  static VersionChecker get instance => _instance;
  VersionChecker._();

  /// 检查版本
  ///
  /// 返回版本检查结果，包含是否有更新、最新版本号、更新描述等
  Future<VersionCheckResult> check() async {
    // TODO: 向服务器请求版本信息并比较
    throw UnimplementedError();
  }

  /// 获取更新日志
  Future<String> getChangelog(String version) async {
    // TODO: 获取指定版本的更新日志
    throw UnimplementedError();
  }

  /// 是否为强制更新
  Future<bool> isForceUpdate(String version) async {
    // TODO: 判断指定版本是否需要强制更新
    throw UnimplementedError();
  }
}

/// 版本检查结果
class VersionCheckResult {
  /// 是否有可用更新
  final bool hasUpdate;

  /// 最新版本号
  final String latestVersion;

  /// 更新描述
  final String description;

  /// 补丁大小（字节）
  final int patchSize;

  /// 是否强制更新
  final bool forceUpdate;

  const VersionCheckResult({
    required this.hasUpdate,
    required this.latestVersion,
    this.description = '',
    this.patchSize = 0,
    this.forceUpdate = false,
  });
}
