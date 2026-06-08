import '../../core/network/api_result.dart';
import '../entities/user.dart';

/// 认证仓库接口
///
/// 提供用户认证相关操作，包括登录、注册、自动登录和账号绑定。
/// 所有方法返回 [ApiResult] 以统一处理成功、失败和加载状态。
abstract class IAuthRepository {
  /// 用户登录
  ///
  /// 使用 [username] 和 [password] 进行登录认证。
  /// 成功时返回 [User] 信息，失败时返回异常。
  Future<ApiResult<User>> login(String username, String password);

  /// 用户登出
  ///
  /// 清除当前用户的登录状态和本地缓存。
  Future<ApiResult<void>> logout();

  /// 用户注册
  ///
  /// 使用 [username] 和 [password] 注册新账号。
  /// 注册成功后自动登录，返回 [User] 信息。
  Future<ApiResult<User>> register(String username, String password);

  /// 自动登录
  ///
  /// 使用本地存储的令牌自动恢复登录状态。
  /// 令牌有效时返回 [User] 信息，过期时返回失败。
  Future<ApiResult<User>> autoLogin();

  /// 绑定第三方账号
  ///
  /// 将第三方平台账号绑定到当前用户。
  /// [platform] 为平台标识（如 'wechat'、'qq'），
  /// [token] 为第三方授权令牌。
  Future<ApiResult<void>> bindAccount(String platform, String token);
}
