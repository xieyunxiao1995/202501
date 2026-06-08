import 'package:flutter/material.dart';

/// 滚动图片组件
///
/// 水平滚动的图片轮播组件，用于活动横幅和公告展示。
class ScrollImage extends StatelessWidget {
  /// 图片URL列表
  final List<String> imageUrls;

  /// 点击回调
  final ValueChanged<int>? onTap;

  /// 是否自动播放
  final bool autoPlay;

  const ScrollImage({
    super.key,
    required this.imageUrls,
    this.onTap,
    this.autoPlay = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: PageView.builder(
        itemCount: imageUrls.length,
        onPageChanged: (_) {},
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => onTap?.call(index),
            child: Container(
              color: Colors.grey.shade700,
              child: Center(
                child: Text('图片 ${index + 1}'),
              ),
            ),
          );
        },
      ),
    );
  }
}
