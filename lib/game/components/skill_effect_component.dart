import 'package:flame/components.dart';

/// 技能特效组件
///
/// 管理技能释放时的视觉特效，包括粒子、光效、冲击波等。
/// 特效播放完毕后自动从组件树中移除。
class SkillEffectComponent extends PositionComponent {
  /// 技能标识
  final String skillId;

  /// 特效持续时间（秒）
  final double duration;

  /// 特效层级（决定渲染顺序）
  @override
  final int priority;

  /// 当前计时器
  double _timer = 0;

  /// 是否已完成
  bool get isFinished => _timer >= duration;

  SkillEffectComponent({
    required this.skillId,
    this.duration = 1.0,
    this.priority = 0,
    super.position,
    super.size,
    super.anchor,
  });

  @override
  Future<void> onLoad() async {
    // TODO: 加载技能特效资源
  }

  @override
  void update(double dt) {
    super.update(dt);
    _timer += dt;
    // TODO: 更新技能特效动画
  }

  /// 播放特效
  void play() {
    // TODO: 开始播放技能特效
    throw UnimplementedError();
  }

  /// 停止特效
  void stop() {
    // TODO: 停止技能特效并移除
    throw UnimplementedError();
  }
}
