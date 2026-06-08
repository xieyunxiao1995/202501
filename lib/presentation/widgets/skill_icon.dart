import 'package:flutter/material.dart';

/// 技能图标组件
///
/// 显示武将技能图标，包含技能类型边框和等级标识。
class SkillIcon extends StatelessWidget {
  /// 技能ID
  final String skillId;

  /// 技能名称
  final String name;

  /// 技能等级
  final int level;

  /// 图标尺寸
  final double size;

  /// 点击回调
  final VoidCallback? onTap;

  const SkillIcon({
    super.key,
    required this.skillId,
    required this.name,
    this.level = 1,
    this.size = 48,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size,
        height: size,
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(name[0]),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Lv.$level',
                  style: const TextStyle(fontSize: 8, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
