import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_alliance_repository.dart';

/// 退出联盟用例
///
/// 退出当前所在的联盟。
/// 盟主退出需先转让盟主职位，退出后有冷却时间才能加入新联盟。
@injectable
class LeaveAllianceUseCase {
  final IAllianceRepository _repository;

  /// 创建退出联盟用例实例
  LeaveAllianceUseCase(this._repository);

  /// 执行退出联盟操作
  ///
  /// 返回操作结果的 [ApiResult]
  Future<ApiResult<void>> call() => throw UnimplementedError();
}
