import 'package:injectable/injectable.dart';
import '../../core/network/api_result.dart';
import '../../domain/entities/biography.dart';
import '../../domain/repositories/i_biography_repository.dart';
import '../datasources/remote/biography_api.dart';

/// 传记仓库实现
///
/// 实现武将传记相关业务逻辑，协调远程 API，
/// 处理传记查询和章节解锁等操作。
@LazySingleton(as: IBiographyRepository)
class BiographyRepositoryImpl implements IBiographyRepository {
  final BiographyApi _biographyApi;

  BiographyRepositoryImpl(this._biographyApi);

  @override
  Future<ApiResult<Biography>> getBiography(String generalId) async {
    // TODO: 调用 _biographyApi.getBiography，转换为 Biography 实体
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<Biography>> unlockChapter(String generalId, String chapterId) async {
    // TODO: 调用 _biographyApi.unlockChapter，转换为 Biography 实体
    throw UnimplementedError();
  }
}
