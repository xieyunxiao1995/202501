import 'package:flutter/material.dart';

/// 竹简组件
///
/// 古风竹简样式的文本展示组件，用于剧情文本和传记展示。
class BambooSlip extends StatelessWidget {
  /// 文本内容
  final String text;

  /// 最大行数
  final int maxLines;

  const BambooSlip({
    super.key,
    required this.text,
    this.maxLines = 10,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFD4A76A),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF8B6914)),
      ),
      child: Text(
        text,
        maxLines: maxLines,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          color: Color(0xFF3E2723),
          fontSize: 14,
          height: 1.8,
        ),
      ),
    );
  }
}
