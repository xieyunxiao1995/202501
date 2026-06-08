import 'package:flame/components.dart';

/// 慢动作效果
///
/// 降低游戏时间流速，用于关键技能命中、暴击等高光时刻。
/// 通过调整 dt 乘数实现慢动作，可配置缓入缓出。
class SlowMotionEffect extends Component {
  /// 目标时间缩放 (0.0 - 1.0，值越小越慢)
  final double targetTimeScale;

  /// 慢动作持续时间（秒，以真实时间计算）
  final double duration;

  /// 缓入时长（秒）
  final double easeInDuration;

  /// 缓出时长（秒）
  final double easeOutDuration;

  /// 当前已播放时间
  double elapsedTime = 0;

  /// 是否正在播放
  bool isPlaying = false;

  /// 是否已完成
  bool get isFinished => elapsedTime >= duration;

  /// 当前时间缩放值
  double currentTimeScale = 1.0;

  /// 特效完成回调
  void Function()? onComplete;

  SlowMotionEffect({
    this.targetTimeScale = 0.3,
    this.duration = 0.5,
    this.easeInDuration = 0.1,
    this.easeOutDuration = 0.2,
    this.onComplete,
  });

  @override
  void update(double dt) {
    super.update(dt);
    if (!isPlaying) return;
    elapsedTime += dt;
    // TODO: 根据缓入缓出计算当前时间缩放值
    if (isFinished) {
      currentTimeScale = 1.0;
      isPlaying = false;
      onComplete?.call();
    }
  }

  /// 播放慢动作效果
  void play() {
    // TODO: 开始慢动作效果
    throw UnimplementedError();
  }

  /// 停止慢动作效果
  void stop() {
    // TODO: 恢复正常时间流速
    throw UnimplementedError();
  }
}
