import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_recruit_repository.dart';

/// 获取招贤历史用例
///
/// 获取指定卡池的招募历史记录，包括每次招募的结果和时间。
/// 用于查看过往招募记录和统计出率。
@injectable
class GetRecruitHistoryUseCase {
  final IRecruitRepository _repository;

  /// 创建获取招贤历史用例实例
  GetRecruitHistoryUseCase(this._repository);

  /// 执行获取招贤历史操作
  ///
  /// [poolId] 卡池 ID
  /// 返回包含招募历史列表的 [ApiResult]
  Future<ApiResult<List<Map<String, dynamic>>>> call(String poolId) =>
      throw UnimplementedError();
}
