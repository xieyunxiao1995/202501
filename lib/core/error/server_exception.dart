import 'app_exception.dart';

/// 服务器异常，包含服务器错误码和数据
///
/// 用于表示服务器返回的业务层面的错误，如服务器自定义错误码、
/// 服务器返回的附加数据等。
class ServerException extends AppException {
  /// 创建服务器异常
  const ServerException({
    required super.message,
    this.serverCode,
    this.data,
    super.code = 'SERVER_ERROR',
    super.stackTrace,
    super.originalError,
  });

  /// 服务器维护中
  factory ServerException.maintenance({Map<String, dynamic>? data}) =>
      ServerException(
        message: '服务器维护中，请稍后再试',
        serverCode: 10001,
        data: data,
        code: 'SERVER_MAINTENANCE',
      );

  /// 服务器版本过旧，需要更新
  factory ServerException.versionTooOld({Map<String, dynamic>? data}) =>
      ServerException(
        message: '应用版本过旧，请更新到最新版本',
        serverCode: 10002,
        data: data,
        code: 'SERVER_VERSION_TOO_OLD',
      );

  /// 服务器繁忙
  factory ServerException.busy({Map<String, dynamic>? data}) => ServerException(
        message: '服务器繁忙，请稍后再试',
        serverCode: 10003,
        data: data,
        code: 'SERVER_BUSY',
      );

  /// 数据验证失败
  factory ServerException.validationFailed({
    String? message,
    Map<String, dynamic>? data,
  }) =>
      ServerException(
        message: message ?? '数据验证失败',
        serverCode: 10004,
        data: data,
        code: 'SERVER_VALIDATION_FAILED',
      );

  /// 账号被封禁
  factory ServerException.accountBanned({Map<String, dynamic>? data}) =>
      ServerException(
        message: '账号已被封禁，请联系客服',
        serverCode: 10005,
        data: data,
        code: 'SERVER_ACCOUNT_BANNED',
      );

  /// 登录Token过期
  factory ServerException.tokenExpired({Map<String, dynamic>? data}) =>
      ServerException(
        message: '登录已过期，请重新登录',
        serverCode: 10006,
        data: data,
        code: 'SERVER_TOKEN_EXPIRED',
      );

  /// 请求频率过高
  factory ServerException.rateLimited({Map<String, dynamic>? data}) =>
      ServerException(
        message: '操作过于频繁，请稍后再试',
        serverCode: 10007,
        data: data,
        code: 'SERVER_RATE_LIMITED',
      );

  /// 服务器自定义错误码
  final int? serverCode;

  /// 服务器返回的附加数据
  final Map<String, dynamic>? data;

  @override
  String toString() =>
      'ServerException($code, serverCode: $serverCode): $message';
}
