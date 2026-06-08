import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/general.dart';
import '../../repositories/i_general_repository.dart';

/// 获取武将详情用例
///
/// 根据武将 ID 获取武将的详细信息，包括属性、技能、装备等。
@injectable
class GetGeneralDetailUseCase {
  final IGeneralRepository _repository;

  /// 创建获取武将详情用例实例
  GetGeneralDetailUseCase(this._repository);

  /// 执行获取武将详情操作
  ///
  /// [generalId] 武将唯一标识
  /// 返回包含武将详情的 [ApiResult]
  Future<ApiResult<General>> call(String generalId) =>
      throw UnimplementedError();
}
