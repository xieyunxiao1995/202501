import 'app_exception.dart';

/// 网络异常，包含 HTTP 状态码
///
/// 用于表示网络层面的错误，如超时、无连接、服务器错误等。
/// 包含可选的 [statusCode] 和请求 [url] 信息。
class NetworkException extends AppException {
  /// 创建网络异常
  const NetworkException({
    required super.message,
    this.statusCode,
    this.url,
    super.code = 'NETWORK_ERROR',
    super.stackTrace,
    super.originalError,
  });

  /// 请求超时
  factory NetworkException.timeout({String? url}) => NetworkException(
        message: '请求超时，请检查网络连接后重试',
        statusCode: null,
        url: url,
        code: 'NETWORK_TIMEOUT',
      );

  /// 无网络连接
  factory NetworkException.noConnection({String? url}) => NetworkException(
        message: '网络连接不可用，请检查网络设置',
        statusCode: null,
        url: url,
        code: 'NETWORK_NO_CONNECTION',
      );

  /// 服务器错误（5xx）
  factory NetworkException.serverError(int statusCode, {String? url}) =>
      NetworkException(
        message: '服务器开小差了，请稍后重试（$statusCode）',
        statusCode: statusCode,
        url: url,
        code: 'NETWORK_SERVER_ERROR',
      );

  /// 请求被拒绝（403）
  factory NetworkException.forbidden({String? url}) => NetworkException(
        message: '没有访问权限',
        statusCode: 403,
        url: url,
        code: 'NETWORK_FORBIDDEN',
      );

  /// 资源未找到（404）
  factory NetworkException.notFound({String? url}) => NetworkException(
        message: '请求的资源不存在',
        statusCode: 404,
        url: url,
        code: 'NETWORK_NOT_FOUND',
      );

  /// 请求参数错误（400）
  factory NetworkException.badRequest({String? url}) => NetworkException(
        message: '请求参数错误',
        statusCode: 400,
        url: url,
        code: 'NETWORK_BAD_REQUEST',
      );

  /// 未授权（401）
  factory NetworkException.unauthorized({String? url}) => NetworkException(
        message: '登录已过期，请重新登录',
        statusCode: 401,
        url: url,
        code: 'NETWORK_UNAUTHORIZED',
      );

  /// 连接被重置
  factory NetworkException.connectionReset({String? url}) => NetworkException(
        message: '网络连接被重置，请重试',
        statusCode: null,
        url: url,
        code: 'NETWORK_CONNECTION_RESET',
      );

  /// SSL 证书错误
  factory NetworkException.sslError({String? url}) => NetworkException(
        message: '安全连接失败，请检查设备时间设置',
        statusCode: null,
        url: url,
        code: 'NETWORK_SSL_ERROR',
      );

  /// HTTP 状态码
  final int? statusCode;

  /// 请求 URL
  final String? url;

  @override
  String toString() =>
      'NetworkException($code, statusCode: $statusCode): $message';
}
