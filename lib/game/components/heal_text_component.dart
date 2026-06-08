import 'package:flame/components.dart';

/// 治疗飘字组件
///
/// 在武将头顶显示治疗数值的飘字效果。
/// 使用绿色显示，数字向上飘动并逐渐消失。
class HealTextComponent extends PositionComponent {
  /// 治疗数值
  final double healAmount;

  /// 飘字持续时间（秒）
  final double duration;

  /// 上飘速度
  final double floatSpeed;

  /// 当前计时器
  double _timer = 0;

  HealTextComponent({
    required this.healAmount,
    this.duration = 1.0,
    this.floatSpeed = 60.0,
    super.position,
    super.anchor,
  });

  @override
  Future<void> onLoad() async {
    // TODO: 创建治疗数值文本组件，使用绿色
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;
    // TODO: 更新飘字位置和透明度
  }

  /// 是否已完成
  bool get isFinished => _timer >= duration;
}
