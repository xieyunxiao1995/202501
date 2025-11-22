import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences 键名常量
/// 还没开始完全改过来。只把tipsDialogLastShownDate改了
class StorageKeys {
  /// 用户信息
  static const String userMeInfo = 'userMeInfo';
  static const String userInfo = 'userInfo';
  static const String token = 'token';

  /// 位置数据
  static const String longitudeData = 'longitudeData';

  /// 对话框展示日期
  static const String tipsDialogLastShownDate = 'tipsDialogLastShownDate';

  /// 初始化配置
  static const String initConfig = 'initConfig';
}

/// 显示一个 Toast 消息
void showMsg(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(text), duration: const Duration(seconds: 2)),
  );
}

/// 防抖函数
///
/// [func] 需要防抖的函数
/// [delay] 防抖的时间间隔
Function debounce(
  Function func, [
  Duration delay = const Duration(milliseconds: 500),
]) {
  Timer? timer;
  return (dynamic a) {
    if (timer?.isActive ?? false) {
      timer?.cancel();
    }
    timer = Timer(delay, () {
      func(a);
    });
  };
}

/// 将时间字符串格式化为 'yyyy-MM-dd'
/// 如果解析失败，返回 '--' 或指定的默认值
String formatDate(String timeStr, {String defaultValue = '--'}) {
  try {
    final date = DateTime.parse(timeStr);
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  } catch (e) {
    debugPrint('日期解析失败: $timeStr, 错误: $e');
    return defaultValue;
  }
}

/// 将秒数格式化为 'x 时 y 分'
String formatSecondsToHoursMinutes(int seconds) {
  final hours = seconds ~/ 3600;
  final remainingSeconds = seconds % 3600;
  final minutes = remainingSeconds ~/ 60;
  return "$hours 时 $minutes 分";
}

/// 将时间戳格式化为相对时间 (例如：'5 分钟前')
String formatTimeAgo(int timestamp) {
  final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
  final diff = now - timestamp;

  if (diff < 60) {
    return "刚刚";
  } else if (diff < 3600) {
    final minutes = diff ~/ 60;
    return "$minutes 分钟前";
  } else if (diff < 86400) {
    final hours = diff ~/ 3600;
    return "$hours 小时前";
  } else if (diff < 2592000) {
    final days = diff ~/ 86400;
    return "$days 天前";
  } else if (diff < 31536000) {
    final months = diff ~/ 2592000;
    return "$months 个月前";
  } else {
    final years = diff ~/ 31536000;
    return "$years 年前";
  }
}

/// 将距离格式化为 'x.xx km' 或 'x m'
String formatDistance(double distance) {
  if (distance >= 100000) {
    return "1000km+";
  } else if (distance >= 1000) {
    return "${(distance / 1000).toStringAsFixed(2)}km";
  } else if (distance >= 100) {
    return "${distance.toStringAsFixed(2)}m";
  } else {
    return '小于100m';
  }
}

bool getUserVipInfo(SharedPreferences prefs) {
  final userMeInfoString = prefs.getString(StorageKeys.userMeInfo);
  if (userMeInfoString != null) {
    try {
      final userMeInfo = jsonDecode(userMeInfoString);
      final vipValue = userMeInfo['vip'];

      return vipValue == 1;
    } catch (e) {
      debugPrint('解析 userMeInfo 失败: $e');
      return false;
    }
  } else {
    debugPrint('userMeInfo 不存在');
    return false;
  }
}

/// 检查今天是否应该显示对话框/提示
///
/// [storageKey] SharedPreferences 中保存日期的键名
///
/// 返回 true 表示今天还未显示过，应该显示
/// 返回 false 表示今天已显示过，不应该再显示
/// 配合 markDialogShownToday 方法
Future<bool> shouldShowDialogToday(String storageKey) async {
  final prefs = await SharedPreferences.getInstance();
  final lastShownDate = prefs.getString(storageKey);
  final today = DateTime.now().toIso8601String().split(
    'T',
  )[0]; // 格式: YYYY-MM-DD

  //  上次展示日期: $lastShownDate'lastShownDate
  // 今天日期: $today'
  if (lastShownDate == null || lastShownDate != today) {
    return true;
  } else {
    return false;
  }
}

/// 标记对话框/提示已在今天展示过
/// 配合 shouldShowDialogToday方法
Future<void> markDialogShownToday(String storageKey) async {
  final prefs = await SharedPreferences.getInstance();
  final today = DateTime.now().toIso8601String().split(
    'T',
  )[0]; // 格式: YYYY-MM-DD
  await prefs.setString(storageKey, today);
  debugPrint('[$storageKey] 已标记展示日期: $today');
}
