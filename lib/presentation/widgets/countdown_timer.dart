import 'package:flutter/material.dart';

/// 倒计时组件
///
/// 显示倒计时时间的组件，用于活动倒计时、建筑升级倒计时等场景。
class CountdownTimer extends StatelessWidget {
  /// 剩余秒数
  final int remainingSeconds;

  /// 显示格式
  final CountdownFormat format;

  /// 时间到回调
  final VoidCallback? onFinished;

  const CountdownTimer({
    super.key,
    required this.remainingSeconds,
    this.format = CountdownFormat.hhMmSs,
    this.onFinished,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      _formatTime(remainingSeconds),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  String _formatTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;
    final s = seconds % 60;
    switch (format) {
      case CountdownFormat.hhMmSs:
        return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
      case CountdownFormat.mmSs:
        return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
      case CountdownFormat.ddHhMm:
        final d = h ~/ 24;
        final rh = h % 24;
        return '${d}天${rh}时${m}分';
    }
  }
}

/// 倒计时格式枚举
enum CountdownFormat {
  /// 时:分:秒
  hhMmSs,

  /// 分:秒
  mmSs,

  /// 天时分
  ddHhMm,
}
