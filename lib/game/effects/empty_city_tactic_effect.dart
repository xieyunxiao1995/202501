import 'tactic_effect.dart';

/// 空城计特效
///
/// 空城计谋的视觉特效，包含城门虚掩、虚影晃动、气势压迫等效果。
/// 空城计可降低敌方士气，使敌方攻击力下降。
class EmptyCityTacticEffect extends TacticEffect {
  /// 虚影透明度
  final double phantomOpacity;

  /// 气势波纹扩散速度
  final double auraSpreadSpeed;

  /// 虚影数量
  final int phantomCount;

  EmptyCityTacticEffect({
    this.phantomOpacity = 0.5,
    this.auraSpreadSpeed = 80.0,
    this.phantomCount = 3,
    super.duration = 2.5,
    super.onComplete,
  });

  @override
  void onLoad() {
    // TODO: 创建虚影和气势波纹效果
  }

  @override
  void onUpdate(double dt) {
    // TODO: 更新虚影晃动和气势波纹动画
  }

  @override
  void play() {
    // TODO: 播放空城计特效
    throw UnimplementedError();
  }

  @override
  void stop() {
    // TODO: 停止空城计特效
    throw UnimplementedError();
  }
}
