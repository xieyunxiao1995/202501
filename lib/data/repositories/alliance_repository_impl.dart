import 'package:injectable/injectable.dart';
import '../../core/network/api_result.dart';
import '../../domain/entities/alliance.dart';
import '../../domain/repositories/i_alliance_repository.dart';
import '../datasources/remote/alliance_api.dart';

/// 联盟仓库实现
///
/// 实现联盟管理相关业务逻辑，协调远程 API，
/// 处理加入联盟、退出联盟、查询信息和公告管理等操作。
@LazySingleton(as: IAllianceRepository)
class AllianceRepositoryImpl implements IAllianceRepository {
  final AllianceApi _allianceApi;

  AllianceRepositoryImpl(this._allianceApi);

  @override
  Future<ApiResult<Alliance>> join(String allianceId) async {
    // TODO: 调用 _allianceApi.joinAlliance，转换为 Alliance 实体
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<void>> leave() async {
    // TODO: 调用 _allianceApi.leaveAlliance，清除本地联盟缓存
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Alliance>> getInfo() async {
    // TODO: 调用 _allianceApi.getAlliance，转换为 Alliance 实体
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getMembers() async {
    // TODO: 调用 _allianceApi.getMembers，返回成员信息列表
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<void>> updateNotice(String notice) async {
    // TODO: 调用 _allianceApi.updateAnnouncement，更新联盟公告
    throw UnimplementedError();
  }
}
