import 'package:dio/dio.dart';

/// 认证相关 API
///
/// 提供用户登录、注册、令牌刷新等认证接口。
abstract class AuthApi {
  final Dio _dio;

  AuthApi(this._dio);

  /// 用户登录
  ///
  /// 通过用户名和密码进行登录，返回访问令牌和用户信息。
  Future<Map<String, dynamic>> login(Map<String, dynamic> body) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 用户注册
  ///
  /// 注册新用户账号。
  Future<Map<String, dynamic>> register(Map<String, dynamic> body) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 刷新令牌
  ///
  /// 使用刷新令牌获取新的访问令牌。
  Future<Map<String, dynamic>> refreshToken(Map<String, dynamic> body) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 退出登录
  ///
  /// 注销当前用户的登录状态。
  Future<Map<String, dynamic>> logout() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 验证令牌有效性
  ///
  /// 检查当前访问令牌是否仍然有效。
  Future<Map<String, dynamic>> verifyToken() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }
}
