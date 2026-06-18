/// 字符串工具类
///
/// 提供空值判断、截断、脱敏、大小写转换、驼峰转换等常用字符串操作。
class StringUtils {
  StringUtils._();

  // ==================== 空值判断 ====================

  /// 判断字符串是否为 null 或空
  static bool isNullOrEmpty(String? value) {
    return value == null || value.isEmpty;
  }

  /// 判断字符串是否为 null 或纯空白
  static bool isNullOrBlank(String? value) {
    return value == null || value.trim().isEmpty;
  }

  /// 判断字符串是否非空且非空白
  static bool isNotBlank(String? value) {
    return value != null && value.trim().isNotEmpty;
  }

  // ==================== 截断 ====================

  /// 截断字符串并添加省略号
  ///
  /// [maxLength] 最大长度（含省略号），默认 20
  /// [ellipsis] 省略号，默认 "..."
  ///
  /// 示例：
  /// - truncate("一策定江山", 5) → "三国谋..."
  static String truncate(String value, {int maxLength = 20, String ellipsis = '...'}) {
    if (value.length <= maxLength) return value;
    final targetLength = maxLength - ellipsis.length;
    if (targetLength <= 0) return ellipsis.substring(0, maxLength);
    return value.substring(0, targetLength) + ellipsis;
  }

  // ==================== 脱敏 ====================

  /// 手机号脱敏：中间4位替换为 *
  ///
  /// 示例：13812345678 → 138****5678
  static String maskPhone(String phone) {
    if (phone.length < 7) return phone;
    return '${phone.substring(0, 3)}****${phone.substring(phone.length - 4)}';
  }

  /// 身份证号脱敏：中间替换为 *
  ///
  /// 示例：110101199001011234 → 110101****1234
  static String maskIdCard(String idCard) {
    if (idCard.length < 8) return idCard;
    return '${idCard.substring(0, 6)}****${idCard.substring(idCard.length - 4)}';
  }

  /// 邮箱脱敏
  ///
  /// 示例：example@gmail.com → e****e@gmail.com
  static String maskEmail(String email) {
    final atIndex = email.indexOf('@');
    if (atIndex < 1) return email;
    final prefix = email.substring(0, atIndex);
    final domain = email.substring(atIndex);
    if (prefix.length <= 2) return '${prefix[0]}***$domain';
    return '${prefix[0]}${'*' * (prefix.length - 2)}${prefix[prefix.length - 1]}$domain';
  }

  /// 用户名脱敏
  ///
  /// 示例：张三丰 → 张*丰 （2字时：张*）
  static String maskName(String name) {
    if (name.isEmpty) return name;
    if (name.length == 1) return name;
    if (name.length == 2) return '${name[0]}*';
    return '${name[0]}${'*' * (name.length - 2)}${name[name.length - 1]}';
  }

  // ==================== 大小写转换 ====================

  /// 首字母大写
  ///
  /// 示例：hello → Hello
  static String capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  /// 首字母小写
  ///
  /// 示例：Hello → hello
  static String uncapitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toLowerCase() + value.substring(1);
  }

  // ==================== 驼峰转换 ====================

  /// 下划线命名转小驼峰
  ///
  /// 示例：user_name → userName
  static String toCamelCase(String value) {
    if (value.isEmpty) return value;
    final parts = value.split('_');
    if (parts.length == 1) return value;
    return parts[0] + parts.skip(1).map((p) => capitalize(p)).join();
  }

  /// 下划线命名转大驼峰（帕斯卡命名）
  ///
  /// 示例：user_name → UserName
  static String toPascalCase(String value) {
    if (value.isEmpty) return value;
    final parts = value.split('_');
    return parts.map((p) => capitalize(p)).join();
  }

  /// 小驼峰转下划线命名
  ///
  /// 示例：userName → user_name
  static String toSnakeCase(String value) {
    if (value.isEmpty) return value;
    final buffer = StringBuffer();
    for (var i = 0; i < value.length; i++) {
      final char = value[i];
      if (char.toUpperCase() == char && char.toLowerCase() != char && i > 0) {
        buffer.write('_');
      }
      buffer.write(char.toLowerCase());
    }
    return buffer.toString();
  }

  // ==================== 其他 ====================

  /// 反转字符串
  static String reverse(String value) {
    return String.fromCharCodes(value.codeUnits.reversed);
  }

  /// 统计中文字符数（1个汉字算1个字符，1个英文也算1个字符）
  static int displayLength(String value) {
    return value.length;
  }

  /// 限制字符串为指定显示长度，超出部分用省略号
  static String ellipsis(String value, int maxLength, {String suffix = '...'}) {
    if (value.length <= maxLength) return value;
    return '${value.substring(0, maxLength)}$suffix';
  }

  /// 判断是否是纯数字
  static bool isNumeric(String value) {
    return RegExp(r'^[0-9]+$').hasMatch(value);
  }

  /// 判断是否包含中文
  static bool containsChinese(String value) {
    return RegExp(r'[一-龥]').hasMatch(value);
  }
}
