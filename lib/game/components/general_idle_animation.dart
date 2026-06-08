import 'package:flame/components.dart';

/// 武将待机动画组件
///
/// 管理武将的待机状态动画，包括呼吸效果和微小的身体摆动。
/// 作为默认动画状态，其他动画结束后自动切换回此动画。
class GeneralIdleAnimation extends PositionComponent {
  /// 动画帧率
  final double fps;

  /// 呼吸效果幅度
  final double breathAmplitude;

  /// 呼吸效果周期（秒）
  final double breathPeriod;

  /// 当前呼吸计时器
  double _breathTimer = 0;

  GeneralIdleAnimation({
    this.fps = 8,
    this.breathAmplitude = 2.0,
    this.breathPeriod = 2.0,
    super.position,
    super.size,
    super.anchor,
  });

  @override
  Future<void> onLoad() async {
    // TODO: 加载待机动画精灵表
  }

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 更新呼吸效果动画
    _breathTimer += dt;
  }

  /// 播放待机动画
  void play() {
    // TODO: 开始播放待机动画
    throw UnimplementedError();
  }

  /// 停止待机动画
  void stop() {
    // TODO: 停止待机动画
    throw UnimplementedError();
  }
}
