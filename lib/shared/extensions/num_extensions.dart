/// Num 扩展方法
///
/// 提供数字格式化工具，包括货币缩写、伤害格式化、战力格式化、百分比等。
library;

extension NumExtensions on num {
  /// 货币格式化（中文缩写）
  ///
  /// ```dart
  /// 9999.toCurrencyFormat(); // '9999'
  /// 10000.toCurrencyFormat(); // '1万'
  /// 15000.toCurrencyFormat(); // '1.5万'
  /// 100000000.toCurrencyFormat(); // '1亿'
  /// 150000000.toCurrencyFormat(); // '1.5亿'
  /// ```
  String toCurrencyFormat() {
    if (this >= 100000000) {
      final value = this / 100000000;
      return '${_formatDecimal(value)}亿';
    }
    if (this >= 10000) {
      final value = this / 10000;
      return '${_formatDecimal(value)}万';
    }
    return toString();
  }

  /// 伤害格式化
  ///
  /// 小于1万时使用千分位逗号分隔，大于等于1万时使用万缩写保留1位小数。
  /// ```dart
  /// 1234567.toDamageFormat(); // '123.5万'
  /// 9876.toDamageFormat(); // '9,876'
  /// ```
  String toDamageFormat() {
    if (this >= 10000) {
      final value = this / 10000;
      return '${_formatDecimal(value)}万';
    }
    return _addCommas(round());
  }

  /// 战力格式化
  ///
  /// 类似货币格式化，但附加"战力"后缀风格。
  /// ```dart
  /// 58000.toPowerFormat(); // '5.8万'
  /// 1200000.toPowerFormat(); // '120万'
  /// 250000000.toPowerFormat(); // '2.5亿'
  /// ```
  String toPowerFormat() {
    if (this >= 100000000) {
      final value = this / 100000000;
      return '${_formatDecimal(value)}亿';
    }
    if (this >= 10000) {
      final value = this / 10000;
      return '${_formatDecimal(value)}万';
    }
    return _addCommas(round());
  }

  /// 百分比字符串
  ///
  /// 将 0.0~1.0 的小数转换为百分比字符串。
  /// ```dart
  /// 0.75.toPercentString(); // '75%'
  /// 1.0.toPercentString(); // '100%'
  /// 0.0.toPercentString(); // '0%'
  /// ```
  String toPercentString() => '${(this * 100).round()}%';

  /// 安全的 clamp 操作
  ///
  /// 自动处理 [min] 和 [max] 的大小关系，避免抛出异常。
  /// ```dart
  /// 5.clampSafe(0, 10); // 5
  /// (-3).clampSafe(0, 10); // 0
  /// 15.clampSafe(0, 10); // 10
  /// 5.clampSafe(10, 0); // 5（自动纠正 min/max 顺序）
  /// ```
  num clampSafe(num min, num max) {
    final lower = min < max ? min : max;
    final upper = min < max ? max : min;
    return clamp(lower, upper);
  }

  /// 判断是否在 [a] 和 [b] 之间（包含边界）
  ///
  /// 自动处理 [a] 和 [b] 的大小关系。
  /// ```dart
  /// 5.isBetween(1, 10); // true
  /// 5.isBetween(10, 1); // true（自动处理顺序）
  /// 0.isBetween(1, 10); // false
  /// ```
  bool isBetween(num a, num b) {
    final lower = a < b ? a : b;
    final upper = a < b ? b : a;
    return this >= lower && this <= upper;
  }

  /// 格式化小数，去除末尾无意义的零
  String _formatDecimal(num value) {
    // 保留1位小数，去除末尾的 .0
    final formatted = value.toStringAsFixed(1);
    if (formatted.endsWith('.0')) {
      return formatted.substring(0, formatted.length - 2);
    }
    return formatted;
  }

  /// 添加千分位逗号
  static String _addCommas(int value) {
    final str = value.abs().toString();
    final buffer = StringBuffer();
    int count = 0;
    for (int i = str.length - 1; i >= 0; i--) {
      if (count > 0 && count % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(str[i]);
      count++;
    }
    final result = buffer.toString().split('').reversed.join();
    return value < 0 ? '-$result' : result;
  }
}

extension IntExtensions on int {
  /// 整数专用的千分位格式化
  ///
  /// ```dart
  /// 1234567.toFormattedString(); // '1,234,567'
  /// ```
  String toFormattedString() => NumExtensions._addCommas(this);
}

extension DoubleExtensions on double {
  /// 保留指定小数位数并去除末尾零
  ///
  /// ```dart
  /// 3.140.toTrimmedString(2); // '3.14'
  /// 3.10.toTrimmedString(2); // '3.1'
  /// 3.00.toTrimmedString(2); // '3'
  /// ```
  String toTrimmedString([int fractionDigits = 2]) {
    var result = toStringAsFixed(fractionDigits);
    // 去除末尾无意义的零和小数点
    if (result.contains('.')) {
      result = result.replaceAll(RegExp(r'0+$'), '');
      result = result.replaceAll(RegExp(r'\.$'), '');
    }
    return result;
  }
}
