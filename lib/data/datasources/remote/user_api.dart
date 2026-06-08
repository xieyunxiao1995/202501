import 'package:dio/dio.dart';

/// 用户相关 API
///
/// 提供用户信息查询、修改等接口。
abstract class UserApi {
  final Dio _dio;

  UserApi(this._dio);

  /// 获取当前用户信息
  ///
  /// 返回当前登录用户的详细信息。
  Future<Map<String, dynamic>> getCurrentUser() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 根据 ID 获取用户信息
  ///
  /// 返回指定 ID 用户的公开信息。
  Future<Map<String, dynamic>> getUserById(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 更新用户信息
  ///
  /// 修改当前用户的昵称、头像等信息。
  Future<Map<String, dynamic>> updateUser(Map<String, dynamic> body) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取玩家档案
  ///
  /// 返回指定玩家的公开档案信息。
  Future<Map<String, dynamic>> getPlayerProfile(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 修改头像
  ///
  /// 上传并更新当前用户头像。
  Future<Map<String, dynamic>> updateAvatar(Map<String, dynamic> body) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }
}
