import 'package:flutter/material.dart';

/// 跑马灯文本组件
///
/// 水平滚动的文本组件，用于公告和通知展示。
class MarqueeText extends StatefulWidget {
  /// 文本内容
  final String text;

  /// 滚动速度
  final double velocity;

  /// 文本样式
  final TextStyle? style;

  const MarqueeText({
    super.key,
    required this.text,
    this.velocity = 30.0,
    this.style,
  });

  @override
  State<MarqueeText> createState() => _MarqueeTextState();
}

class _MarqueeTextState extends State<MarqueeText>
    with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: ListView(
        scrollDirection: Axis.horizontal,
        controller: _scrollController,
        children: [
          Text(widget.text, style: widget.style),
        ],
      ),
    );
  }
}
