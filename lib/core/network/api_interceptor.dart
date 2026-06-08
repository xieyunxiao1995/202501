import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../config/env_config.dart';
import '../constants/app_constants.dart';
import '../utils/logger.dart';
import '../utils/sign_utils.dart';

/// API 请求拦截器
///
/// 自动为每个请求注入认证信息和通用参数：
/// - 自动注入 Auth Token（从 SecureStorage 读取）
/// - 请求签名（调用 SignUtils）
/// - 添加通用 headers（app-version, device-id, timestamp, sign）
/// - Token 过期自动刷新逻辑（401 时调用 refresh token API）
///
/// 使用方式：
/// ```dart
/// dio.interceptors.add(ApiInterceptor(
///   secureStorage: secureStorage,
///   envConfig: envConfig,
/// ));
/// ```
class ApiInterceptor extends Interceptor {
  /// 创建 API 请求拦截器
  ///
  /// [secureStorage] SecureStorage 实例，用于 Token 管理
  /// [envConfig] 环境配置，提供签名密钥
  /// [dio] 可选的 Dio 实例，用于 Token 刷新请求
  ApiInterceptor({
    required FlutterSecureStorage secureStorage,
    required EnvConfig envConfig,
    Dio? dio,
  })  : _secureStorage = secureStorage,
        _envConfig = envConfig,
        _dio = dio;

  /// SecureStorage 实例，用于读取/存储 Token
  final FlutterSecureStorage _secureStorage;

  /// 环境配置，提供签名密钥
  final EnvConfig _envConfig;

  /// Dio 实例，用于 Token 刷新请求
  Dio? _dio;

  /// 是否正在刷新 Token
  bool _isRefreshing = false;

  /// Token 刷新期间等待的请求队列
  final List<_RetryRequest> _retryQueue = [];

  /// 设备 ID（缓存）
  String? _deviceId;

  /// 应用版本（缓存）
  String? _appVersion;

  /// 设置 Dio 实例（用于 Token 刷新）
  ///
  /// 由于 ApiInterceptor 和 HttpClient 之间存在循环依赖，
  /// 可以在 HttpClient 创建后通过此方法注入 Dio 实例。
  void setDio(Dio dio) {
    _dio = dio;
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      // 1. 注入 Auth Token
      final token = await _secureStorage.read(key: AppConstants.tokenKey);
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }

      // 2. 注入通用 headers
      await _injectCommonHeaders(options);

      // 3. 添加时间戳
      final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      options.headers['timestamp'] = timestamp;

      // 4. 请求签名
      // 合并查询参数和请求体参数用于签名
      final allParams = <String, dynamic>{
        ...options.queryParameters,
        'timestamp': timestamp,
        if (token != null) 'token': token,
      };
      if (options.data is Map<String, dynamic>) {
        allParams.addAll(options.data as Map<String, dynamic>);
      }
      final sign = SignUtils.signWithTimestamp(
        allParams,
        _envConfig.apiKey,
      );
      options.headers['sign'] = sign;

