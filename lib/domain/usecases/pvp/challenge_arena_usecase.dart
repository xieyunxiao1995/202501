import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_pvp_repository.dart';

/// 竞技场挑战用例
///
/// 向竞技场中的对手发起挑战，胜利后双方排名互换。
/// 每日挑战次数有限，可通过道具补充。
@injectable
class ChallengeArenaUseCase {
  final IPvpRepository _repository;

  /// 创建竞技场挑战用例实例
  ChallengeArenaUseCase(this._repository);

  /// 执行竞技场挑战操作
  ///
  /// [opponentId] 对手 ID
  /// [lineupId] 出战阵容 ID
  /// 返回包含挑战结果的 [ApiResult]
  Future<ApiResult<Map<String, dynamic>>> call(
    String opponentId,
    String lineupId,
  ) =>
      throw UnimplementedError();
}
