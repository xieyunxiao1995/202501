import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/general.dart';
import '../../repositories/i_general_repository.dart';

/// 装备道具用例
///
/// 为武将穿戴装备，提升武将属性。
/// 同一武将同一部位只能穿戴一件装备。
@injectable
class EquipItemUseCase {
  final IGeneralRepository _repository;

  /// 创建装备道具用例实例
  EquipItemUseCase(this._repository);

  /// 执行装备道具操作
  ///
  /// [generalId] 武将 ID
  /// [itemId] 装备 ID
  /// 返回包含装备后武将信息的 [ApiResult]
  Future<ApiResult<General>> call({
    required String generalId,
    required String itemId,
  }) =>
      throw UnimplementedError();
}
