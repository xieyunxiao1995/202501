import 'app_exception.dart';

/// 业务异常（如体力不足、武将已存在等）
///
/// 用于表示游戏业务逻辑层面的错误，通常由客户端校验或
/// 服务器返回的业务错误码触发。
class BusinessException extends AppException {
  /// 创建业务异常
  const BusinessException({
    required super.message,
    super.code = 'BUSINESS_ERROR',
    super.stackTrace,
    super.originalError,
  });

  /// 体力不足
  factory BusinessException.insufficientStamina() => const BusinessException(
        message: '体力不足，请等待恢复或使用体力道具',
        code: 'BUSINESS_INSUFFICIENT_STAMINA',
      );

  /// 武将已存在
  factory BusinessException.generalExists() => const BusinessException(
        message: '该武将已拥有',
        code: 'BUSINESS_GENERAL_EXISTS',
      );

  /// 资源不足
  factory BusinessException.insufficientResource(String resource) =>
      BusinessException(
        message: '$resource不足',
        code: 'BUSINESS_INSUFFICIENT_RESOURCE',
      );

  /// 等级不足
  factory BusinessException.levelNotEnough(int required) => BusinessException(
        message: '需要等级达到 $required 级',
        code: 'BUSINESS_LEVEL_NOT_ENOUGH',
      );

  /// VIP等级不足
  factory BusinessException.vipLevelNotEnough(int required) =>
      BusinessException(
        message: '需要VIP等级达到 $required',
        code: 'BUSINESS_VIP_LEVEL_NOT_ENOUGH',
      );

  /// 金币不足
  factory BusinessException.insufficientGold() => const BusinessException(
        message: '金币不足',
        code: 'BUSINESS_INSUFFICIENT_GOLD',
      );

  /// 元宝不足
  factory BusinessException.insufficientDiamond() => const BusinessException(
        message: '元宝不足',
        code: 'BUSINESS_INSUFFICIENT_DIAMOND',
      );

  /// 背包已满
  factory BusinessException.inventoryFull() => const BusinessException(
        message: '背包已满，请先清理背包',
        code: 'BUSINESS_INVENTORY_FULL',
      );

  /// 已达每日上限
  factory BusinessException.dailyLimitReached() => const BusinessException(
        message: '今日次数已用完',
        code: 'BUSINESS_DAILY_LIMIT_REACHED',
      );

  /// 冷却中
  factory BusinessException.inCooldown(Duration remaining) =>
      BusinessException(
        message: '冷却中，还需等待 ${remaining.inSeconds} 秒',
        code: 'BUSINESS_IN_COOLDOWN',
      );

  /// 装备已穿戴
  factory BusinessException.equipmentEquipped() => const BusinessException(
        message: '装备已被穿戴，请先卸下',
        code: 'BUSINESS_EQUIPMENT_EQUIPPED',
      );

  /// 阵容位置已满
  factory BusinessException.formationFull() => const BusinessException(
        message: '阵容位置已满',
        code: 'BUSINESS_FORMATION_FULL',
      );

  /// 功能未解锁
  factory BusinessException.featureLocked(String feature) => BusinessException(
        message: '$feature 尚未解锁',
        code: 'BUSINESS_FEATURE_LOCKED',
      );

  /// 操作无效
  factory BusinessException.invalidOperation([String? reason]) =>
      BusinessException(
        message: reason ?? '无效的操作',
        code: 'BUSINESS_INVALID_OPERATION',
      );

  @override
  String toString() => 'BusinessException($code): $message';
}
