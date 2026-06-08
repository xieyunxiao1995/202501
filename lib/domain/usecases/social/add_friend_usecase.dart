import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_social_repository.dart';

/// 添加好友用例
///
/// 向指定玩家发送好友申请，对方同意后建立好友关系。
/// 好友数量有上限，需合理管理。
@injectable
class AddFriendUseCase {
  final ISocialRepository _repository;

  /// 创建添加好友用例实例
  AddFriendUseCase(this._repository);

  /// 执行添加好友操作
  ///
  /// [userId] 目标玩家 ID
  /// 返回操作结果的 [ApiResult]
  Future<ApiResult<void>> call(String userId) =>
      throw UnimplementedError();
}
