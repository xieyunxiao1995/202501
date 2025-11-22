import 'dart:async';

import 'package:flutter/material.dart';

import 'package:zhenyu_flutter/shared/styled_button.dart';
import 'package:zhenyu_flutter/shared/styled_text.dart';
import 'package:zhenyu_flutter/theme.dart';

/// 通用弹窗组件，统一项目内弹窗样式
class StyledDialog extends StatelessWidget {
  const StyledDialog({
    super.key,
    this.title,
    this.titleText,
    this.content,
    this.contentText,
    this.width,
    this.showCancelButton = true,
    this.confirmText = '确认',
    this.cancelText = '取消',
    this.onConfirm,
    this.onCancel,
    this.dismissOnConfirm = true,
    this.dismissOnCancel = true,
    this.confirmGradient,
    this.cancelGradient,
    this.confirmBackgroundColor,
    this.cancelBackgroundColor,
    this.confirmTextStyle,
    this.cancelTextStyle,
  });

  /// 标题 widget，优先级最高
  final Widget? title;

  /// 标题纯文本，若 [title] 为空时生效
  final String? titleText;

  /// 内容 widget，优先级最高
  final Widget? content;

  /// 内容纯文本，若 [content] 为空时生效
  final String? contentText;

  /// 自定义弹窗宽度（默认 75% 屏幕宽度）
  final double? width;

  /// 是否展示取消按钮（默认展示）
  final bool showCancelButton;

  /// 确认按钮文案
  final String confirmText;

  /// 取消按钮文案
  final String cancelText;

  /// 确认回调（支持异步），返回后若 [dismissOnConfirm] 为 true 会自动关闭
  final FutureOr<void> Function(BuildContext context)? onConfirm;

  /// 取消回调（支持异步），返回后若 [dismissOnCancel] 为 true 会自动关闭
  final FutureOr<void> Function(BuildContext context)? onCancel;

  /// 点击确认后是否自动关闭弹窗
  final bool dismissOnConfirm;

  /// 点击取消后是否自动关闭弹窗
  final bool dismissOnCancel;

  /// 确认按钮渐变样式（默认主色渐变）
  final Gradient? confirmGradient;

  /// 取消按钮渐变样式
  final Gradient? cancelGradient;

  /// 确认按钮背景色（会覆盖渐变）
  final Color? confirmBackgroundColor;

  /// 取消按钮背景色（会覆盖渐变）
  final Color? cancelBackgroundColor;

  /// 确认按钮文字样式
  final TextStyle? confirmTextStyle;

  /// 取消按钮文字样式
  final TextStyle? cancelTextStyle;

  /// 快捷方法，外部通过 `StyledDialog.show(...)` 调用即可
  static Future<T?> show<T>({
    required BuildContext context,
    Widget? title,
    String? titleText,
    Widget? content,
    String? contentText,
    double? width,
    bool showCancelButton = true,
    String confirmText = '确认',
    String cancelText = '取消',
    FutureOr<void> Function(BuildContext context)? onConfirm,
    FutureOr<void> Function(BuildContext context)? onCancel,
    bool dismissOnConfirm = true,
    bool dismissOnCancel = true,
    bool barrierDismissible = false, // 是否允许点击空白区域关闭
    Gradient? confirmGradient,
    Gradient? cancelGradient,
    Color? confirmBackgroundColor,
    Color? cancelBackgroundColor,
    TextStyle? confirmTextStyle,
    TextStyle? cancelTextStyle,
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible, // 使用参数控制
      builder: (_) => StyledDialog(
        title: title,
        titleText: titleText,
        content: content,
        contentText: contentText,
        width: width,
        showCancelButton: showCancelButton,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        dismissOnConfirm: dismissOnConfirm,
        dismissOnCancel: dismissOnCancel,
        confirmGradient: confirmGradient,
        cancelGradient: cancelGradient,
        confirmBackgroundColor: confirmBackgroundColor,
        cancelBackgroundColor: cancelBackgroundColor,
        confirmTextStyle: confirmTextStyle,
        cancelTextStyle: cancelTextStyle,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dialogWidth = width ?? MediaQuery.of(context).size.width * 0.75;

    return Dialog(
      backgroundColor: AppColors.textFieldBackground,
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: dialogWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildTitle(),
              const SizedBox(height: 16),
              _buildContent(),
              const SizedBox(height: 28),
              _buildActions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    if (title != null) return title!;
    if (titleText != null) {
      return StyledText.primaryBold(
        titleText!,
        fontSize: 18,
        color: Colors.white,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildContent() {
    if (content != null) return content!;
    if (contentText != null) {
      return StyledText(
        contentText!,
        fontSize: 14,
        color: Colors.white.withOpacity(0.85),
        style: textStylePrimary.copyWith(height: 1.6),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildActions(BuildContext context) {
    final actions = <Widget>[];

    actions.add(
      Expanded(
        child: StyledButton(
          onPressed: () => _handleConfirm(context),
          height: 48,
          borderRadius: BorderRadius.circular(30),
          gradient: confirmGradient ?? AppGradients.primaryGradient,
          backgroundColor: confirmBackgroundColor,
          child: StyledText.inButton(
            confirmText,
            color: confirmTextStyle?.color ?? Colors.black,
            fontSize: confirmTextStyle?.fontSize ?? 16,
          ),
        ),
      ),
    );

    if (showCancelButton) {
      actions.add(const SizedBox(width: 16));
      actions.add(
        Expanded(
          child: StyledButton(
            onPressed: () => _handleCancel(context),
            height: 48,
            borderRadius: BorderRadius.circular(30),
            gradient: cancelGradient,
            backgroundColor:
                cancelBackgroundColor ?? Colors.white.withOpacity(0.08),
            child: StyledText(
              cancelText,
              color: cancelTextStyle?.color ?? Colors.white,
              fontSize: cancelTextStyle?.fontSize ?? 16,
              style:
                  cancelTextStyle ??
                  textStylePrimary.copyWith(color: Colors.white),
            ),
          ),
        ),
      );
    }

    return Row(children: actions);
  }

  Future<void> _handleConfirm(BuildContext context) async {
    if (onConfirm != null) {
      await onConfirm!(context);
    }
    if (dismissOnConfirm && Navigator.of(context).canPop()) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _handleCancel(BuildContext context) async {
    if (onCancel != null) {
      await onCancel!(context);
    }
    if (dismissOnCancel && Navigator.of(context).canPop()) {
      Navigator.of(context).pop(false);
    }
  }
}
