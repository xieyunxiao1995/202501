import 'package:flame/components.dart';

/// 血条组件
///
/// 显示武将当前生命值的进度条，包含生命值比例的视觉反馈。
/// 血条颜色根据生命值百分比变化：绿 > 黄 > 红。
class HpBarComponent extends PositionComponent {
  /// 当前生命值
  double currentHp;

  /// 最大生命值
  double maxHp;

  /// 血条宽度
  final double barWidth;

  /// 血条高度
  final double barHeight;

  /// 是否显示数值文本
  final bool showText;

  HpBarComponent({
    required this.currentHp,
    required this.maxHp,
    this.barWidth = 60.0,
    this.barHeight = 6.0,
    this.showText = false,
    super.position,
    super.anchor,
  }) : super(size: Vector2(barWidth, barHeight));

  @override
  Future<void> onLoad() async {
    // TODO: 创建血条背景和填充组件
  }

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 平滑过渡血条变化
  }

  /// 更新生命值
  void updateHp(double newCurrentHp, double newMaxHp) {
    // TODO: 更新生命值并刷新血条显示
    throw UnimplementedError();
  }

  /// 获取血条颜色
  /// 根据百分比返回：>0.5 绿色，0.25~0.5 黄色，<0.25 红色
  int get colorByRatio {
    // TODO: 根据当前生命值比例返回颜色
    throw UnimplementedError();
  }
}
