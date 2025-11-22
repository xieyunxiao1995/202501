import 'package:flutter/material.dart';
import 'package:zhenyu_flutter/theme.dart';

/// 一个通用的、带基础样式的文本组件
class StyledText extends StatelessWidget {
  const StyledText(
    this.text, {
    super.key,
    this.fontSize,
    this.color,
    this.style = textStylePrimary, // 默认为主要文字样式
  });

  /// 次要文字样式的构造函数
  const StyledText.secondary(this.text, {super.key, this.fontSize, this.color})
    : style = textStyleSecondary;

  /// 主要粗体文字样式的构造函数
  const StyledText.primaryBold(
    this.text, {
    super.key,
    this.fontSize,
    this.color,
  }) : style = textStylePrimaryBold;

  /// 主要粗体文字样式的构造函数
  const StyledText.inButton(this.text, {super.key, this.fontSize, this.color})
    : style = textStyleInButton;

  final String text;
  final double? fontSize;
  final Color? color;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    // 合并基础样式和动态传入的字体大小、颜色
    final finalStyle = style.copyWith(fontSize: fontSize, color: color);
    return Text(text, style: finalStyle);
  }
}
