import 'package:dio/dio.dart';

import '../error/app_exception.dart';
import '../error/network_exception.dart';
import '../error/server_exception.dart';
import '../utils/logger.dart';

/// 服务端统一响应格式
///
/// 标准的服务端返回格式，包含状态码、数据和消息：
/// ```json
/// {
///   "code": 0,
///   "data": { ... },
///   "message": "success"
/// }
/// ```
class ApiResponse<T> {
  /// 创建 API 响应
  const ApiResponse({
    required this.code,
    this.data,
    this.message = '',
  });

  /// 从 JSON Map 创建 ApiResponse
  factory ApiResponse.fromJson(
    Map<String, dynamic> json, {
    T Function(dynamic)? fromJsonT,
  }) {
    return ApiResponse<T>(
      code: json['code'] as int? ?? -1,
      data: json['data'] != null && fromJsonT != null
          ? fromJsonT(json['data'])
          : json['data'] as T?,
      message: json['message'] as String? ?? '',
    );
  }

  /// 服务端状态码，0 表示成功
  final int code;

  /// 响应数据
  final T? data;

  /// 响应消息
  final String message;

  /// 是否成功（code == 0）
  bool get isSuccess => code == 0;

  @override
  String toString() => 'ApiResponse(code: $code, message: $message, data: $data)';
}

/// 响应拦截器
///
/// 统一解包服务端响应，处理业务错误和网络错误：
/// - 成功响应（code == 0）：直接透传 data 部分
/// - 业务错误（code != 0）：抛出 [ServerException]
/// - 网络错误：将 [DioException] 转换为 [NetworkException]
///
/// 使用方式：
/// ```dart
/// dio.interceptors.add(ResponseInterceptor());
/// ```
class ResponseInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // 如果响应数据不是 Map 类型，直接透传
    final data = response.data;
    if (data is! Map<String, dynamic>) {
      handler.next(response);
      return;
    }

    // 解析服务端统一响应格式
    final code = data['code'] as int?;
    final message = data['message'] as String? ?? '';

    // code == 0 表示成功
    if (code == 0) {
      handler.next(response);
      return;
    }

    // code != 0 表示业务错误，抛出 ServerException
    AppLogger.warning('服务端业务错误: code=$code, message=$message');

    // 根据常见错误码创建对应的异常
    final exception = _createServerException(code, message, data);

    handler.reject(
      DioException(
        requestOptions: response.requestOptions,
        response: response,
        error: exception,
      ),
    );
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 如果错误已经是 AppException 类型（由本拦截器或其他拦截器转换），
    // 直接传递
    if (err.error is AppException) {
      handler.next(err);
      return;
    }

    // 将 DioException 转换为 NetworkException
    final networkException = _convertToNetworkException(err);

    // 创建新的 DioException，携带 NetworkException
    final newError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: networkException,
    );

    handler.next(newError);
  }

  /// 根据服务端错误码创建对应的 ServerException
  ServerException _createServerException(
    int? code,
    String message,
    Map<String, dynamic> data,
  ) {
    return switch (code) {
      10001 => ServerException.maintenance(data: data),
      10002 => ServerException.versionTooOld(data: data),
      10003 => ServerException.busy(data: data),
      10004 => ServerException.validationFailed(
          message: message,
          data: data,
        ),
      10005 => ServerException.accountBanned(data: data),
      10006 => ServerException.tokenExpired(data: data),
      10007 => ServerException.rateLimited(data: data),
      _ => ServerException(
          message: message.isNotEmpty ? message : '服务器错误',
          serverCode: code,
          data: data,
        ),
    };
  }

  /// 将 DioException 转换为 NetworkException
  NetworkException _convertToNetworkException(DioException err) {
    final url = err.requestOptions.uri.toString();

    return switch (err.type) {
      DioExceptionType.connectionTimeout => NetworkException.timeout(url: url),
      DioExceptionType.sendTimeout => NetworkException.timeout(url: url),
      DioExceptionType.receiveTimeout => NetworkException.timeout(url: url),
      DioExceptionType.connectionError => NetworkException.noConnection(url: url),
      DioExceptionType.badResponse => _handleBadResponse(err, url),
      DioExceptionType.badCertificate => NetworkException.sslError(url: url),
      DioExceptionType.cancel => NetworkException(
          message: '请求已取消',
          url: url,
          code: 'NETWORK_CANCELLED',
        ),
      DioExceptionType.unknown => NetworkException(
          message: err.message ?? '网络错误',
          url: url,
          code: 'NETWORK_UNKNOWN',
          originalError: err.error,
          stackTrace: err.stackTrace,
        ),
    };
  }

  /// 处理 HTTP 错误响应
  NetworkException _handleBadResponse(DioException err, String url) {
    final statusCode = err.response?.statusCode;

    return switch (statusCode) {
      400 => NetworkException.badRequest(url: url),
      401 => NetworkException.unauthorized(url: url),
      403 => NetworkException.forbidden(url: url),
      404 => NetworkException.notFound(url: url),
      int() when statusCode >= 500 =>
        NetworkException.serverError(statusCode, url: url),
      _ => NetworkException(
          message: '请求失败（$statusCode）',
          statusCode: statusCode,
          url: url,
          code: 'NETWORK_BAD_RESPONSE',
          originalError: err.error,
          stackTrace: err.stackTrace,
        ),
    };
  }
}
