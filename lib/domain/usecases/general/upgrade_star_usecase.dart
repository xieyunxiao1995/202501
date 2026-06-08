import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/general.dart';
import '../../repositories/i_general_repository.dart';

/// 武将升星用例
///
/// 消耗同名武将或升星材料提升武将星级（1-7星）。
/// 每次升星大幅提升武将基础属性和成长率。
@injectable
class UpgradeStarUseCase {
  final IGeneralRepository _repository;

  /// 创建武将升星用例实例
  UpgradeStarUseCase(this._repository);

  /// 执行武将升星操作
  ///
  /// [generalId] 武将唯一标识
  /// 返回包含升星后武将信息的 [ApiResult]
  Future<ApiResult<General>> call(String generalId) =>
      throw UnimplementedError();
}
