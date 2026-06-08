import 'tactic_effect.dart';

/// 火攻特效
///
/// 火攻计谋的视觉特效，包含火焰蔓延、燃烧、烟雾上升等效果。
/// 影响范围内的所有敌方目标，并附加灼烧 Buff。
class FireTacticEffect extends TacticEffect {
  /// 火焰蔓延速度
  final double spreadSpeed;

  /// 火焰粒子数量
  final int particleCount;

  /// 烟雾浓度
  final double smokeDensity;

  FireTacticEffect({
    this.spreadSpeed = 100.0,
    this.particleCount = 50,
    this.smokeDensity = 0.7,
    super.duration = 2.0,
    super.onComplete,
  });

  @override
  void onLoad() {
    // TODO: 创建火焰粒子系统和烟雾效果
  }

  @override
  void onUpdate(double dt) {
    // TODO: 更新火焰蔓延和粒子动画
  }

  @override
  void play() {
    // TODO: 播放火攻特效
    throw UnimplementedError();
  }

  @override
  void stop() {
    // TODO: 停止火攻特效
    throw UnimplementedError();
  }
}
