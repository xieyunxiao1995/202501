import 'package:intl/intl.dart';

/// 时间工具类
///
/// 提供时间格式化、倒计时、赛季计算、相对时间、服务器时间同步等常用功能。
class DateTimeUtils {
  DateTimeUtils._();

  // ==================== 服务器时间同步 ====================

  /// 服务器与本地的时间差（毫秒），正值表示服务器时间快于本地
  static int _serverTimeOffset = 0;

  /// 同步服务器时间
  ///
  /// [serverTimestamp] 服务器返回的当前时间戳（毫秒）
  /// [localTimestamp]  发起请求时的本地时间戳（毫秒），默认取当前时间
  static void syncServerTime(int serverTimestamp, {int? localTimestamp}) {
    _serverTimeOffset = serverTimestamp - (localTimestamp ?? DateTime.now().millisecondsSinceEpoch);
  }

  /// 获取当前服务器时间
  static DateTime get nowServer {
    return DateTime.fromMillisecondsSinceEpoch(
      DateTime.now().millisecondsSinceEpoch + _serverTimeOffset,
    );
  }

  /// 获取当前服务器时间戳（毫秒）
  static int get nowServerTimestamp {
    return DateTime.now().millisecondsSinceEpoch + _serverTimeOffset;
  }

  // ==================== 格式化 ====================

  /// 格式化为日期字符串 "yyyy-MM-dd"
  static String formatDate(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('yyyy-MM-dd').format(dateTime);
  }

