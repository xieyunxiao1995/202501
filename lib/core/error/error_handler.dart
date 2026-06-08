import 'dart:async';

import 'package:logger/logger.dart';

import 'app_exception.dart';
import 'business_exception.dart';
import 'network_exception.dart';
import 'server_exception.dart';

/// 全局错误处理器
///
/// 提供统一的异常处理和上报能力：
/// - [handleError] 将异常转换为用户友好的错误消息
/// - [reportError] 将异常记录到日志和崩溃上报系统
class ErrorHandler {
  ErrorHandler._();

  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,
      errorMethodCount: 8,
      lineLength: 120,
      colors: true,
      printEmojis: true,
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
  );

  /// 默认错误消息
  static const String _defaultErrorMessage = '操作失败，请稍后重试';

  /// 处理异常，返回用户友好的错误消息
  ///
  /// 根据异常类型返回不同的提示信息：
  /// - [AppException] 及其子类：返回 [AppException.message]
  /// - [FormatException]：返回格式错误提示
  /// - [TimeoutException]：返回超时提示
  /// - 其他未知异常：返回默认提示
  static String handleError(dynamic error, {StackTrace? stackTrace}) {
    if (error is AppException) {
      return error.message;
    }

    if (error is FormatException) {
      return '数据格式错误';
    }

    if (error is TimeoutException) {
      return '请求超时，请重试';
    }

    if (error is StateError) {
      return '状态异常，请重试';
    }

    if (error is ArgumentError) {
      return '参数错误';
    }

    // 未知异常类型，记录并返回默认消息
    reportError(error, stackTrace: stackTrace);
    return _defaultErrorMessage;
  }

  /// 记录错误到日志和崩溃上报
  ///
  /// 根据异常类型选择不同的日志级别：
  /// - [BusinessException]：warning 级别（业务异常属于正常流程）
  /// - [NetworkException]：error 级别
  /// - [ServerException]：error 级别
  /// - 其他：fatal 级别（未知异常）
  static void reportError(dynamic error, {StackTrace? stackTrace}) {
    if (error is AppException) {
      _logAppException(error, stackTrace);
    } else {
      _logger.f(
        '未捕获的异常',
        error: error,
        stackTrace: stackTrace,
      );
    }

    // TODO: 接入 Firebase Crashlytics 崩溃上报
    // FirebaseCrashlytics.instance.recordError(
    //   error,
    //   stackTrace,
    //   reason: 'ErrorHandler.reportError',
    // );
  }

  /// 根据异常类型记录日志
  static void _logAppException(AppException error, StackTrace? stackTrace) {
    final trace = error.stackTrace ?? stackTrace;

    if (error is BusinessException) {
      // 业务异常属于正常流程，使用 warning 级别
      _logger.w(
        '${error.code}: ${error.message}',
        error: error.originalError,
        stackTrace: trace,
      );
    } else if (error is NetworkException) {
      _logger.e(
        '${error.code}(${error.statusCode ?? "N/A"}): ${error.message}',
        error: error.originalError,
        stackTrace: trace,
      );
    } else if (error is ServerException) {
      _logger.e(
        '${error.code}(serverCode: ${error.serverCode ?? "N/A"}): ${error.message}',
        error: error.originalError,
        stackTrace: trace,
      );
    } else {
      _logger.e(
        '${error.code}: ${error.message}',
        error: error.originalError,
        stackTrace: trace,
      );
    }
  }

  /// 判断是否为可重试的错误
  ///
  /// 网络超时、无连接、服务器繁忙等错误通常可以重试。
  static bool isRetryable(dynamic error) {
    if (error is NetworkException) {
      return error.code == 'NETWORK_TIMEOUT' ||
          error.code == 'NETWORK_NO_CONNECTION' ||
          error.code == 'NETWORK_CONNECTION_RESET' ||
          error.code == 'NETWORK_SERVER_ERROR';
    }
    if (error is ServerException) {
      return error.code == 'SERVER_BUSY' || error.code == 'SERVER_MAINTENANCE';
    }
    return false;
  }

  /// 判断是否为认证错误（需要重新登录）
  static bool isAuthError(dynamic error) {
    if (error is NetworkException) {
      return error.code == 'NETWORK_UNAUTHORIZED' || error.statusCode == 401;
    }
    if (error is ServerException) {
      return error.code == 'SERVER_TOKEN_EXPIRED';
    }
    return false;
  }
}
