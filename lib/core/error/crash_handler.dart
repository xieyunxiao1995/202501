import 'dart:async';

import 'package:flutter/widgets.dart';

import 'error_handler.dart';

/// 崩溃捕获器，使用 Zone 包裹 runApp
///
/// 提供两层异常捕获：
/// 1. [runInZone] - 使用 [runZonedGuarded] 捕获异步异常
/// 2. [FlutterError.onError] - 捕获 Flutter 框架异常
///
/// 使用方式：
/// ```dart
/// void main() {
///   CrashHandler.runInZone(() {
///     runApp(const MyApp());
///   });
/// }
/// ```
class CrashHandler {
  CrashHandler._();

  /// 在错误捕获 Zone 中运行应用
  ///
  /// 同时注册 Flutter 框架错误回调，确保所有未捕获的异常
  /// 都能被记录到日志和崩溃上报系统。
  static void runInZone(void Function() appRunner) {
    // 捕获 Flutter 框架异常
    FlutterError.onError = _onFlutterError;

    // 捕获异步异常
    runZonedGuarded<void>(
      appRunner,
      _onZoneError,
    );
  }

  /// Flutter 框架错误回调
  static void _onFlutterError(FlutterErrorDetails details) {
    // 保留默认的控制台打印行为
    FlutterError.presentError(details);

    // 上报错误
    ErrorHandler.reportError(
      details.exception,
      stackTrace: details.stack,
    );
  }

  /// Zone 错误回调
  static void _onZoneError(Object error, StackTrace stackTrace) {
    ErrorHandler.reportError(error, stackTrace: stackTrace);

    // 在调试模式下，将未捕获的异步异常也输出到控制台
    debugPrint('=== 未捕获的异步异常 ===');
    debugPrint('Error: $error');
    debugPrint('StackTrace: $stackTrace');
  }
}
