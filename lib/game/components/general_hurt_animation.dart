import 'package:flame/components.dart';

/// 武将受击动画组件
///
/// 管理武将受到伤害时的动画表现，包括身体后仰、闪烁、震颤等效果。
/// 受击动画可以与其他动画叠加播放。
class GeneralHurtAnimation extends PositionComponent {
  /// 闪烁次数
  final int flashCount;

  /// 闪烁间隔（秒）
  final double flashInterval;

  /// 震颤幅度
  final double shakeAmplitude;

  /// 震颤持续时间（秒）
  final double shakeDuration;

  /// 动画完成回调
  void Function()? onComplete;

  GeneralHurtAnimation({
    this.flashCount = 3,
    this.flashInterval = 0.1,
    this.shakeAmplitude = 5.0,
    this.shakeDuration = 0.3,
    this.onComplete,
    super.position,
    super.size,
    super.anchor,
  });

  @override
  Future<void> onLoad() async {
    // TODO: 加载受击动画资源
  }

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 更新受击动画状态（闪烁、震颤）
  }

  /// 播放受击动画
  void play() {
    // TODO: 播放受击动画序列
    throw UnimplementedError();
  }

  /// 停止受击动画
  void stop() {
    // TODO: 停止受击动画
    throw UnimplementedError();
  }
}
