import 'package:dio/dio.dart';

import '../utils/logger.dart';

/// 日志拦截器
///
/// 仅在开发环境启用，打印请求和响应的详细信息，便于调试。
/// 通过构造函数 [enabled] 参数控制是否启用日志输出，建议根据
/// [AppConfig.isDebug] 判断传入。
///
/// 日志内容包括：
/// - 请求：URL、method、headers、body
/// - 响应：status code、data
/// - 错误：错误类型、错误消息、响应数据
///
/// 在 Release 模式下不输出任何日志，避免性能影响和信息泄露。
class LoggingInterceptor extends Interceptor {
  /// 创建日志拦截器
  ///
  /// [enabled] 是否启用，默认 false。建议传入 [AppConfig.isDebug]。
  /// ```dart
  /// LoggingInterceptor(enabled: appConfig.isDebug)
  /// ```
  LoggingInterceptor({this.enabled = false});

  /// 是否启用日志
  final bool enabled;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (!enabled) {
      handler.next(options);
      return;
    }

    final buffer = StringBuffer()
      ..writeln('╔══════════════════════════════════════════════════════════════')
      ..writeln('║ 🚀 请求发送')
      ..writeln('╟──────────────────────────────────────────────────────────────')
      ..writeln('║ Method: ${options.method}')
      ..writeln('║ URL: ${options.uri}')
      ..writeln('║ Headers:');

    options.headers.forEach((key, value) {
      buffer.writeln('║   $key: $value');
    });

    if (options.queryParameters.isNotEmpty) {
      buffer.writeln('║ Query Parameters:');
      options.queryParameters.forEach((key, value) {
        buffer.writeln('║   $key: $value');
      });
    }

    if (options.data != null) {
      buffer.writeln('║ Body: ${_truncate(options.data.toString())}');
    }

    buffer.writeln('╚══════════════════════════════════════════════════════════════');

    AppLogger.debug(buffer.toString());

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!enabled) {
      handler.next(response);
      return;
    }

    final buffer = StringBuffer()
      ..writeln('╔══════════════════════════════════════════════════════════════')
      ..writeln('║ ✅ 响应接收')
      ..writeln('╟──────────────────────────────────────────────────────────────')
      ..writeln('║ Status: ${response.statusCode} ${response.statusMessage}')
      ..writeln('║ URL: ${response.requestOptions.uri}')
      ..writeln('║ Data: ${_truncate(response.data?.toString() ?? 'null')}')
      ..writeln('╚══════════════════════════════════════════════════════════════');

    AppLogger.debug(buffer.toString());

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (!enabled) {
      handler.next(err);
      return;
    }

    final buffer = StringBuffer()
      ..writeln('╔══════════════════════════════════════════════════════════════')
      ..writeln('║ ❌ 请求错误')
      ..writeln('╟──────────────────────────────────────────────────────────────')
      ..writeln('║ Type: ${err.type}')
      ..writeln('║ URL: ${err.requestOptions.uri}')
      ..writeln('║ Message: ${err.message}');

    if (err.response != null) {
      buffer.writeln('║ Status: ${err.response?.statusCode}');
      buffer.writeln('║ Data: ${_truncate(err.response?.data?.toString() ?? 'null')}');
    }

    buffer.writeln('╚══════════════════════════════════════════════════════════════');

    AppLogger.error(buffer.toString(), err.error, err.stackTrace);

    handler.next(err);
  }

  /// 截断过长的字符串，避免日志刷屏
  String _truncate(String text, {int maxLength = 500}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}... (已截断，共${text.length}字符)';
  }
}
