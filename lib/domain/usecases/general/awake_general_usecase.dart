import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/general.dart';
import '../../repositories/i_general_repository.dart';

/// 觉醒武将用例
///
/// 消耗觉醒材料激活武将的觉醒形态。
/// 觉醒后武将获得额外属性加成和专属技能强化。
/// 前置条件：武将需达到指定星级和等级。
@injectable
class AwakeGeneralUseCase {
  final IGeneralRepository _repository;

  /// 创建觉醒武将用例实例
  AwakeGeneralUseCase(this._repository);

  /// 执行觉醒武将操作
  ///
  /// [generalId] 武将唯一标识
  /// 返回包含觉醒后武将信息的 [ApiResult]
  Future<ApiResult<General>> call(String generalId) =>
      throw UnimplementedError();
}
