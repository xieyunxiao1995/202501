import 'package:flutter/material.dart';

/// 星级评分组件
///
/// 显示武将星级的评分组件，支持半星显示。
class StarRating extends StatelessWidget {
  /// 星级数
  final int rating;

  /// 最大星级
  final int maxRating;

  /// 星星尺寸
  final double size;

  const StarRating({
    super.key,
    required this.rating,
    this.maxRating = 5,
    this.size = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        return Icon(
          index < rating ? Icons.star : Icons.star_border,
          size: size,
          color: Colors.amber,
        );
      }),
    );
  }
}
