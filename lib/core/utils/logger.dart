import 'package:logger/logger.dart';

/// 日志工具，封装 logger 包
///
/// 提供统一的日志输出接口，支持 debug/info/warning/error/fatal 五个级别。
/// 在 Release 模式下可通过 [setLevel] 关闭低级别日志。
class AppLogger {
  AppLogger._();

  static Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// 设置日志级别，Release 模式可调用 setLevel(Level.nothing) 关闭日志
  static void setLevel(Level level) {
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
      ),
      level: level,
    );
  }

  /// 调试日志
  static void debug(String message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.d(message, error: error, stackTrace: stackTrace);

  /// 信息日志
  static void info(String message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.i(message, error: error, stackTrace: stackTrace);

  /// 警告日志
  static void warning(String message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.w(message, error: error, stackTrace: stackTrace);

  /// 错误日志
  static void error(String message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.e(message, error: error, stackTrace: stackTrace);

  /// 严重错误日志
  static void fatal(String message, [dynamic error, StackTrace? stackTrace]) =>
      _logger.f(message, error: error, stackTrace: stackTrace);
}
