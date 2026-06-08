import 'package:injectable/injectable.dart';
import '../../../core/network/api_result.dart';
import '../../repositories/i_kingdom_war_repository.dart';

/// 加入国家用例
///
/// 选择并加入魏、蜀、吴其中一个国家阵营。
/// 加入国家后可参与国战、攻城略地，为国家争夺领土。
/// 每赛季仅可更换一次国家。
@injectable
class JoinKingdomUseCase {
  final IKingdomWarRepository _repository;

  /// 创建加入国家用例实例
  JoinKingdomUseCase(this._repository);

  /// 执行加入国家操作
  ///
  /// [kingdom] 国家标识（wei / shu / wu）
  /// 返回包含加入结果的 [ApiResult]
  Future<ApiResult<Map<String, dynamic>>> call(String kingdom) =>
      throw UnimplementedError();
}
