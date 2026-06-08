import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/user.dart';
import '../../repositories/i_auth_repository.dart';

/// 登录用例
///
/// 使用用户名和密码进行登录认证。
/// 登录成功后返回用户信息，失败则返回异常。
@injectable
class LoginUseCase {
  final IAuthRepository _repository;

  /// 创建登录用例实例
  ///
  /// [repository] 认证仓库接口，由依赖注入提供
  LoginUseCase(this._repository);

  /// 执行登录操作
  ///
  /// [username] 用户名
  /// [password] 密码
  /// 返回包含用户信息的 [ApiResult]
  Future<ApiResult<User>> call(String username, String password) =>
      throw UnimplementedError();
}
