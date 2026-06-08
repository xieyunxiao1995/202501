/// 应用运行环境
enum AppEnvironment {
  /// 开发环境
  development,

  /// 预发布环境
  staging,

  /// 生产环境
  production,
}

/// 应用全局配置
///
/// 包含应用名称、版本号、环境信息、调试开关等全局配置项。
/// 通过构造函数注入不同环境的配置。
///
/// 使用方式：
/// ```dart
/// final config = AppConfig(
///   environment: AppEnvironment.production,
///   isDebug: false,
/// );
/// ```
class AppConfig {
  /// 创建应用配置
  const AppConfig({
    this.environment = AppEnvironment.development,
    this.isDebug = true,
    this.enableLogging = true,
    this.enablePerformanceMonitor = false,
  });

  /// 应用名称
  static const String appName = '三国谋定天下';

  /// 应用版本号
  static const String appVersion = '0.1.0';

  /// 应用构建号
  static const int appBuildNumber = 1;

  /// 当前环境
  final AppEnvironment environment;

  /// 是否调试模式
  final bool isDebug;

  /// 是否开启日志
  final bool enableLogging;

  /// 是否开启性能监控
  final bool enablePerformanceMonitor;

  /// 是否为生产环境
  bool get isProduction => environment == AppEnvironment.production;

  /// 是否为开发环境
  bool get isDevelopment => environment == AppEnvironment.development;

  /// 是否为预发布环境
  bool get isStaging => environment == AppEnvironment.staging;

  /// 环境名称
  String get environmentName => switch (environment) {
        AppEnvironment.development => '开发',
        AppEnvironment.staging => '预发布',
        AppEnvironment.production => '生产',
      };

  @override
  String toString() =>
      'AppConfig(environment: $environmentName, isDebug: $isDebug, '
      'enableLogging: $enableLogging, enablePerformanceMonitor: $enablePerformanceMonitor)';
}
