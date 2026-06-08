import 'package:flutter/material.dart';

/// 国旗组件
///
/// 显示国家旗帜的组件，用于国战和国家选择场景。
class KingdomFlag extends StatelessWidget {
  /// 国家名称
  final String kingdom;

  /// 旗帜尺寸
  final double size;

  /// 是否飘动动画
  final bool waving;

  const KingdomFlag({
    super.key,
    required this.kingdom,
    this.size = 48,
    this.waving = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size * 0.75,
      height: size,
      decoration: BoxDecoration(
        color: _getKingdomColor(),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Text(
          kingdom,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.3,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getKingdomColor() {
    switch (kingdom) {
      case '魏':
        return Colors.blue.shade700;
      case '蜀':
        return Colors.green.shade700;
      case '吴':
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }
}
