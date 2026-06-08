import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/general.dart';
import '../../repositories/i_general_repository.dart';

/// 进化武将用例
///
/// 消耗同名武将碎片或通用进化材料，提升武将品质。
/// 进化后武将稀有度提升，属性大幅增长。
@injectable
class EvolveGeneralUseCase {
  final IGeneralRepository _repository;

  /// 创建进化武将用例实例
  EvolveGeneralUseCase(this._repository);

  /// 执行进化武将操作
  ///
  /// [generalId] 武将唯一标识
  /// 返回包含进化后武将信息的 [ApiResult]
  Future<ApiResult<General>> call(String generalId) =>
      throw UnimplementedError();
}
