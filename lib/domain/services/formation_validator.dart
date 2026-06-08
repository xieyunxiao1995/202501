/// 阵法验证服务
///
/// 验证阵容的阵法配置是否合法，包括武将数量、位置分配和职业搭配等。
class FormationValidator {
  /// 验证阵容是否合法
  ///
  /// [generalIds] 阵容中的武将 ID 列表
  /// [formationId] 使用的阵法 ID
  ///
  /// 验证规则：
  /// - 武将数量为 1-6
  /// - 不可重复上阵同一武将
  /// - 阵法类型需与武将职业适配
  bool validate({
    required List<String> generalIds,
    required String formationId,
  }) {
    // TODO: 实现阵容合法性验证
    throw UnimplementedError();
  }

  /// 检查武将数量是否合法
  ///
  /// [generalIds] 阵容中的武将 ID 列表
  ///
  /// 出战武将数量需在 1-6 之间。
  bool validateGeneralCount(List<String> generalIds) {
    return generalIds.isNotEmpty && generalIds.length <= 6;
  }

  /// 检查是否存在重复武将
  ///
  /// [generalIds] 阵容中的武将 ID 列表
  ///
  /// 同一武将不可重复上阵。
  bool hasNoDuplicates(List<String> generalIds) {
    return generalIds.toSet().length == generalIds.length;
  }

  /// 验证阵法职业适配
  ///
  /// [formationId] 阵法 ID
  /// [professionCounts] 各职业的武将数量映射
  ///
  /// 部分阵法对职业配置有要求，如七星阵需至少 3 名军师类武将。
  bool validateFormationProfession({
    required String formationId,
    required Map<String, int> professionCounts,
  }) {
    // TODO: 实现阵法职业适配验证
    throw UnimplementedError();
  }

  /// 获取验证错误信息
  ///
  /// [generalIds] 阵容中的武将 ID 列表
  /// [formationId] 阵法 ID
  ///
  /// 返回所有验证不通过的错误描述列表，空列表表示全部通过。
  List<String> getValidationErrors({
    required List<String> generalIds,
    required String formationId,
  }) {
    // TODO: 实现验证错误信息收集
    throw UnimplementedError();
  }
}
