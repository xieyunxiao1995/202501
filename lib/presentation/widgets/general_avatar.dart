import 'package:flutter/material.dart';

/// 武将头像组件
///
/// 圆形武将头像，带稀有度边框和阵营标识。
class GeneralAvatar extends StatelessWidget {
  /// 武将名称
  final String name;

  /// 稀有度
  final int rarity;

  /// 头像尺寸
  final double size;

  /// 点击回调
  final VoidCallback? onTap;

  const GeneralAvatar({
    super.key,
    required this.name,
    required this.rarity,
    this.size = 48,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
        radius: size / 2,
        child: Text(name[0]),
      ),
    );
  }
}
