import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/general.dart';
import '../../repositories/i_general_repository.dart';

/// 装备专属兵器用例
///
/// 为武将装备专属兵器，获得额外属性和特殊效果。
/// 专属兵器仅能由对应武将使用，不可通用。
@injectable
class EquipWeaponUseCase {
  final IGeneralRepository _repository;

  /// 创建装备专属兵器用例实例
  EquipWeaponUseCase(this._repository);

  /// 执行装备专属兵器操作
  ///
  /// [generalId] 武将 ID
  /// [weaponId] 兵器 ID
  /// 返回包含装备后武将信息的 [ApiResult]
  Future<ApiResult<General>> call({
    required String generalId,
    required String weaponId,
  }) =>
      throw UnimplementedError();
}
