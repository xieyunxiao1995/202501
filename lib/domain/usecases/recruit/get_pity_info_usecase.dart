import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_recruit_repository.dart';

/// 获取保底信息用例
///
/// 获取指定卡池的保底计数和距离下次保底的抽数。
/// 保底机制确保一定抽数内必出高稀有度武将。
@injectable
class GetPityInfoUseCase {
  final IRecruitRepository _repository;

  /// 创建获取保底信息用例实例
  GetPityInfoUseCase(this._repository);

  /// 执行获取保底信息操作
  ///
  /// [poolId] 卡池 ID
  /// 返回包含保底信息的 [ApiResult]
  Future<ApiResult<Map<String, dynamic>>> call(String poolId) =>
      throw UnimplementedError();
}
