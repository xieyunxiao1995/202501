import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/user.dart';
import '../../repositories/i_auth_repository.dart';

/// 自动登录用例
///
/// 使用本地缓存的凭证自动登录，无需用户手动输入。
/// 适用于应用启动时检查登录态的场景。
@injectable
class AutoLoginUseCase {
  final IAuthRepository _repository;

  /// 创建自动登录用例实例
  AutoLoginUseCase(this._repository);

  /// 执行自动登录操作
  ///
  /// 返回包含用户信息的 [ApiResult]
  Future<ApiResult<User>> call() => throw UnimplementedError();
}
