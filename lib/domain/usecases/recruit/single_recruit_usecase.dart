import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/general.dart';
import '../../repositories/i_recruit_repository.dart';

/// 单次招贤用例
///
/// 在指定卡池中进行一次招募，消耗对应货币。
/// 单次招募有概率获得各稀有度武将，受保底机制保护。
@injectable
class SingleRecruitUseCase {
  final IRecruitRepository _repository;

  /// 创建单次招贤用例实例
  SingleRecruitUseCase(this._repository);

  /// 执行单次招贤操作
  ///
  /// [poolId] 卡池 ID
  /// 返回包含招募到武将的 [ApiResult]
  Future<ApiResult<General>> call(String poolId) =>
      throw UnimplementedError();
}
