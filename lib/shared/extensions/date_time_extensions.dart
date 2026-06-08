/// DateTime 扩展方法
///
/// 提供中文日期格式化、相对时间描述、季节判断等常用功能。
library;

extension DateTimeExtensions on DateTime {
  /// 转换为中文日期格式
  ///
  /// ```dart
  /// DateTime(2024, 1, 15).toChineseFormat(); // '2024年1月15日'
  /// ```
  String toChineseFormat() => '$year年$month月$day日';

  /// 转换为倒计时中文描述
  ///
  /// 返回从当前时间到 [this] 的剩余时间描述。
  /// 若已过期，返回空字符串。
  /// ```dart
  /// // 假设当前时间为 2024-01-01 10:00:00
  /// DateTime(2024, 1, 1, 12, 30).toCountdown(); // '2小时30分钟后'
  /// ```
  String toCountdown() {
    final now = DateTime.now();
    if (isBefore(now)) return '';

    final diff = difference(now);
    final days = diff.inDays;
    final hours = diff.inHours % 24;
    final minutes = diff.inMinutes % 60;
    final seconds = diff.inSeconds % 60;

    if (days > 0) return '$days天$hours小时后';
    if (hours > 0) return '$hours小时$minutes分钟后';
    if (minutes > 0) return '$minutes分钟$seconds秒后';
    return '$seconds秒后';
  }

  /// 是否为今天
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// 是否为昨天
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// 是否为本周（以周一为一周起始）
  bool get isSameWeek {
    final now = DateTime.now();
    // 计算当前日期所在周的周一
    final currentMonday = now.subtract(Duration(days: now.weekday - 1));
    final thisMonday = subtract(Duration(days: weekday - 1));
    return currentMonday.year == thisMonday.year &&
        currentMonday.month == thisMonday.month &&
        currentMonday.day == thisMonday.day;
  }

  /// 相对时间描述
  ///
  /// 返回友好的中文相对时间字符串。
  /// ```dart
  /// // 刚刚发生
  /// DateTime.now().relativeTime(); // '刚刚'
  /// // 5分钟前
  /// DateTime.now().subtract(Duration(minutes: 5)).relativeTime(); // '5分钟前'
  /// // 3小时前
  /// DateTime.now().subtract(Duration(hours: 3)).relativeTime(); // '3小时前'
  /// // 昨天
  /// DateTime.now().subtract(Duration(days: 1)).relativeTime(); // '昨天'
  /// ```
  String relativeTime() {
    final now = DateTime.now();
    final diff = now.difference(this);

    if (diff.isNegative) return '刚刚';

    final seconds = diff.inSeconds;
    final minutes = diff.inMinutes;
    final hours = diff.inHours;
    final days = diff.inDays;

    if (seconds < 60) return '刚刚';
    if (minutes < 60) return '$minutes分钟前';
    if (hours < 24) return '$hours小时前';
    if (isYesterday) return '昨天';
    if (days < 30) return '$days天前';
    if (days < 365) return '${days ~/ 30}个月前';
    return '${days ~/ 365}年前';
  }

  /// 季节名称
  ///
  /// 返回中文季节：春（3-5月）、夏（6-8月）、秋（9-11月）、冬（12-2月）。
  /// ```dart
  /// DateTime(2024, 4, 1).seasonName; // '春'
  /// DateTime(2024, 7, 1).seasonName; // '夏'
  /// ```
  String get seasonName => switch (month) {
        >= 3 && <= 5 => '春',
        >= 6 && <= 8 => '夏',
        >= 9 && <= 11 => '秋',
        _ => '冬',
      };
}
