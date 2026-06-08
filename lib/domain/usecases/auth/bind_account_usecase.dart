import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_auth_repository.dart';

/// 绑定账号用例
///
/// 将第三方平台账号（如微信、Apple ID）绑定到当前游戏账号。
/// 绑定成功后可通过第三方平台快速登录。
@injectable
class BindAccountUseCase {
  final IAuthRepository _repository;

  /// 创建绑定账号用例实例
  BindAccountUseCase(this._repository);

  /// 执行绑定账号操作
  ///
  /// [platform] 第三方平台标识（如 wechat、apple）
  /// [token] 第三方授权令牌
  /// 返回绑定操作结果的 [ApiResult]
  Future<ApiResult<void>> call(String platform, String token) =>
      throw UnimplementedError();
}
