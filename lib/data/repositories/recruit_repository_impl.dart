import 'package:injectable/injectable.dart';
import '../../core/network/api_result.dart';
import '../../domain/entities/general.dart';
import '../../domain/repositories/i_recruit_repository.dart';
import '../datasources/remote/recruit_api.dart';
import '../mappers/general_mapper.dart';

/// 招募仓库实现
///
/// 实现武将招募相关业务逻辑，协调远程 API，
/// 处理卡池查询、单抽、十连、历史记录和保底信息等操作。
@LazySingleton(as: IRecruitRepository)
class RecruitRepositoryImpl implements IRecruitRepository {
  final RecruitApi _recruitApi;
  final GeneralMapper _generalMapper;

  RecruitRepositoryImpl(this._recruitApi, this._generalMapper);

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getPool() async {
    // TODO: 调用 _recruitApi.getPools，返回卡池信息列表
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<General>> singleRecruit(String poolId) async {
    // TODO: 调用 _recruitApi.pull，通过 _generalMapper 转换为 General 实体
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<List<General>>> tenRecruit(String poolId) async {
    // TODO: 调用 _recruitApi.pullTen，通过 _generalMapper 批量转换为 General 实体
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getHistory(String poolId) async {
    // TODO: 调用 _recruitApi.getHistory，返回招募历史记录
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Map<String, dynamic>>> getPityInfo(String poolId) async {
    // TODO: 调用 _recruitApi.getPity，返回保底进度信息
    throw UnimplementedError();
  }
}
