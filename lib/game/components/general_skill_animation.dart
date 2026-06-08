import 'package:flame/components.dart';

/// 武将技能动画组件
///
/// 管理武将战法技能的动画表现，包含施法前摇、技能释放、效果展示。
/// 技能动画通常比普通攻击更加华丽，可能包含屏幕特效。
class GeneralSkillAnimation extends PositionComponent {
  /// 动画帧率
  final double fps;

  /// 前摇时长（秒）
  final double windUpDuration;

  /// 技能释放时长（秒）
  final double castDuration;

  /// 后摇时长（秒）
  final double windDownDuration;

  /// 动画完成回调
  void Function()? onComplete;

  GeneralSkillAnimation({
    this.fps = 12,
    this.windUpDuration = 0.3,
    this.castDuration = 0.6,
    this.windDownDuration = 0.2,
    this.onComplete,
    super.position,
    super.size,
    super.anchor,
  });

  @override
  Future<void> onLoad() async {
    // TODO: 加载技能动画精灵表
  }

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 更新技能动画状态
  }

  /// 播放技能动画
  void play(String skillId) {
    // TODO: 根据技能ID播放对应的技能动画
    throw UnimplementedError();
  }

  /// 停止技能动画
  void stop() {
    // TODO: 停止技能动画
    throw UnimplementedError();
  }
}
