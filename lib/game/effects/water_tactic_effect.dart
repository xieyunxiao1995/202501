import 'tactic_effect.dart';

/// 水攻特效
///
/// 水攻计谋的视觉特效，包含洪流冲击、水花飞溅、水波扩散等效果。
/// 影响范围内的所有敌方目标，并附加减速或冰冻 Buff。
class WaterTacticEffect extends TacticEffect {
  /// 洪流冲击速度
  final double waveSpeed;

  /// 水波扩散范围
  final double waveRadius;

  /// 水花粒子数量
  final int splashCount;

  WaterTacticEffect({
    this.waveSpeed = 200.0,
    this.waveRadius = 150.0,
    this.splashCount = 30,
    super.duration = 2.0,
    super.onComplete,
  });

  @override
  void onLoad() {
    // TODO: 创建水波扩散和水花飞溅效果
  }

  @override
  void onUpdate(double dt) {
    // TODO: 更新水波扩散和水花动画
  }

  @override
  void play() {
    // TODO: 播放水攻特效
    throw UnimplementedError();
  }

  @override
  void stop() {
    // TODO: 停止水攻特效
    throw UnimplementedError();
  }
}
