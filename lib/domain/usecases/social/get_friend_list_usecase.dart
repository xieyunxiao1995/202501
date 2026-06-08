import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_social_repository.dart';

/// 获取好友列表用例
///
/// 获取当前玩家的好友列表，包括在线状态和最后登录时间。
@injectable
class GetFriendListUseCase {
  final ISocialRepository _repository;

  /// 创建获取好友列表用例实例
  GetFriendListUseCase(this._repository);

  /// 执行获取好友列表操作
  ///
  /// 返回包含好友列表的 [ApiResult]
  Future<ApiResult<List<Map<String, dynamic>>>> call() =>
      throw UnimplementedError();
}
