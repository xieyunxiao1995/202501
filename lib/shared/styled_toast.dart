import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/theme.dart';

enum StyledToastType { info, success, warning, error }

class StyledToast {
  const StyledToast._();

  static void show(
    BuildContext context, {
    required String message,
    StyledToastType type = StyledToastType.info,
    Duration duration = const Duration(seconds: 3),
    bool clearExisting = true,
    String? actionLabel,
    VoidCallback? onAction,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    final messenger = maybeOf(context);
    messenger?.show(
      message: message,
      type: type,
      duration: duration,
      clearExisting: clearExisting,
      actionLabel: actionLabel,
      onAction: onAction,
      behavior: behavior,
      margin: margin,
      padding: padding,
    );
  }

  static StyledToastMessenger of(BuildContext context) {
    return StyledToastMessenger._(ScaffoldMessenger.of(context));
  }

  static StyledToastMessenger? maybeOf(BuildContext context) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      return null;
    }
    return StyledToastMessenger._(messenger);
  }

  static SnackBar _createSnackBar({
    required String message,
    required StyledToastType type,
    required Duration duration,
    required SnackBarBehavior behavior,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final bool isFloating = behavior == SnackBarBehavior.floating;
    return SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: _textColor(type),
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: _backgroundColor(type),
      behavior: behavior,
      duration: duration,
      margin: isFloating
          ? margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12)
          : margin,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: isFloating
          ? RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
          : null,
      action: (actionLabel != null && onAction != null)
          ? SnackBarAction(
              label: actionLabel,
              onPressed: onAction,
              textColor: _actionTextColor(type),
            )
          : null,
    );
  }

  static Color _backgroundColor(StyledToastType type) {
    switch (type) {
      case StyledToastType.success:
        return AppColors.accentGreen.withOpacity(0.85);
      case StyledToastType.warning:
        return AppColors.secondaryGradientStart.withOpacity(0.95);
      case StyledToastType.error:
        return AppColors.lightRed.withOpacity(0.9);
      case StyledToastType.info:
      default:
        return AppColors.backgroundWhite15;
    }
  }

  static Color _textColor(StyledToastType type) {
    switch (type) {
      case StyledToastType.success:
      case StyledToastType.warning:
        return AppColors.primaryColor;
      case StyledToastType.error:
      case StyledToastType.info:
      default:
        return AppColors.textPrimary;
    }
  }

  static Color _actionTextColor(StyledToastType type) {
    switch (type) {
      case StyledToastType.success:
      case StyledToastType.warning:
        return AppColors.primaryColor;
      case StyledToastType.error:
      case StyledToastType.info:
      default:
        return AppColors.textPrimary;
    }
  }
}

class StyledToastMessenger {
  StyledToastMessenger._(this._messenger);

  final ScaffoldMessengerState _messenger;

  void show({
    required String message,
    StyledToastType type = StyledToastType.info,
    Duration duration = const Duration(seconds: 3),
    bool clearExisting = true,
    String? actionLabel,
    VoidCallback? onAction,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    EdgeInsetsGeometry? margin,
    EdgeInsetsGeometry? padding,
  }) {
    if (message.trim().isEmpty) {
      return;
    }

    if (clearExisting) {
      _messenger.hideCurrentSnackBar();
    }

    final snackBar = StyledToast._createSnackBar(
      message: message,
      type: type,
      duration: duration,
      behavior: behavior,
      margin: margin,
      padding: padding,
      actionLabel: actionLabel,
      onAction: onAction,
    );

    _messenger.showSnackBar(snackBar);
  }
}
