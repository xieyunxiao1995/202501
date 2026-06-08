import 'package:flame/components.dart';

/// 伤害飘字组件
///
/// 在武将头顶显示伤害数值的飘字效果。
/// 数字向上飘动并逐渐消失，暴击伤害会有放大和特殊颜色效果。
class DamageTextComponent extends PositionComponent {
  /// 伤害数值
  final double damage;

  /// 是否为暴击
  final bool isCritical;

  /// 飘字持续时间（秒）
  final double duration;

  /// 上飘速度
  final double floatSpeed;

  /// 是否为兵种克制伤害
  final bool isCountered;

  /// 当前计时器
  double _timer = 0;

  DamageTextComponent({
    required this.damage,
    this.isCritical = false,
    this.duration = 1.0,
    this.floatSpeed = 60.0,
    this.isCountered = false,
    super.position,
    super.anchor,
  });

  @override
  Future<void> onLoad() async {
    // TODO: 创建伤害数值文本组件
    // TODO: 根据暴击/克制设置颜色和大小
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
