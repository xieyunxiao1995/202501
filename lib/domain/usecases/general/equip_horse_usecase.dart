import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/general.dart';
import '../../repositories/i_general_repository.dart';

/// 装备战马用例
///
/// 为武将骑乘战马，获得属性加成和特殊技能。
/// 同一武将只能骑乘一匹战马，装备新战马会替换旧战马。
@injectable
class EquipHorseUseCase {
  final IGeneralRepository _repository;

  /// 创建装备战马用例实例
  EquipHorseUseCase(this._repository);

  /// 执行装备战马操作
  ///
  /// [generalId] 武将 ID
  /// [horseId] 战马 ID
  /// 返回包含装备后武将信息的 [ApiResult]
  Future<ApiResult<General>> call({
    required String generalId,
    required String horseId,
  }) =>
      throw UnimplementedError();
}
