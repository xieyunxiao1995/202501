import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/stage.dart';
import '../../repositories/i_stage_repository.dart';

/// 获取关卡列表用例
///
/// 获取指定章节下的所有关卡信息，包括通关状态和星级评价。
@injectable
class GetStageListUseCase {
  final IStageRepository _repository;

  /// 创建获取关卡列表用例实例
  GetStageListUseCase(this._repository);

  /// 执行获取关卡列表操作
  ///
  /// [chapterId] 章节 ID
  /// 返回包含关卡列表的 [ApiResult]
  Future<ApiResult<List<Stage>>> call(String chapterId) =>
      throw UnimplementedError();
}
