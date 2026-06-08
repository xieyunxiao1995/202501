import 'package:injectable/injectable.dart';
import '../../core/network/api_result.dart';
import '../../domain/repositories/i_rank_repository.dart';
import '../datasources/remote/rank_api.dart';

/// 排行榜仓库实现
///
/// 实现排行榜查询相关业务逻辑，协调远程 API，
/// 处理各类型排行榜的数据获取。
@LazySingleton(as: IRankRepository)
class RankRepositoryImpl implements IRankRepository {
  final RankApi _rankApi;

  RankRepositoryImpl(this._rankApi);

  @override
  Future<ApiResult<List<Map<String, dynamic>>>> getRankings(String type) async {
    // TODO: 根据 type 调用 _rankApi 对应的排行榜接口，返回排名数据
    throw UnimplementedError();
  }
}
