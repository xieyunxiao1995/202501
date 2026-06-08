import 'package:flutter/material.dart';

/// 武将立绘组件
///
/// 武将详情页使用的全屏立绘展示组件。
class GeneralPortrait extends StatelessWidget {
  /// 武将ID
  final String generalId;

  /// 是否显示觉醒特效
  final bool showAwakeEffect;

  const GeneralPortrait({
    super.key,
    required this.generalId,
    this.showAwakeEffect = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade800,
      child: const Center(
        child: Text('武将立绘'),
      ),
    );
  }
}
