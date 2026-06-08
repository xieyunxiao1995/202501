import 'package:flame/components.dart';

/// 风沙特效
///
/// 战场环境风沙粒子效果，用于增加战场氛围感。
/// 包含沙尘粒子飘动、方向性风场和浓度变化。
class WindEffect extends Component {
  /// 风向角度（弧度）
  final double windAngle;

  /// 风速
  final double windSpeed;

  /// 沙尘粒子数量
  final int dustCount;

  /// 沙尘浓度 (0.0 - 1.0)
  final double density;

  /// 特效持续时间（秒），0 表示持续播放
  final double duration;

  /// 当前已播放时间
  double elapsedTime = 0;

  /// 是否正在播放
  bool isPlaying = false;

  /// 是否已完成（duration > 0 时有效）
  bool get isFinished => duration > 0 && elapsedTime >= duration;

  /// 特效完成回调
  void Function()? onComplete;

  WindEffect({
    this.windAngle = 0.0,
    this.windSpeed = 100.0,
    this.dustCount = 40,
    this.density = 0.5,
    this.duration = 0,
    this.onComplete,
  });

  @override
  void update(double dt) {
    super.update(dt);
    if (!isPlaying) return;
    elapsedTime += dt;
    // TODO: 更新风沙粒子位置和透明度
    if (isFinished) {
      isPlaying = false;
      onComplete?.call();
    }
  }

  /// 播放风沙特效
  void play() {
    // TODO: 初始化风场和沙尘粒子并开始播放
    throw UnimplementedError();
  }

  /// 停止风沙特效
  void stop() {
    // TODO: 停止风沙特效并清理粒子
    throw UnimplementedError();
  }

  /// 更新风场参数
  void updateWind(double angle, double speed) {
    // TODO: 动态更新风向和风速
    throw UnimplementedError();
  }
}
