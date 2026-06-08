import 'dart:async';

import 'package:dio/dio.dart';

import '../utils/logger.dart';

/// 重试策略配置
///
/// 定义网络请求的重试行为，包括最大重试次数、退避延迟和可重试条件。
/// 支持指数退避算法，避免在服务器压力大时频繁重试。
///
/// 示例：
/// ```dart
/// final policy = RetryPolicy(
///   maxRetries: 3,
///   baseDelay: Duration(seconds: 1),
/// );
/// ```
class RetryPolicy {
  /// 创建重试策略
  const RetryPolicy({
    this.maxRetries = 3,
    this.baseDelay = const Duration(seconds: 1),
    this.maxDelay = const Duration(seconds: 30),
    this.retryable = _defaultRetryable,
  });

  /// 最大重试次数，默认 3 次
  final int maxRetries;

  /// 基础退避延迟，默认 1 秒
  ///
  /// 实际延迟为 baseDelay * 2^retryCount：
  /// - 第1次重试：1秒
  /// - 第2次重试：2秒
  /// - 第3次重试：4秒
  final Duration baseDelay;

  /// 最大退避延迟，默认 30 秒
  ///
  /// 即使指数增长也不会超过此值
  final Duration maxDelay;

  /// 判断错误是否可重试的回调
  ///
  /// 默认仅对网络超时、无连接、服务器错误（5xx）和连接重试进行重试。
  final bool Function(DioException error) retryable;

  /// 默认可重试条件：仅网络错误重试
  ///
  /// 可重试的错误类型：
  /// - 连接超时
  /// - 接收超时
  /// - 发送超时
  /// - 连接错误（无网络）
  /// - 服务器错误（5xx 状态码）
  static bool _defaultRetryable(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        // 仅 5xx 服务器错误重试
        return statusCode != null && statusCode >= 500;
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        return false;
    }
  }

  /// 计算第 [retryCount] 次重试的延迟时间
  ///
  /// 使用指数退避算法：baseDelay * 2^retryCount
  /// 不超过 [maxDelay]
  Duration delayFor(int retryCount) {
    final exponentialDelay = baseDelay * (1 << retryCount); // 2^retryCount
    return exponentialDelay > maxDelay ? maxDelay : exponentialDelay;
  }

  /// 执行带重试的异步操作
  ///
  /// [action] 需要重试的异步操作
  /// 返回操作结果或抛出最后一次的异常
  Future<T> execute<T>(Future<T> Function() action) async {
    int retryCount = 0;

    while (true) {
      try {
        return await action();
      } on DioException catch (e) {
        if (retryCount >= maxRetries || !retryable(e)) {
          rethrow;
        }

        final delay = delayFor(retryCount);
        AppLogger.warning(
          '请求失败，${delay.inSeconds}秒后进行第${retryCount + 1}次重试（最多$maxRetries次）',
          e,
        );

        await Future.delayed(delay);
        retryCount++;
      }
    }
  }
}

/// Dio 重试拦截器
///
/// 集成到 Dio 请求管道中，自动对失败请求进行重试。
/// 遵循 [RetryPolicy] 配置的重试策略。
///
/// 使用方式：
/// ```dart
/// dio.interceptors.add(RetryInterceptor(
///   policy: RetryPolicy(maxRetries: 3),
/// ));
/// ```
class RetryInterceptor extends Interceptor {
  /// 创建重试拦截器
  RetryInterceptor({RetryPolicy? policy})
      : policy = policy ?? const RetryPolicy();

  /// 重试策略
  final RetryPolicy policy;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // 获取已重试次数
    final retryCount = (err.requestOptions.extra['retryCount'] as int?) ?? 0;

    // 判断是否可重试
    if (retryCount < policy.maxRetries && policy.retryable(err)) {
      // 计算退避延迟
      final delay = policy.delayFor(retryCount);
      AppLogger.warning(
        '请求失败，${delay.inSeconds}秒后进行第${retryCount + 1}次重试',
        err,
      );

      // 等待退避时间
      await Future.delayed(delay);

      try {
        // 更新重试次数
        err.requestOptions.extra['retryCount'] = retryCount + 1;

        // 重新发起请求，使用 BaseOptions 从 RequestOptions 构建
        final opts = err.requestOptions;
        final baseOptions = BaseOptions(
          baseUrl: opts.baseUrl,
          connectTimeout: opts.connectTimeout,
          receiveTimeout: opts.receiveTimeout,
          sendTimeout: opts.sendTimeout,
          headers: opts.headers,
          responseType: opts.responseType,
          contentType: opts.contentType,
        );
        final dio = Dio(baseOptions);
        // 移除重试拦截器避免无限嵌套
        dio.interceptors.removeWhere((i) => i is RetryInterceptor);

        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
      } on DioException catch (e) {
        // 重试后仍然失败，继续传递错误
        handler.next(e);
      } catch (e) {
        // 非网络错误，继续传递
        handler.next(
          DioException(
            requestOptions: err.requestOptions,
            error: e,
          ),
        );
      }
    } else {
      // 已达最大重试次数或不可重试，继续传递错误
      handler.next(err);
    }
  }
}
