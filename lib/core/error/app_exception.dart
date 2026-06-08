/// 应用异常基类
///
/// 所有自定义异常的基类，包含错误码、错误消息、堆栈信息和原始错误。
/// 子类包括 [NetworkException]、[ServerException]、[BusinessException]。
class AppException implements Exception {
  /// 创建应用异常
  const AppException({
    required this.code,
    required this.message,
    this.stackTrace,
    this.originalError,
  });

  /// 错误码
  final String code;

  /// 错误消息（用户友好）
  final String message;

  /// 堆栈信息
  final StackTrace? stackTrace;

  /// 原始错误对象
  final dynamic originalError;

  @override
  String toString() => 'AppException($code): $message';
}
