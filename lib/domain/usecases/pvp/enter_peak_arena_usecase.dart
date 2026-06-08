import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_pvp_repository.dart';

/// 进入巅峰竞技场用例
///
/// 进入巅峰竞技场，获取赛季信息和排名。
/// 巅峰竞技场为赛季制，排名更高可获得丰厚赛季奖励。
@injectable
class EnterPeakArenaUseCase {
  final IPvpRepository _repository;

  /// 创建进入巅峰竞技场用例实例
  EnterPeakArenaUseCase(this._repository);

  /// 执行进入巅峰竞技场操作
  ///
  /// 返回包含巅峰竞技场信息的 [ApiResult]
  Future<ApiResult<Map<String, dynamic>>> call() =>
      throw UnimplementedError();
}
