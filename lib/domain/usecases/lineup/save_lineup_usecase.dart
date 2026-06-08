import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/lineup.dart';
import '../../repositories/i_lineup_repository.dart';

/// 保存阵容用例
///
/// 保存或更新阵容配置，包括武将选择、站位和阵法设置。
/// 保存时会自动校验阵容合法性。
@injectable
class SaveLineupUseCase {
  final ILineupRepository _repository;

  /// 创建保存阵容用例实例
  SaveLineupUseCase(this._repository);

  /// 执行保存阵容操作
  ///
  /// [lineup] 需要保存的阵容数据
  /// 返回包含保存后阵容的 [ApiResult]
  Future<ApiResult<Lineup>> call(Lineup lineup) => throw UnimplementedError();
}
