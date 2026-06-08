import 'package:intl/intl.dart';

/// 数字格式化工具类
///
/// 提供万/亿简写、伤害值格式化、战力格式化等游戏常用数字显示功能。
class NumberFormatter {
  NumberFormatter._();

  /// 万的阈值
  static const int _wan = 10000;

  /// 亿的阈值
  static const int _yi = 100000000;

  // ==================== 简写格式化 ====================

  /// 将数字格式化为中文简写
  ///
  /// 示例：
  /// - 9999 → "9999"
  /// - 10000 → "1万"
  /// - 12345 → "1.23万"
  /// - 100000000 → "1亿"
  /// - 123456789 → "1.23亿"
  static String formatCN(num value, {int decimalDigits = 2}) {
    if (value.abs() < _wan) {
      return value.round().toString();
    }
    if (value.abs() < _yi) {
      final result = value / _wan;
      return '${_formatDecimal(result, decimalDigits)}万';
    }
    final result = value / _yi;
    return '${_formatDecimal(result, decimalDigits)}亿';
  }

  /// 将数字格式化为简短英文风格
  ///
  /// 示例：
  /// - 999 → "999"
  /// - 1000 → "1K"
  /// - 1500 → "1.5K"
  /// - 1000000 → "1M"
  /// - 1000000000 → "1B"
  static String formatShort(num value, {int decimalDigits = 1}) {
    final abs = value.abs();
    if (abs < 1000) return value.round().toString();
    if (abs < 1000000) {
      return '${_formatDecimal(value / 1000, decimalDigits)}K';
    }
    if (abs < 1000000000) {
      return '${_formatDecimal(value / 1000000, decimalDigits)}M';
    }
    return '${_formatDecimal(value / 1000000000, decimalDigits)}B';
  }

  // ==================== 伤害值格式化 ====================

  /// 格式化伤害值（带逗号分隔）
  ///
  /// 示例：
  /// - 1234 → "1,234"
  /// - 1234567 → "1,234,567"
  static String formatDamage(int damage) {
    return _addCommas(damage);
  }

  /// 格式化伤害值（简化显示）
  ///
  /// 超过1万用"万"表示，超过1亿用"亿"表示
  /// 示例：
  /// - 9999 → "9,999"
  /// - 10000 → "1万"
  /// - 1234567 → "123.46万"
  static String formatDamageShort(int damage, {int decimalDigits = 2}) {
    if (damage.abs() < _wan) {
      return _addCommas(damage);
    }
    return formatCN(damage, decimalDigits: decimalDigits);
  }

  // ==================== 战力格式化 ====================

  /// 格式化战力值
  ///
  /// 战力通常较大，直接使用中文简写
  /// 示例：
  /// - 50000 → "5万"
  /// - 1500000 → "150万"
  /// - 100000000 → "1亿"
  static String formatCombatPower(int combatPower, {int decimalDigits = 1}) {
    if (combatPower.abs() < _wan) {
      return _addCommas(combatPower);
    }
    return formatCN(combatPower, decimalDigits: decimalDigits);
  }

  // ==================== 通用格式化 ====================

  /// 添加千分位逗号
  ///
  /// 示例：1234567 → "1,234,567"
  static String addCommas(num value) {
    return _addCommas(value);
  }

  /// 格式化为货币样式（保留2位小数+千分位）
  ///
  /// 示例：1234567.89 → "1,234,567.89"
  static String formatCurrency(num value) {
    return NumberFormat('#,##0.00').format(value);
  }

  /// 格式化百分比
  ///
  /// [value] 0.0 ~ 1.0 的值
  /// [decimalDigits] 小数位数，默认1
  /// 示例：0.156 → "15.6%"
  static String formatPercent(double value, {int decimalDigits = 1}) {
    final percent = (value * 100).clamp(0.0, double.infinity);
    return '${percent.toStringAsFixed(decimalDigits)}%';
  }

  /// 格式化整数百分比
  ///
  /// [value] 0.0 ~ 1.0 的值
  /// 示例：0.156 → "16%"（四舍五入）
  static String formatPercentInt(double value) {
    return '${(value * 100).round()}%';
  }

  // ==================== 私有方法 ====================

  /// 格式化小数，去除末尾多余的0
  static String _formatDecimal(num value, int decimalDigits) {
    final str = value.toStringAsFixed(decimalDigits);
    // 去除末尾多余的0和小数点
    if (str.contains('.')) {
      var trimmed = str.replaceAll(RegExp(r'0+$'), '');
      if (trimmed.endsWith('.')) {
        trimmed = trimmed.substring(0, trimmed.length - 1);
      }
      return trimmed.isEmpty ? '0' : trimmed;
    }
    return str;
  }

  /// 添加千分位逗号
  static String _addCommas(num value) {
    return NumberFormat('#,##0').format(value);
  }
}
