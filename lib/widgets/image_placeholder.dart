import 'package:flutter/material.dart';

/// Image placeholder widget
class ImagePlaceholder extends StatelessWidget {
  final double? width;
  final double? height;
  final IconData icon;
  final double iconSize;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;

  const ImagePlaceholder({
    super.key,
    this.width,
    this.height,
    this.icon = Icons.image,
    this.iconSize = 32,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.grey[300],
        borderRadius: borderRadius,
      ),
      child: Center(
        child: Icon(icon, size: iconSize, color: Colors.grey[400]),
      ),
    );
  }
}
