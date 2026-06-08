import 'package:flutter/material.dart';

/// 缓存图片组件
///
/// 带缓存和占位符的图片组件，用于加载网络图片。
class CachedImage extends StatelessWidget {
  /// 图片URL
  final String imageUrl;

  /// 宽度
  final double? width;

  /// 高度
  final double? height;

  /// 圆角
  final BorderRadius? borderRadius;

  /// 适配方式
  final BoxFit fit;

  const CachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.borderRadius,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = Image.network(
      imageUrl,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (_, __, ___) => _buildPlaceholder(),
      loadingBuilder: (_, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildPlaceholder();
      },
    );

    if (borderRadius != null) {
      image = ClipRRect(
        borderRadius: borderRadius!,
        child: image,
      );
    }

    return image;
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey.shade300,
      child: const Icon(Icons.image, color: Colors.grey),
    );
  }
}
