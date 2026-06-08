import 'package:flutter/material.dart';

/// 阵营徽章组件
///
/// 显示武将所属阵营（魏蜀吴群）的徽章标识。
class KingdomBadge extends StatelessWidget {
  /// 阵营名称
  final String kingdom;

  /// 徽章尺寸
  final double size;

  const KingdomBadge({
    super.key,
    required this.kingdom,
    this.size = 24,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getKingdomColor().withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          kingdom[0],
          style: TextStyle(
            color: _getKingdomColor(),
            fontSize: size * 0.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getKingdomColor() {
    switch (kingdom) {
      case '魏':
        return Colors.blue;
      case '蜀':
        return Colors.green;
      case '吴':
        return Colors.red;
      case '群':
        return Colors.yellow;
      default:
        return Colors.grey;
    }
  }
}
