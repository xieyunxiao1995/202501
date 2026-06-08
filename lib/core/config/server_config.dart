/// 服务器配置（分服、跨服、国战服）
///
/// 表示一个游戏服的配置信息，包含服务器ID、名称、API地址、
/// WebSocket 地址以及服务器状态等。
///
/// 使用方式：
/// ```dart
/// final server = ServerConfig.defaultServers.first;
/// print(server.serverName); // 一区·黄巾之乱
/// ```
class ServerConfig {
  /// 创建服务器配置
  const ServerConfig({
    required this.serverId,
    required this.serverName,
    required this.apiUrl,
    required this.wsUrl,
    this.isActive = true,
    this.isNew = false,
  });

  /// 服务器ID
  final String serverId;

  /// 服务器名称
  final String serverName;

  /// API 地址
  final String apiUrl;

  /// WebSocket 地址
  final String wsUrl;

  /// 是否活跃（可登录）
  final bool isActive;

  /// 是否为新服
  final bool isNew;

  /// 默认服务器列表
  static const List<ServerConfig> defaultServers = [
    ServerConfig(
      serverId: 's1',
      serverName: '一区·黄巾之乱',
      apiUrl: 'https://s1-api.sanguogame.com',
      wsUrl: 'wss://s1-ws.sanguogame.com',
      isActive: true,
      isNew: false,
    ),
    ServerConfig(
      serverId: 's2',
      serverName: '二区·董卓乱政',
      apiUrl: 'https://s2-api.sanguogame.com',
      wsUrl: 'wss://s2-ws.sanguogame.com',
      isActive: true,
      isNew: false,
    ),
    ServerConfig(
      serverId: 's3',
      serverName: '三区·群雄逐鹿',
      apiUrl: 'https://s3-api.sanguogame.com',
      wsUrl: 'wss://s3-ws.sanguogame.com',
      isActive: true,
      isNew: false,
    ),
    ServerConfig(
      serverId: 's4',
      serverName: '四区·官渡之战',
      apiUrl: 'https://s4-api.sanguogame.com',
      wsUrl: 'wss://s4-ws.sanguogame.com',
      isActive: true,
      isNew: false,
    ),
    ServerConfig(
      serverId: 's5',
      serverName: '五区·赤壁烽烟',
      apiUrl: 'https://s5-api.sanguogame.com',
      wsUrl: 'wss://s5-ws.sanguogame.com',
      isActive: true,
      isNew: true,
    ),
    ServerConfig(
      serverId: 'cross_national',
      serverName: '跨服·国战',
      apiUrl: 'https://cross-api.sanguogame.com',
      wsUrl: 'wss://cross-ws.sanguogame.com',
      isActive: true,
      isNew: false,
    ),
  ];

  /// 根据 serverId 查找服务器配置
  static ServerConfig? findById(String serverId) {
    for (final server in defaultServers) {
      if (server.serverId == serverId) {
        return server;
      }
    }
    return null;
  }

  /// 获取所有活跃的服务器
  static List<ServerConfig> get activeServers =>
      defaultServers.where((s) => s.isActive).toList();

  /// 获取所有新服
  static List<ServerConfig> get newServers =>
      defaultServers.where((s) => s.isNew && s.isActive).toList();

  @override
  String toString() =>
      'ServerConfig(serverId: $serverId, serverName: $serverName, '
      'isActive: $isActive, isNew: $isNew)';
}
