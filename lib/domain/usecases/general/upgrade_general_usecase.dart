import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/general.dart';
import '../../repositories/i_general_repository.dart';

/// 升级武将用例
///
/// 消耗经验道具或铜钱提升武将等级。
/// 升级后武将基础属性会按成长率提升。
@injectable
class UpgradeGeneralUseCase {
  final IGeneralRepository _repository;

  /// 创建升级武将用例实例
  UpgradeGeneralUseCase(this._repository);

  /// 执行升级武将操作
  ///
  /// [generalId] 武将唯一标识
  /// 返回包含升级后武将信息的 [ApiResult]
  Future<ApiResult<General>> call(String generalId) =>
      throw UnimplementedError();
}
