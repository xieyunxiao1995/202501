import 'package:flame/components.dart';

/// 武将阵亡动画组件
///
/// 管理武将阵亡时的动画表现，包括倒下、消散、退场等效果。
/// 阵亡动画完成后武将组件将标记为不可交互状态。
class GeneralDeathAnimation extends PositionComponent {
  /// 倒下动画时长（秒）
  final double fallDuration;

  /// 消散动画时长（秒）
  final double fadeDuration;

  /// 退场延迟时间（秒）
  final double exitDelay;

  /// 动画完成回调
  void Function()? onComplete;

  GeneralDeathAnimation({
    this.fallDuration = 0.4,
    this.fadeDuration = 0.6,
    this.exitDelay = 1.0,
    this.onComplete,
    super.position,
    super.size,
    super.anchor,
  });

  @override
  Future<void> onLoad() async {
    // TODO: 加载阵亡动画资源
  }

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 更新阵亡动画状态
  }

  /// 播放阵亡动画
  void play() {
    // TODO: 播放阵亡动画序列（倒下 → 消散 → 退场）
    throw UnimplementedError();
  }

  /// 停止阵亡动画
  void stop() {
    // TODO: 停止阵亡动画
    throw UnimplementedError();
  }
}
