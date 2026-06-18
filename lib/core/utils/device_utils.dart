import 'dart:io';

import 'package:flutter/foundation.dart';

/// 设备信息工具类
///
/// iOS 简化版本：写死 iOS 设备信息，不依赖 device_info_plus。
class DeviceUtils {
  DeviceUtils._();

  // ==================== 设备型号 ====================

  /// 获取设备型号名称（iOS 写死）
  static String get model => 'iPhone';

  /// 获取设备品牌（iOS 固定为 Apple）
  static String get brand => 'Apple';

  /// 获取设备制造商（iOS 固定为 Apple）
  static String get manufacturer => 'Apple';

  // ==================== 系统版本 ====================

  /// 获取操作系统名称（iOS 固定）
  static String get osName => 'iOS';

  /// 获取操作系统版本（iOS 写死）
  static String get osVersion => 'iOS 17.0';

  // ==================== 唯一标识 ====================

  /// 获取设备唯一标识（iOS 写死）
  static Future<String> getDeviceId() async {
    return 'ios-device';
  }

  // ==================== 设备特征判断 ====================

  /// 是否是 Android 设备
  static bool get isAndroid => Platform.isAndroid;

  /// 是否是 iOS 设备
  static bool get isIOS => Platform.isIOS;

  /// 是否是移动设备
  static bool get isMobile => Platform.isAndroid || Platform.isIOS;

  /// 是否是桌面设备
  static bool get isDesktop => Platform.isMacOS || Platform.isWindows || Platform.isLinux;

  /// 是否是 Debug 模式
  static bool get isDebug => kDebugMode;

  /// 是否是 Release 模式
  static bool get isRelease => kReleaseMode;

  /// 是否是 Profile 模式
  static bool get isProfile => kProfileMode;

  // ==================== 设备信息摘要 ====================

  /// 获取设备信息摘要，用于日志上报等场景
  static Future<Map<String, String>> getDeviceSummary() async {
    final deviceId = await getDeviceId();

    return {
      'platform': osName,
      'osVersion': osVersion,
      'model': model,
      'brand': brand,
      'deviceId': deviceId,
      'isDebug': isDebug.toString(),
    };
  }
}
