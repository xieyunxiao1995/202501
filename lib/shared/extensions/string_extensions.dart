/// 字符串扩展方法
///
/// 提供常用的字符串处理工具，包括空白判断、截断、脱敏、命名转换等。
library;

extension StringExtensions on String {
  /// 是否为空白字符串
  ///
  /// 与 [isEmpty] 不同，[isBlank] 会先去除首尾空白再判断。
  /// ```dart
  /// '  '.isBlank; // true
  /// 'hello'.isBlank; // false
  /// ```
  bool get isBlank => trim().isEmpty;

  /// 是否非空白
  ///
  /// ```dart
  /// '  '.isNotBlank; // false
  /// 'hello'.isNotBlank; // true
  /// ```
  bool get isNotBlank => trim().isNotEmpty;

  /// 截断加省略号
  ///
  /// 当字符串长度超过 [maxLength] 时，截断并追加 [suffix]。
  /// ```dart
  /// '你好世界你好世界'.truncate(4); // '你好世界…'
  /// '你好'.truncate(4); // '你好'
  /// ```
  String truncate(int maxLength, {String suffix = '…'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}$suffix';
  }

  /// 手机号脱敏
  ///
  /// 将 11 位手机号的中间四位替换为星号。
  /// ```dart
  /// '13812345678'.maskPhone(); // '138****5678'
  /// '123'.maskPhone(); // '123'（非 11 位原样返回）
  /// ```
  String maskPhone() {
    if (length != 11) return this;
    return '${substring(0, 3)}****${substring(7)}';
  }

  /// 首字母大写
  ///
  /// ```dart
  /// 'hello'.capitalize(); // 'Hello'
  /// ''.capitalize(); // ''
  /// ```
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// 驼峰转下划线（snake_case）
  ///
  /// ```dart
  /// 'userName'.camelToSnake(); // 'user_name'
  /// 'isActive'.camelToSnake(); // 'is_active'
  /// ```
  String camelToSnake() =>
      replaceAll(RegExp(r'([a-z])([A-Z])'), r'$1_$2').toLowerCase();

  /// 下划线转驼峰（camelCase）
  ///
  /// ```dart
  /// 'user_name'.snakeToCamel(); // 'userName'
  /// 'is_active'.snakeToCamel(); // 'isActive'
  /// ```
  String snakeToCamel() => split('_').asMap().entries.map((e) {
        if (e.key == 0) return e.value;
        return e.value.capitalize();
      }).join();
}
