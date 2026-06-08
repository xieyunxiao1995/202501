import 'app_config.dart';

/// 环境配置，根据不同环境提供不同的服务器地址
///
/// 包含 API 地址、WebSocket 地址、CDN 地址和 API Key 等配置。
/// 为每种环境预定义了常量配置，也可通过 [fromEnvironment] 根据环境枚举获取。
///
/// 使用方式：
/// ```dart
/// final env = AppEnvironment.development;
/// final config = EnvConfig.fromEnvironment(env);
/// print(config.baseUrl); // https://dev-api.sanguogame.com
/// ```
class EnvConfig {
  /// 创建环境配置
  const EnvConfig({
    required this.baseUrl,
    required this.wsUrl,
    required this.cdnUrl,
    required this.apiKey,
  });

  /// API 基础地址
  final String baseUrl;

  /// WebSocket 地址
  final String wsUrl;

  /// CDN 地址
  final String cdnUrl;

  /// API 密钥
  final String apiKey;

  /// 开发环境配置
  static const development = EnvConfig(
    baseUrl: 'https://dev-api.sanguogame.com',
    wsUrl: 'wss://dev-ws.sanguogame.com',
    cdnUrl: 'https://dev-cdn.sanguogame.com',
    apiKey: 'dev_api_key',
  );

  /// 预发布环境配置
  static const staging = EnvConfig(
    baseUrl: 'https://staging-api.sanguogame.com',
    wsUrl: 'wss://staging-ws.sanguogame.com',
    cdnUrl: 'https://staging-cdn.sanguogame.com',
    apiKey: 'staging_api_key',
  );

  /// 生产环境配置
  static const production = EnvConfig(
    baseUrl: 'https://api.sanguogame.com',
    wsUrl: 'wss://ws.sanguogame.com',
    cdnUrl: 'https://cdn.sanguogame.com',
    apiKey: 'prod_api_key',
  );

  /// 根据环境枚举获取对应的配置
  static EnvConfig fromEnvironment(AppEnvironment env) => switch (env) {
        AppEnvironment.development => development,
        AppEnvironment.staging => staging,
        AppEnvironment.production => production,
      };

  @override
  String toString() =>
      'EnvConfig(baseUrl: $baseUrl, wsUrl: $wsUrl, cdnUrl: $cdnUrl)';
}
