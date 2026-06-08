import 'package:flame/components.dart';

/// 怒气条组件
///
/// 显示武将当前怒气值的进度条，怒气满时可释放终极技能。
/// 怒气条在满值时会有闪光提示效果。
class RageBarComponent extends PositionComponent {
  /// 当前怒气值 (0-100)
  double currentRage;

  /// 最大怒气值
  static const double maxRage = 100.0;

  /// 怒气条宽度
  final double barWidth;

  /// 怒气条高度
  final double barHeight;

  /// 是否满怒气
  bool get isFull => currentRage >= maxRage;

  RageBarComponent({
    required this.currentRage,
    this.barWidth = 60.0,
    this.barHeight = 4.0,
    super.position,
    super.anchor,
  }) : super(size: Vector2(barWidth, barHeight));

  @override
  Future<void> onLoad() async {
    // TODO: 创建怒气条背景和填充组件
  }

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 满怒气时更新闪光效果
  }

  /// 更新怒气值
  void updateRage(double newRage) {
    // TODO: 更新怒气值并刷新怒气条显示
    throw UnimplementedError();
  }

  /// 重置怒气值（释放大招后）
  void resetRage() {
    // TODO: 清空怒气值
    throw UnimplementedError();
  }
}
