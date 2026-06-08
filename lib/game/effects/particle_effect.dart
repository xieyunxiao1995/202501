import 'package:flame/components.dart';

/// 粒子特效
///
/// 通用粒子特效组件，支持火焰、烟雾、闪电等粒子效果类型。
/// 通过配置粒子参数来创建不同的视觉效果。
class ParticleEffect extends Component {
  /// 粒子类型
  final ParticleType particleType;

  /// 粒子数量
  final int count;

  /// 特效持续时间（秒）
  final double duration;

  /// 粒子发射速率
  final double emitRate;

  /// 粒子生命周期范围（秒）
  final Vector2 lifespanRange;

  /// 粒子速度范围
  final Vector2 speedRange;

  /// 粒子大小范围
  final Vector2 sizeRange;

  /// 当前已播放时间
  double elapsedTime = 0;

  /// 是否正在播放
  bool isPlaying = false;

  /// 是否已完成
  bool get isFinished => elapsedTime >= duration;

  /// 特效完成回调
  void Function()? onComplete;

  ParticleEffect({
    required this.particleType,
    required this.lifespanRange,
    required this.speedRange,
    required this.sizeRange,
    this.count = 30,
    this.duration = 1.0,
    this.emitRate = 30.0,
    this.onComplete,
  });

  @override
  void update(double dt) {
    super.update(dt);
    if (!isPlaying) return;
    elapsedTime += dt;
    // TODO: 更新粒子生命周期和位置
  }

  /// 播放粒子特效
  void play() {
    // TODO: 初始化粒子发射器并开始播放
    throw UnimplementedError();
  }

  /// 停止粒子特效
  void stop() {
    // TODO: 停止粒子发射
    throw UnimplementedError();
  }
}

/// 粒子类型枚举
enum ParticleType {
  /// 火焰粒子
  fire,

  /// 烟雾粒子
  smoke,

  /// 闪电粒子
  lightning,

  /// 冰霜粒子
  frost,

  /// 治疗粒子
  heal,

  /// 通用粒子
  generic,
}
