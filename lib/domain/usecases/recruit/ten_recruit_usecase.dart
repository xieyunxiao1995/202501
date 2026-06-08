import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/general.dart';
import '../../repositories/i_recruit_repository.dart';

/// 十连招贤用例
///
/// 在指定卡池中进行十连招募，保底至少获得稀有武将。
/// 十连招募比单抽更划算，且有独立的保底计数。
@injectable
class TenRecruitUseCase {
  final IRecruitRepository _repository;

  /// 创建十连招贤用例实例
  TenRecruitUseCase(this._repository);

  /// 执行十连招贤操作
  ///
  /// [poolId] 卡池 ID
  /// 返回包含招募到武将列表的 [ApiResult]
  Future<ApiResult<List<General>>> call(String poolId) =>
      throw UnimplementedError();
}
