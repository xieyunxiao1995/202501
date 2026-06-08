import '../../models/user/user_model.dart';

/// 用户本地数据源
///
/// 提供用户数据的本地持久化存储能力，包括用户信息缓存、令牌管理等。
/// 使用 Hive 或 SharedPreferences 进行本地存储。
class UserLocalDataSource {
  /// 保存用户信息到本地
  ///
  /// [user] 要保存的用户数据模型
  Future<void> saveUser(UserModel user) async {
    // TODO: 实现 Hive Box 写入用户信息
    throw UnimplementedError();
  }

  /// 从本地读取用户信息
  ///
  /// 返回缓存的用户数据模型，若不存在返回 null
  Future<UserModel?> getUser() async {
    // TODO: 实现 Hive Box 读取用户信息
    throw UnimplementedError();
  }

  /// 保存访问令牌
  ///
  /// [token] 访问令牌字符串
  Future<void> saveToken(String token) async {
    // TODO: 使用 FlutterSecureStorage 保存令牌
    throw UnimplementedError();
  }

  /// 读取访问令牌
  ///
  /// 返回缓存的访问令牌，若不存在返回 null
  Future<String?> getToken() async {
    // TODO: 使用 FlutterSecureStorage 读取令牌
    throw UnimplementedError();
  }

  /// 保存刷新令牌
  ///
  /// [refreshToken] 刷新令牌字符串
  Future<void> saveRefreshToken(String refreshToken) async {
    // TODO: 使用 FlutterSecureStorage 保存刷新令牌
    throw UnimplementedError();
  }

  /// 读取刷新令牌
  ///
  /// 返回缓存的刷新令牌，若不存在返回 null
  Future<String?> getRefreshToken() async {
    // TODO: 使用 FlutterSecureStorage 读取刷新令牌
    throw UnimplementedError();
  }

  /// 清除用户本地数据
  ///
  /// 退出登录时调用，清除令牌和用户信息缓存。
  Future<void> clearUserData() async {
    // TODO: 清除 Hive Box 和 SecureStorage 中的用户数据
    throw UnimplementedError();
  }
}
