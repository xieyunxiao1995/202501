import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

/// Shows a contextual SnackBar for common location permission / service errors.
///
/// [errorMessage] is typically the exception string thrown by Geolocator. This
/// helper inspects the contents and displays an appropriate message with
/// optional shortcuts to the relevant system settings screens.
void showLocationPermissionSnackBar(BuildContext context, String errorMessage) {
  SnackBar? snackBar;

  if (errorMessage.contains('permanently denied')) {
    snackBar = SnackBar(
      content: const Text('定位权限被永久关闭，请到系统设置开启后重试'),
      action: SnackBarAction(
        label: '去设置',
        onPressed: () {
          Geolocator.openAppSettings();
        },
      ),
    );
  } else if (errorMessage.contains('disabled')) {
    snackBar = SnackBar(
      content: const Text('定位服务已关闭，请开启定位服务'),
      action: SnackBarAction(
        label: '去设置',
        onPressed: () {
          Geolocator.openLocationSettings();
        },
      ),
    );
  } else if (errorMessage.contains('denied')) {
    snackBar = const SnackBar(content: Text('定位权限被拒绝了，请稍后重试'));
  }

  if (snackBar != null) {
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
