import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../entities/biography.dart';
import '../../repositories/i_biography_repository.dart';

/// 获取武将传记用例
///
/// 获取指定武将的传记信息，包括正史、演义文本和解锁状态。
/// 阅读传记可了解武将历史背景，并获取奖励。
@injectable
class GetBiographyUseCase {
  final IBiographyRepository _repository;

  /// 创建获取武将传记录用例实例
  GetBiographyUseCase(this._repository);

  /// 执行获取武将传记操作
  ///
  /// [generalId] 武将 ID
  /// 返回包含传记信息的 [ApiResult]
  Future<ApiResult<Biography>> call(String generalId) =>
      throw UnimplementedError();
}
