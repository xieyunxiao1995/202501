import 'package:flutter/material.dart';

/// Buff图标组件
///
/// 战斗中显示增益/减益状态的图标组件。
class BuffIcon extends StatelessWidget {
  /// Buff名称
  final String name;

  /// 是否为增益
  final bool isPositive;

  /// 剩余回合数
  final int remainingRounds;

  /// 图标尺寸
  final double size;

  const BuffIcon({
    super.key,
    required this.name,
    this.isPositive = true,
    this.remainingRounds = 1,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isPositive
                  ? Colors.green.withValues(alpha: 0.3)
                  : Colors.red.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: isPositive ? Colors.green : Colors.red,
                width: 1,
              ),
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
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '$remainingRounds',
                style: const TextStyle(fontSize: 8, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
