import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_stage_repository.dart';

/// 获取章节列表用例
///
/// 获取所有章节信息，包括已解锁和未解锁的章节。
/// 章节按主线剧情顺序排列，需依次解锁。
@injectable
class GetChapterListUseCase {
  final IStageRepository _repository;

  /// 创建获取章节列表用例实例
  GetChapterListUseCase(this._repository);

  /// 执行获取章节列表操作
  ///
  /// 返回包含章节列表的 [ApiResult]
  Future<ApiResult<List<Map<String, dynamic>>>> call() =>
      throw UnimplementedError();
}