  /// 格式化为时间字符串 "HH:mm:ss"
  static String formatTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('HH:mm:ss').format(dateTime);
  }

  /// 格式化为日期时间字符串 "yyyy-MM-dd HH:mm:ss"
  static String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
  }

  /// 自定义格式化
  ///
  /// [pattern] 遵循 intl DateFormat 模式，如 "yyyy年MM月dd日 HH:mm"
  static String format(DateTime? dateTime, String pattern) {
    if (dateTime == null) return '';
    return DateFormat(pattern).format(dateTime);
  }

  /// 格式化为简短时间 "MM/dd HH:mm"
  static String formatShort(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('MM/dd HH:mm').format(dateTime);
  }

  /// 格式化为中文日期 "yyyy年MM月dd日"
  static String formatDateCN(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('yyyy年MM月dd日').format(dateTime);
  }

  // ==================== 倒计时 ====================

  /// 将剩余秒数转换为可读的倒计时字符串
  ///
  /// 示例：
  /// - 90 → "1分30秒"
  /// - 3661 → "1时1分1秒"
  /// - 267840 → "3天2时24分"
  ///
  /// [showSeconds] 是否显示秒数，默认 true
  static String countdown(int seconds, {bool showSeconds = true}) {
    if (seconds <= 0) return showSeconds ? '0秒' : '已结束';

    final days = seconds ~/ 86400;
    final hours = (seconds % 86400) ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    final parts = <String>[];
    if (days > 0) parts.add('$days天');
    if (hours > 0) parts.add('$hours时');
    if (minutes > 0) parts.add('$minutes分');
    if (showSeconds && secs > 0) parts.add('$secs秒');

    return parts.isEmpty ? (showSeconds ? '0秒' : '已结束') : parts.join('');
  }

  /// 将剩余秒数转换为简短倒计时字符串
  ///
  /// 示例：
  /// - 90 → "1:30"
  /// - 3661 → "1:01:01"
  /// - 267840 → "3天2:24"
  static String countdownShort(int seconds) {
    if (seconds <= 0) return '0:00';

    final days = seconds ~/ 86400;
    final hours = (seconds % 86400) ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (days > 0) {
      return '$days天$hours:${minutes.toString().padLeft(2, '0')}';
    }
    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  // ==================== 赛季计算 ====================

  /// 计算当前赛季编号
  ///
  /// [seasonStartDate] 赛季开始日期
  /// [seasonDurationDays] 赛季持续天数，默认30天
  static int currentSeasonNumber(DateTime seasonStartDate, {int seasonDurationDays = 30}) {
    final now = nowServer;
    if (now.isBefore(seasonStartDate)) return 1;
    final diff = now.difference(seasonStartDate).inDays;
    return (diff ~/ seasonDurationDays) + 1;
  }

  /// 获取赛季剩余天数
  static int seasonRemainingDays(DateTime seasonStartDate, {int seasonDurationDays = 30}) {
    final now = nowServer;
    if (now.isBefore(seasonStartDate)) return seasonDurationDays;
    final diff = now.difference(seasonStartDate).inDays;
    final daysInSeason = diff % seasonDurationDays;
    return seasonDurationDays - daysInSeason;
  }

  /// 获取赛季进度（0.0 ~ 1.0）
  static double seasonProgress(DateTime seasonStartDate, {int seasonDurationDays = 30}) {
    final now = nowServer;
    if (now.isBefore(seasonStartDate)) return 0.0;
    final diff = now.difference(seasonStartDate).inDays;
    final daysInSeason = diff % seasonDurationDays;
    return daysInSeason / seasonDurationDays;
  }

  // ==================== 相对时间 ====================

  /// 获取相对时间描述
  ///
  /// 示例：
  /// - 10秒内 → "刚刚"
  /// - 5分钟前 → "5分钟前"
  /// - 3小时前 → "3小时前"
  /// - 昨天内 → "昨天"
  /// - 7天内 → "3天前"
  /// - 更早 → "MM月dd日"
  static String relativeTime(DateTime dateTime) {
    final now = nowServer;
    final diff = now.difference(dateTime);

    if (diff.isNegative) return '刚刚';

    final seconds = diff.inSeconds;
    final minutes = diff.inMinutes;
    final hours = diff.inHours;
    final days = diff.inDays;

    if (seconds < 10) return '刚刚';
    if (seconds < 60) return '$seconds秒前';
    if (minutes < 60) return '$minutes分钟前';
    if (hours < 24) return '$hours小时前';
    if (days == 1) return '昨天';
    if (days < 7) return '$days天前';
    if (days < 30) return '$days天前';

    // 超过30天显示日期
    return DateFormat('MM月dd日').format(dateTime);
  }

  /// 获取简短相对时间描述（用于列表展示）
  ///
  /// 示例："刚刚" / "5分前" / "3时前" / "昨天" / "3天前"
  static String relativeTimeShort(DateTime dateTime) {
    final now = nowServer;
    final diff = now.difference(dateTime);

    if (diff.isNegative) return '刚刚';

    final seconds = diff.inSeconds;
    final minutes = diff.inMinutes;
    final hours = diff.inHours;
    final days = diff.inDays;

    if (seconds < 10) return '刚刚';
    if (seconds < 60) return '$seconds秒前';
    if (minutes < 60) return '$minutes分前';
    if (hours < 24) return '$hours时前';
    if (days == 1) return '昨天';
    if (days < 7) return '$days天前';

    return DateFormat('MM/dd').format(dateTime);
  }

  // ==================== 判定辅助 ====================

  /// 判断是否是今天
  static bool isToday(DateTime dateTime) {
    final now = nowServer;
    return dateTime.year == now.year &&
        dateTime.month == now.month &&
        dateTime.day == now.day;
  }

  /// 判断是否是昨天
  static bool isYesterday(DateTime dateTime) {
    final yesterday = nowServer.subtract(const Duration(days: 1));
    return dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day;
  }

  /// 判断两个日期是否是同一天
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// 获取今天的开始时间（00:00:00）
  static DateTime startOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  /// 获取今天的结束时间（23:59:59.999）
  static DateTime endOfDay(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day, 23, 59, 59, 999);
  }

  /// 获取本周一的时间
  static DateTime startOfWeek(DateTime dateTime) {
    final weekday = dateTime.weekday;
    return startOfDay(dateTime.subtract(Duration(days: weekday - 1)));
  }

  /// 获取本月1号的时间
  static DateTime startOfMonth(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, 1);
  }
}