      handler.next(options);
    } catch (e) {
      AppLogger.error('API 拦截器 onRequest 异常', e);
      handler.next(options);
    }
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 处理 401 Token 过期
    if (_isTokenExpired(err)) {
      try {
        // 如果正在刷新 Token，将请求加入等待队列
        if (_isRefreshing) {
          _retryQueue.add(_RetryRequest(options: err.requestOptions, handler: handler));
          return;
        }

        _isRefreshing = true;

        // 尝试刷新 Token
        final newToken = await _refreshToken();

        if (newToken != null) {
          // Token 刷新成功，重试当前请求
          final newOptions = err.requestOptions.copyWith(
            headers: {
              ...err.requestOptions.headers,
              'Authorization': 'Bearer $newToken',
            },
          );

          try {
            final response = await _dio!.fetch(newOptions);
            handler.resolve(response);
          } on DioException catch (e) {
            handler.next(e);
          }

          // 重试等待队列中的请求
          _retryPendingRequests(newToken);
        } else {
          // Token 刷新失败，清除 Token 并通知需要重新登录
          await _clearToken();
          _rejectPendingRequests(err);
          handler.next(err);
        }
      } catch (e) {
        // Token 刷新过程出错
        await _clearToken();
        _rejectPendingRequests(err);
        handler.next(err);
      } finally {
        _isRefreshing = false;
      }
    } else {
      handler.next(err);
    }
  }

  /// 注入通用 headers
  Future<void> _injectCommonHeaders(RequestOptions options) async {
    // 应用版本
    _appVersion ??= await _getAppVersion();
    options.headers['app-version'] = _appVersion;

    // 设备 ID
    _deviceId ??= await _getDeviceId();
    options.headers['device-id'] = _deviceId;

    // 平台信息
    options.headers['platform'] = Platform.operatingSystem;
  }

  /// 获取应用版本
  Future<String> _getAppVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.version;
    } catch (e) {
      AppLogger.warning('获取应用版本失败', e);
      return 'unknown';
    }
  }

  /// 获取设备 ID
  Future<String> _getDeviceId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return androidInfo.id;
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return iosInfo.identifierForVendor ?? 'unknown';
      }
      return 'unknown';
    } catch (e) {
      AppLogger.warning('获取设备ID失败', e);
      return 'unknown';
    }
  }

  /// 判断是否是 Token 过期错误
  bool _isTokenExpired(DioException err) {
    final statusCode = err.response?.statusCode;
    if (statusCode == 401) return true;

    // 检查服务端返回的业务错误码
    final data = err.response?.data;
    if (data is Map<String, dynamic>) {
      final code = data['code'] as int?;
      return code == 10006; // SERVER_TOKEN_EXPIRED
    }

    return false;
  }

  /// 刷新 Token
  ///
  /// 从 SecureStorage 读取 refreshToken，调用刷新接口获取新 Token
  Future<String?> _refreshToken() async {
    if (_dio == null) {
      AppLogger.error('Dio 实例未设置，无法刷新 Token');
      return null;
    }

    try {
      final refreshToken = await _secureStorage.read(
        key: AppConstants.refreshTokenKey,
      );

      if (refreshToken == null || refreshToken.isEmpty) {
        AppLogger.warning('Refresh Token 不存在，无法刷新');
        return null;
      }

      final response = await _dio!.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
        options: Options(
          headers: {'Authorization': ''}, // 刷新接口不需要旧 Token
        ),
      );

      final data = response.data as Map<String, dynamic>?;
      if (data != null && data['code'] == 0) {
        final tokenData = data['data'] as Map<String, dynamic>?;
        if (tokenData != null) {
          final newToken = tokenData['token'] as String?;
          final newRefreshToken = tokenData['refreshToken'] as String?;

          if (newToken != null) {
            // 保存新 Token
            await _secureStorage.write(
              key: AppConstants.tokenKey,
              value: newToken,
            );
            if (newRefreshToken != null) {
              await _secureStorage.write(
                key: AppConstants.refreshTokenKey,
                value: newRefreshToken,
              );
            }
            AppLogger.info('Token 刷新成功');
            return newToken;
          }
        }
      }

      AppLogger.warning('Token 刷新响应异常');
      return null;
    } catch (e) {
      AppLogger.error('Token 刷新失败', e);
      return null;
    }
  }

  /// 清除本地 Token
  Future<void> _clearToken() async {
    try {
      await _secureStorage.delete(key: AppConstants.tokenKey);
      await _secureStorage.delete(key: AppConstants.refreshTokenKey);
      AppLogger.info('本地 Token 已清除');
    } catch (e) {
      AppLogger.error('清除 Token 失败', e);
    }
  }

  /// 重试等待队列中的请求
  void _retryPendingRequests(String newToken) {
    for (final retryRequest in _retryQueue) {
      final newOptions = retryRequest.options.copyWith(
        headers: {
          ...retryRequest.options.headers,
          'Authorization': 'Bearer $newToken',
        },
      );

      _dio!.fetch(newOptions).then((response) {
        retryRequest.handler.resolve(response);
      }).catchError((error) {
        if (error is DioException) {
          retryRequest.handler.next(error);
        } else {
          retryRequest.handler.next(
            DioException(
              requestOptions: retryRequest.options,
              error: error,
            ),
          );
        }
      });
    }
    _retryQueue.clear();
  }

  /// 拒绝等待队列中的请求
  void _rejectPendingRequests(DioException originalError) {
    for (final retryRequest in _retryQueue) {
      retryRequest.handler.next(originalError);
    }
    _retryQueue.clear();
  }
}

/// 等待重试的请求
class _RetryRequest {
  /// 创建等待重试的请求
  _RetryRequest({
    required this.options,
    required this.handler,
  });

  /// 请求配置
  final RequestOptions options;

  /// 拦截器处理器
  final ErrorInterceptorHandler handler;
}
