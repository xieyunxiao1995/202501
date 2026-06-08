import 'package:flame/components.dart';

/// 屏幕震动特效
///
/// 通过移动相机实现屏幕震动效果，用于表现重击、爆炸等高冲击力事件。
/// 支持不同强度和衰减模式的震动。
class ScreenShakeEffect extends Component {
  /// 震动强度（像素偏移量）
  final double intensity;

  /// 震动持续时间（秒）
  final double duration;

  /// 震动频率
  final double frequency;

  /// 是否使用衰减（强度随时间递减）
  final bool decay;

  /// 当前已播放时间
  double elapsedTime = 0;

  /// 是否正在播放
  bool isPlaying = false;

  /// 是否已完成
  bool get isFinished => elapsedTime >= duration;

  /// 特效完成回调
  void Function()? onComplete;

  ScreenShakeEffect({
    this.intensity = 10.0,
    this.duration = 0.3,
    this.frequency = 30.0,
    this.decay = true,
    this.onComplete,
  });

  @override
  void update(double dt) {
    super.update(dt);
    if (!isPlaying) return;
    elapsedTime += dt;
    // TODO: 计算震动偏移并应用到相机
    if (isFinished) {
      isPlaying = false;
      onComplete?.call();
    }
  }

  /// 播放震动特效
  void play() {
    // TODO: 开始屏幕震动
    throw UnimplementedError();
  }

  /// 停止震动特效
  void stop() {
    // TODO: 停止震动并重置相机位置
    throw UnimplementedError();
  }

  /// 计算当前震动偏移量
  Vector2 getCurrentOffset() {
    // TODO: 根据时间和参数计算当前震动偏移
    throw UnimplementedError();
  }
}
