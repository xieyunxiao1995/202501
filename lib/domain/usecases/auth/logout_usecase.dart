import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_auth_repository.dart';

/// 登出用例
///
/// 退出当前登录状态，清除本地缓存的用户凭证。
@injectable
class LogoutUseCase {
  final IAuthRepository _repository;

  /// 创建登出用例实例
  LogoutUseCase(this._repository);

  /// 执行登出操作
  ///
  /// 返回操作结果的 [ApiResult]
  Future<ApiResult<void>> call() => throw UnimplementedError();
}
