import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/lineup.dart';
import '../../repositories/i_lineup_repository.dart';

/// 设置阵法用例
///
/// 为指定阵容设置阵法，不同阵法提供不同位置的属性加成。
/// 阵法需要与武将职业搭配才能发挥最大效果。
@injectable
class SetFormationUseCase {
  final ILineupRepository _repository;

  /// 创建设置阵法用例实例
  SetFormationUseCase(this._repository);

  /// 执行设置阵法操作
  ///
  /// [lineupId] 阵容 ID
  /// [formationId] 阵法 ID
  /// 返回包含更新后阵容的 [ApiResult]
  Future<ApiResult<Lineup>> call(String lineupId, String formationId) =>
      throw UnimplementedError();
}
