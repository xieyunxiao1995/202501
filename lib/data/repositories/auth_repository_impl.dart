import 'package:injectable/injectable.dart';
import '../../core/network/api_result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../datasources/local/user_local_data_source.dart';
import '../datasources/remote/auth_api.dart';
import '../models/user/login_request_model.dart';

/// 认证仓库实现
///
/// 实现认证相关业务逻辑，协调远程 API 和本地数据源，
/// 处理登录、注册、自动登录和账号绑定等操作。
@LazySingleton(as: IAuthRepository)
class AuthRepositoryImpl implements IAuthRepository {
  final AuthApi _authApi;
  final UserLocalDataSource _userLocalDataSource;

  AuthRepositoryImpl(this._authApi, this._userLocalDataSource);

  @override
  Future<ApiResult<User>> login(String username, String password) async {
    // TODO: 调用 _authApi.login，保存令牌和用户信息，转换为 User 实体
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<void>> logout() async {
    // TODO: 调用 _authApi.logout，清除本地令牌和用户缓存
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<User>> register(String username, String password) async {
    // TODO: 调用 _authApi.register，保存令牌和用户信息，转换为 User 实体
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<User>> autoLogin() async {
    // TODO: 从本地读取令牌，调用 _authApi.verifyToken 验证，恢复登录状态
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<void>> bindAccount(String platform, String token) async {
    // TODO: 调用 API 绑定第三方账号
    throw UnimplementedError();
  }
}
