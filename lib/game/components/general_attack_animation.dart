import 'package:flame/components.dart';

/// 武将攻击动画组件
///
/// 管理武将普通攻击的动画表现，包括向前突进、攻击挥砍、回位。
/// 攻击动画完成后自动切换回待机动画。
class GeneralAttackAnimation extends PositionComponent {
  /// 动画帧率
  final double fps;

  /// 突进距离
  final double dashDistance;

  /// 突进速度
  final double dashSpeed;

  /// 动画总时长（秒）
  final double duration;

  /// 动画完成回调
  void Function()? onComplete;

  GeneralAttackAnimation({
    this.fps = 12,
    this.dashDistance = 50.0,
    this.dashSpeed = 300.0,
    this.duration = 0.5,
    this.onComplete,
    super.position,
    super.size,
    super.anchor,
  });

  @override
  Future<void> onLoad() async {
    // TODO: 加载攻击动画精灵表
  }

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 更新攻击动画状态（突进、挥砍、回位）
  }

  /// 播放攻击动画
  void play() {
    // TODO: 播放攻击动画序列
    throw UnimplementedError();
  }

  /// 停止攻击动画
  void stop() {
    // TODO: 停止攻击动画
    throw UnimplementedError();
  }
}
