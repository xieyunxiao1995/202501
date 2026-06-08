import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_social_repository.dart';

/// 借用武将用例
///
/// 向好友借用武将作为助战单位，用于特定战斗场景。
/// 借用武将有次数限制和时效限制。
@injectable
class BorrowGeneralUseCase {
  final ISocialRepository _repository;

  /// 创建借用武将用例实例
  BorrowGeneralUseCase(this._repository);

  /// 执行借用武将操作
  ///
  /// [friendId] 好友 ID
  /// [generalId] 武将 ID
  /// 返回包含借用武将信息的 [ApiResult]
  Future<ApiResult<Map<String, dynamic>>> call(
    String friendId,
    String generalId,
  ) =>
      throw UnimplementedError();
}
