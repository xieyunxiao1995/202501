import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/alliance.dart';
import '../../repositories/i_alliance_repository.dart';

/// 加入联盟用例
///
/// 申请加入指定联盟，需等待盟主或副盟主审批。
/// 加入联盟后可参与联盟活动、捐献和领取联盟奖励。
@injectable
class JoinAllianceUseCase {
  final IAllianceRepository _repository;

  /// 创建加入联盟用例实例
  JoinAllianceUseCase(this._repository);

  /// 执行加入联盟操作
  ///
  /// [allianceId] 联盟 ID
  /// 返回包含联盟信息的 [ApiResult]
  Future<ApiResult<Alliance>> call(String allianceId) =>
      throw UnimplementedError();
}
