import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:zhenyu_flutter/config/config.dart';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/screens/login/pre_login_screen.dart';
import 'package:zhenyu_flutter/services/user_provider.dart';
import 'package:zhenyu_flutter/utils/navigator.dart';

/// 自定义日志拦截器，只打印特定接口的日志
class SelectiveLoggerInterceptor extends Interceptor {
  // 需要打印日志的接口路径白名单
  final List<String> _whiteList = [
    '/v1/user/getUserProfile', // 获取用户配置
    '/api/index/indexUserList',
    '/api/recharge/vip/config',
    '/api/recharge/iosPay',
    // 在这里添加其他你需要调试的接口路径, 例如:
    // '/v1/posts/getPostList',
  ];

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    print("=3====${response.requestOptions.path}");
    print("=3====${_whiteList.contains(response.requestOptions.path)}");
    // 检查当前请求的路径是否在白名单中
    if (_whiteList.contains(response.requestOptions.path)) {
      // 如果在白名单中，则使用 PrettyDioLogger 打印该响应的日志
      // 为了复用 PrettyDioLogger 的格式化能力，我们为单个请求创建一个实例
      final logger = PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: false, // 使用 false 来获得更详细的格式
        maxWidth: 120,
      );

      // PrettyDioLogger 没有直接打印单个 response 的方法，
      // 所以我们模拟一下它的行为，手动打印日志。
      // 这是一个简化的实现，主要为了演示。
      // 更完善的做法是深入研究 PrettyDioLogger 的源码，看是否可以复用其内部格式化逻辑。
      print('--- Dio Response ---');
      print('Uri: ${response.requestOptions.uri}');
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${jsonEncode(response.data)}');
      print('--------------------');
    }
    // 必须调用 handler.next(response) 来继续请求链
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 同样，只对白名单中的接口打印错误日志
    if (_whiteList.contains(err.requestOptions.path)) {
      final logger = PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: false,
        maxWidth: 120,
      );
      // logger.onError(err, handler); // PrettyDioLogger v5.0.0+ has this method
      // For older versions, we might need to manually log the error.
      print('--- Dio Error ---');
      print('Uri: ${err.requestOptions.uri}');
      print('Error: ${err.error}');
      print('-----------------');
    }
    super.onError(err, handler);
  }
}

class Http {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.baseURL,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  static late UserProvider _userProvider;

  static void initialize(UserProvider userProvider) {
    _userProvider = userProvider;
    // 只在 Debug 模式下添加日志拦截器
    if (kDebugMode) {
      // 使用我们自定义的选择性日志拦截器
      // _dio.interceptors.add(SelectiveLoggerInterceptor());

      // 原来的 PrettyDioLogger 会打印所有请求，我们把它注释掉
      _dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 90,
        ),
      );
    }

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // --- 1. 获取动态参数 ---
          final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
          final requestId = "${timestamp}123345";

          final token = _userProvider.token ?? "";
          final sign = _getSign(timestamp, requestId, token);

          // --- 2. 获取设备信息 ---
          String deviceId = '';
          String platform = 'h5';
          String osVersion = '';
          String smDeviceId = '';

          final deviceInfo = DeviceInfoPlugin();
          if (Platform.isAndroid) {
            final androidInfo = await deviceInfo.androidInfo;
            deviceId = androidInfo.id;
            platform = 'android';
            osVersion = androidInfo.version.release;
          } else if (Platform.isIOS) {
            final iosInfo = await deviceInfo.iosInfo;
            deviceId = iosInfo.identifierForVendor ?? '';
            platform = 'ios';
            osVersion = iosInfo.systemVersion;
          }

          // --- 3. 组合请求头 ---
          options.headers.addAll({
            "userToken": token,
            "tenant-id": 1,
            "deviceId": deviceId,
            "sign": sign,
            "platform": platform,
            "osVersion": osVersion,
            "version": "10.1.0",
            "smDeviceId": smDeviceId,
            "timestamp": timestamp,
            "requestId": requestId,
            // 以下字段在 uniapp 代码中为空，暂时保留
            "androidId": "",
            "comeFrom": "",
            "oaId": "",
            "pModel": "",
            "pkg": "",
            "tsign": "",
          });

          return handler.next(options);
        },
        onResponse: (response, handler) {
          final data = response.data;
          // --- 4. 统一响应处理 ---
          if (data is Map<String, dynamic>) {
            final code = data['code'];
            final message = data['message'] ?? '';

            if (code == 1300 ||
                message.contains("重新登录") ||
                message.contains("Token")) {
              _handleTokenExpired();
              return handler.reject(
                DioException(
                  requestOptions: response.requestOptions,
                  response: response,
                  error: 'Token expired',
                ),
              );
            }
            if (code == 2004) {
              // TODO: 处理余额不足，例如跳转到钱包页
              // _navigateToMyWallet();
            }
          }
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          // TODO: 统一错误处理，例如上报错误日志
          return handler.next(e);
        },
      ),
    );
  }

  /// 公共请求方法
  static Future<Response<T>> request<T>(
    String url, {
    String method = 'GET',
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
  }) {
    return _dio.request(
      url,
      data: data,
      options: Options(method: method),
      cancelToken: cancelToken,
    );
  }

  static Future<Response<T>> post<T>(
    String url, {
    Map<String, dynamic>? data,
    CancelToken? cancelToken,
  }) {
    return request(url, method: 'POST', data: data, cancelToken: cancelToken);
  }

  /// 生成签名
  static String _getSign(String timestamp, String requestId, String token) {
    final timestampSign = sha1
        .convert(utf8.encode("security$timestamp"))
        .toString();
    return md5
        .convert(
          utf8.encode("$token" + "pv" + timestampSign + "r_id" + requestId),
        )
        .toString();
  }

  /// 处理 Token 失效
  static void _handleTokenExpired() {
    // 1. 调用 UserProvider 清空状态
    _userProvider.logout();

    // 2. 跳转到登录页
    final context = NavigatorUtils.navigatorKey.currentContext;
    if (context != null) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const PreLoginScreen()),
        (Route<dynamic> route) => false, // 清空所有路由
      );
    }
  }
}
