import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DualGlowBackground extends StatelessWidget {
  final Widget child;

  const DualGlowBackground({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 主背景色
        Positioned.fill(
          child: Container(
            color: AppColors.tableBackground,
          ),
        ),
        
        // 顶部整体渐变 - 从顶部向下，左右融合
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFFF8C69).withValues(alpha: 0.35), // 橙色
                  const Color(0xFFFFB6A3).withValues(alpha: 0.28), // 橙粉混合
                  const Color(0xFFFF9B8E).withValues(alpha: 0.22),
                  const Color(0xFFFFB6A3).withValues(alpha: 0.16),
                  AppColors.tableBackground.withValues(alpha: 0.9),
                  AppColors.tableBackground,
                ],
                stops: const [0.0, 0.15, 0.3, 0.5, 0.75, 1.0],
              ),
            ),
          ),
        ),
        
        // 右上角粉红色点缀
        Positioned(
          top: -50,
          right: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFF69B4).withValues(alpha: 0.25),
                  const Color(0xFFFF69B4).withValues(alpha: 0.15),
                  const Color(0xFFFF69B4).withValues(alpha: 0.08),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
        ),
        
        // 左上角橙色点缀
        Positioned(
          top: -50,
          left: -50,
          child: Container(
            width: 300,
            height: 300,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  const Color(0xFFFF8C69).withValues(alpha: 0.25),
                  const Color(0xFFFF8C69).withValues(alpha: 0.15),
                  const Color(0xFFFF8C69).withValues(alpha: 0.08),
                  Colors.transparent,
                ],
                stops: const [0.0, 0.4, 0.7, 1.0],
              ),
            ),
          ),
        ),
        
        // 内容
        child,
      ],
    );
  }
}
