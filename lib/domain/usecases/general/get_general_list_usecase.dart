import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/general.dart';
import '../../repositories/i_general_repository.dart';

/// 获取武将列表用例
///
/// 获取当前用户拥有的所有武将列表。
/// 列表按武将战力或获取时间排序。
@injectable
class GetGeneralListUseCase {
  final IGeneralRepository _repository;

  /// 创建获取武将列表用例实例
  GetGeneralListUseCase(this._repository);

  /// 执行获取武将列表操作
  ///
  /// 返回包含武将列表的 [ApiResult]
  Future<ApiResult<List<General>>> call() =>
      throw UnimplementedError();
}
