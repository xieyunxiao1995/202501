import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/lineup.dart';
import '../../repositories/i_lineup_repository.dart';

/// 获取阵容用例
///
/// 获取当前玩家保存的所有阵容配置。
/// 每位玩家可保存多套阵容以应对不同战斗场景。
@injectable
class GetLineupUseCase {
  final ILineupRepository _repository;

  /// 创建获取阵容用例实例
  GetLineupUseCase(this._repository);

  /// 执行获取阵容操作
  ///
  /// 返回包含阵容列表的 [ApiResult]
  Future<ApiResult<List<Lineup>>> call() => throw UnimplementedError();
}
