import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/user.dart';
import '../../repositories/i_auth_repository.dart';

/// 注册用例
///
/// 使用用户名和密码注册新账号。
/// 注册成功后自动登录并返回用户信息。
@injectable
class RegisterUseCase {
  final IAuthRepository _repository;

  /// 创建注册用例实例
  RegisterUseCase(this._repository);

  /// 执行注册操作
  ///
  /// [username] 用户名
  /// [password] 密码
  /// 返回包含用户信息的 [ApiResult]
  Future<ApiResult<User>> call(String username, String password) =>
      throw UnimplementedError();
}
