import '../../core/network/api_result.dart';
import '../entities/alliance.dart';

/// 联盟仓库接口
///
/// 提供联盟管理相关操作，包括加入、退出、查询和公告管理。
abstract class IAllianceRepository {
  /// 加入联盟
  ///
  /// 申请加入指定 [allianceId] 的联盟。
  Future<ApiResult<Alliance>> join(String allianceId);

  /// 退出联盟
  ///
  /// 退出当前所在的联盟。
  Future<ApiResult<void>> leave();

  /// 获取联盟信息
  ///
  /// 获取当前所在联盟的详细信息。
  Future<ApiResult<Alliance>> getInfo();

  /// 获取联盟成员列表
  ///
  /// 获取当前联盟的所有成员信息。
  Future<ApiResult<List<Map<String, dynamic>>>> getMembers();

  /// 更新联盟公告
  ///
  /// 更新联盟公告内容为 [notice]，需要盟主或副盟主权限。
  Future<ApiResult<void>> updateNotice(String notice);
}
