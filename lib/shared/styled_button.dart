import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/theme.dart';

class StyledButton extends StatelessWidget {
  const StyledButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.width,
    this.height,
    this.margin,
    this.padding,
    this.borderRadius,
    this.gradient,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.disabledTextColor,
  });

  final VoidCallback? onPressed;
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final Gradient? gradient;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final Color? disabledTextColor;

  @override
  Widget build(BuildContext context) {
    final bool enabled = onPressed != null;
    final borderRadiusValue = borderRadius ?? BorderRadius.circular(8);

    return InkWell(
      onTap: enabled ? onPressed : null,
      borderRadius: borderRadiusValue,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        padding:
            padding ?? const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        decoration: BoxDecoration(
          color: enabled
              ? backgroundColor
              : disabledBackgroundColor ?? Colors.white24,
          gradient: enabled && backgroundColor == null
              ? (gradient ?? AppGradients.primaryGradient)
              : null,
          borderRadius: borderRadiusValue,
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: AppColors.shadow,
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: DefaultTextStyle(
            style: TextStyle(
              color: enabled
                  ? AppColors.vipGold
                  : disabledTextColor ?? Colors.white54,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
