import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config/app_config.dart';
import '../config/env_config.dart';
import '../constants/app_constants.dart';
import '../error/app_exception.dart';
import '../error/network_exception.dart';
import '../utils/logger.dart';
import 'api_interceptor.dart';
import 'api_result.dart';
import 'logging_interceptor.dart';
import 'response_interceptor.dart';
import 'retry_policy.dart';

/// HTTP 客户端封装
///
/// 基于 Dio 的 HTTP 客户端，提供统一的网络请求接口：
/// - 单例模式（通过 GetIt 注册）
/// - 自动配置 baseUrl、超时时间
/// - 内置请求/响应/日志拦截器
/// - 返回 [ApiResult<T>] 统一结果
/// - 支持 [CancelToken] 取消请求
///
/// 使用方式：
/// ```dart
/// // 注册到 GetIt
/// getIt.registerSingleton<HttpClient>(HttpClient(
///   envConfig: envConfig,
///   appConfig: appConfig,
///   secureStorage: secureStorage,
/// ));
///
/// // 发起请求
/// final client = getIt<HttpClient>();
/// final result = await client.get<Map<String, dynamic>>('/user/info');
/// result.when(
///   success: (data) => print(data),
///   failure: (e) => print(e.message),
///   loading: () => print('加载中'),
/// );
/// ```
class HttpClient {
  /// 创建 HTTP 客户端
  ///
  /// [envConfig] 环境配置，提供 baseUrl 等信息
  /// [appConfig] 应用配置，用于控制日志等行为
  /// [secureStorage] SecureStorage 实例，用于 Token 管理
  /// [dio] 可选的自定义 Dio 实例，便于测试
  HttpClient({
    required EnvConfig envConfig,
    required AppConfig appConfig,
    required FlutterSecureStorage secureStorage,
    Dio? dio,
  })  : _appConfig = appConfig,
        _apiInterceptor = ApiInterceptor(
          secureStorage: secureStorage,
          envConfig: envConfig,
        ),
        _dio = dio ?? _createDio(envConfig) {
    // 注入 Dio 实例到 ApiInterceptor（解决循环依赖）
    _apiInterceptor.setDio(_dio);

    // 添加拦截器（顺序很重要）
    _dio.interceptors.addAll([
      _apiInterceptor,
      ResponseInterceptor(),
      LoggingInterceptor(enabled: _appConfig.isDebug),
      RetryInterceptor(),
    ]);
  }

  /// Dio 实例
  final Dio _dio;

  /// API 拦截器引用（用于 Token 刷新）
  final ApiInterceptor _apiInterceptor;

  /// 应用配置，用于判断是否启用日志
  final AppConfig _appConfig;

  /// 创建 Dio 实例
  static Dio _createDio(EnvConfig envConfig) {
    return Dio(
      BaseOptions(
        baseUrl: envConfig.baseUrl,
        connectTimeout: AppConstants.connectTimeout,
        receiveTimeout: AppConstants.receiveTimeout,
        sendTimeout: AppConstants.sendTimeout,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        responseType: ResponseType.json,
      ),
    );
  }

