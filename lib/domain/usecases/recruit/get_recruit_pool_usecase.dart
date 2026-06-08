import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_recruit_repository.dart';

/// 获取招贤卡池用例
///
/// 获取当前可用的招募卡池列表及各卡池的规则和概率。
/// 不同卡池拥有不同的武将出率提升和保底机制。
@injectable
class GetRecruitPoolUseCase {
  final IRecruitRepository _repository;

  /// 创建获取招贤卡池用例实例
  GetRecruitPoolUseCase(this._repository);

  /// 执行获取招贤卡池操作
  ///
  /// 返回包含卡池列表的 [ApiResult]
  Future<ApiResult<List<Map<String, dynamic>>>> call() =>
      throw UnimplementedError();
}
