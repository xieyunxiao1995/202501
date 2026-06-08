import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/lineup.dart';
import '../../repositories/i_lineup_repository.dart';

/// 获取推荐阵容用例
///
/// 根据当前拥有的武将，获取系统推荐的阵容搭配方案。
/// 推荐考虑武将羁绊、职业搭配和阵法适配等因素。
@injectable
class GetRecommendedLineupUseCase {
  final ILineupRepository _repository;

  /// 创建获取推荐阵容用例实例
  GetRecommendedLineupUseCase(this._repository);

  /// 执行获取推荐阵容操作
  ///
  /// 返回包含推荐阵容列表的 [ApiResult]
  Future<ApiResult<List<Lineup>>> call() => throw UnimplementedError();
}