  /// GET 请求
  ///
  /// [path] 请求路径（相对于 baseUrl）
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// [cancelToken] 取消令牌
  /// [fromJson] 数据反序列化函数
  ///
  /// 返回 [ApiResult<T>]，包含成功数据或失败异常
  Future<ApiResult<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    return _request<T>(
      path: path,
      method: 'GET',
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJson: fromJson,
    );
  }

  /// POST 请求
  ///
  /// [path] 请求路径（相对于 baseUrl）
  /// [data] 请求体数据
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// [cancelToken] 取消令牌
  /// [fromJson] 数据反序列化函数
  ///
  /// 返回 [ApiResult<T>]，包含成功数据或失败异常
  Future<ApiResult<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    return _request<T>(
      path: path,
      method: 'POST',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJson: fromJson,
    );
  }

  /// PUT 请求
  ///
  /// [path] 请求路径（相对于 baseUrl）
  /// [data] 请求体数据
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// [cancelToken] 取消令牌
  /// [fromJson] 数据反序列化函数
  ///
  /// 返回 [ApiResult<T>]，包含成功数据或失败异常
  Future<ApiResult<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    return _request<T>(
      path: path,
      method: 'PUT',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJson: fromJson,
    );
  }

  /// DELETE 请求
  ///
  /// [path] 请求路径（相对于 baseUrl）
  /// [data] 请求体数据
  /// [queryParameters] 查询参数
  /// [options] 请求选项
  /// [cancelToken] 取消令牌
  /// [fromJson] 数据反序列化函数
  ///
  /// 返回 [ApiResult<T>]，包含成功数据或失败异常
  Future<ApiResult<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    return _request<T>(
      path: path,
      method: 'DELETE',
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
      fromJson: fromJson,
    );
  }

  /// 通用请求方法
  ///
  /// 所有 HTTP 方法的底层实现，统一处理响应和异常
  Future<ApiResult<T>> _request<T>({
    required String path,
    required String method,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    try {
      final response = await _dio.request(
        path,
        data: data,
        queryParameters: queryParameters,
        options: (options ?? Options()).copyWith(method: method),
        cancelToken: cancelToken,
      );

      // 解析服务端统一响应格式
      final responseData = response.data;
      T? parsedData;

      if (responseData is Map<String, dynamic>) {
        // 服务端返回 code + data + message 格式
        final apiResponse = ApiResponse<T>.fromJson(
          responseData,
          fromJsonT: fromJson,
        );

        if (apiResponse.isSuccess) {
          parsedData = apiResponse.data;
        } else {
          // 业务错误已在 ResponseInterceptor 中处理
          // 如果走到这里，说明是未处理的业务错误
          return ApiFailure<T>(
            AppException(
              code: '${apiResponse.code}',
              message: apiResponse.message,
            ),
          );
        }
      } else {
        // 非 Map 类型响应，直接使用
        parsedData = responseData as T?;
      }

      return ApiSuccess<T>(parsedData as T);
    } on DioException catch (e) {
      // Dio 异常，提取 AppException
      final exception = _extractException(e);
      return ApiFailure<T>(exception);
    } on AppException catch (e) {
      // 已经是 AppException，直接使用
      return ApiFailure<T>(e);
    } catch (e) {
      // 未知异常
      AppLogger.error('HTTP 请求未知异常', e);
      return ApiFailure<T>(
        AppException(
          code: 'UNKNOWN_ERROR',
          message: '请求失败，请稍后重试',
          originalError: e,
        ),
      );
    }
  }

  /// 从 DioException 中提取 AppException
  AppException _extractException(DioException e) {
    if (e.error is AppException) {
      return e.error as AppException;
    }

    // 根据错误类型创建 NetworkException
    final url = e.requestOptions.uri.toString();

    return switch (e.type) {
      DioExceptionType.connectionTimeout => NetworkException.timeout(url: url),
      DioExceptionType.sendTimeout => NetworkException.timeout(url: url),
      DioExceptionType.receiveTimeout => NetworkException.timeout(url: url),
      DioExceptionType.transformTimeout => NetworkException.timeout(url: url),
      DioExceptionType.connectionError => NetworkException.noConnection(url: url),
      DioExceptionType.badResponse => _handleBadResponse(e, url),
      DioExceptionType.badCertificate => NetworkException.sslError(url: url),
      DioExceptionType.cancel => NetworkException(
          message: '请求已取消',
          url: url,
          code: 'NETWORK_CANCELLED',
        ),
      DioExceptionType.unknown => NetworkException(
          message: e.message ?? '网络错误',
          url: url,
          code: 'NETWORK_UNKNOWN',
          originalError: e.error,
          stackTrace: e.stackTrace,
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

  /// 下载文件
  ///
  /// [urlPath] 下载地址
  /// [savePath] 保存路径
  /// [onReceiveProgress] 下载进度回调
  /// [cancelToken] 取消令牌
  Future<Response> download(
    String urlPath,
    String savePath, {
    ProgressCallback? onReceiveProgress,
    CancelToken? cancelToken,
  }) {
    return _dio.download(
      urlPath,
      savePath,
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
  }

  /// 上传文件
  ///
  /// [path] 上传接口路径
  /// [formData] 表单数据（包含文件）
  /// [onSendProgress] 上传进度回调
  /// [cancelToken] 取消令牌
  Future<ApiResult<T>> upload<T>(
    String path,
    FormData formData, {
    ProgressCallback? onSendProgress,
    CancelToken? cancelToken,
    T Function(dynamic)? fromJson,
  }) async {
    return _request<T>(
      path: path,
      method: 'POST',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
      cancelToken: cancelToken,
      fromJson: fromJson,
    );
  }
}
