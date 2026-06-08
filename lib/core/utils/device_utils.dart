import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';

/// 设备信息工具类
///
/// 使用 device_info_plus 获取设备型号、系统版本、唯一标识等信息。
class DeviceUtils {
  DeviceUtils._();

  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  /// 缓存的设备信息
  static BaseDeviceInfo? _deviceInfo;

  /// 初始化设备信息（建议在 App 启动时调用）
  static Future<void> init() async {
    _deviceInfo = await _deviceInfoPlugin.deviceInfo;
  }

  /// 获取设备信息（如果未初始化则自动获取）
  static Future<BaseDeviceInfo> getDeviceInfo() async {
    _deviceInfo ??= await _deviceInfoPlugin.deviceInfo;
    return _deviceInfo!;
  }

  // ==================== 设备型号 ====================

  /// 获取设备型号名称
  static String get model {
    if (_deviceInfo == null) return 'Unknown';
    if (_deviceInfo is AndroidDeviceInfo) {
      return (_deviceInfo as AndroidDeviceInfo).model;
    }
    if (_deviceInfo is IosDeviceInfo) {
      return (_deviceInfo as IosDeviceInfo).utsname.machine;
    }
    if (_deviceInfo is MacOsDeviceInfo) {
      return (_deviceInfo as MacOsDeviceInfo).model;
    }
    if (_deviceInfo is WindowsDeviceInfo) {
      return (_deviceInfo as WindowsDeviceInfo).productName;
    }
    if (_deviceInfo is LinuxDeviceInfo) {
      return (_deviceInfo as LinuxDeviceInfo).prettyName;
    }
    return 'Unknown';
  }

  /// 获取设备品牌
  static String get brand {
    if (_deviceInfo == null) return 'Unknown';
    if (_deviceInfo is AndroidDeviceInfo) {
      return (_deviceInfo as AndroidDeviceInfo).manufacturer;
    }
    if (_deviceInfo is IosDeviceInfo) {
      return 'Apple';
    }
    if (_deviceInfo is MacOsDeviceInfo) {
      return 'Apple';
    }
    return 'Unknown';
  }

  /// 获取设备制造商
  static String get manufacturer => brand;

  // ==================== 系统版本 ====================

  /// 获取操作系统名称
  static String get osName {
    if (Platform.isAndroid) return 'Android';
    if (Platform.isIOS) return 'iOS';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  /// 获取操作系统版本
  static String get osVersion {
    if (_deviceInfo == null) return 'Unknown';
    if (_deviceInfo is AndroidDeviceInfo) {
      final info = _deviceInfo as AndroidDeviceInfo;
      return 'Android ${info.version.release} (SDK ${info.version.sdkInt})';
    }
    if (_deviceInfo is IosDeviceInfo) {
      final info = _deviceInfo as IosDeviceInfo;
      return 'iOS ${info.systemVersion}';
    }
    if (_deviceInfo is MacOsDeviceInfo) {
      final info = _deviceInfo as MacOsDeviceInfo;
      return 'macOS ${info.osRelease}';
    }
    if (_deviceInfo is WindowsDeviceInfo) {
      final info = _deviceInfo as WindowsDeviceInfo;
      return 'Windows ${info.displayVersion}';
    }
    if (_deviceInfo is LinuxDeviceInfo) {
      final info = _deviceInfo as LinuxDeviceInfo;
      return info.prettyName;
    }
    return 'Unknown';
  }

  // ==================== 唯一标识 ====================

  /// 获取设备唯一标识
  ///
  /// Android: Android ID
  /// iOS: identifierForVendor
  static Future<String> getDeviceId() async {
    final info = await getDeviceInfo();
    if (info is AndroidDeviceInfo) {
      return info.id;
    }
    if (info is IosDeviceInfo) {
      return info.identifierForVendor ?? 'unknown';
    }
    if (info is MacOsDeviceInfo) {
      return info.systemGUID ?? 'unknown';
    }
    return 'unknown';
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
    await getDeviceInfo(); // 确保设备信息已初始化
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
