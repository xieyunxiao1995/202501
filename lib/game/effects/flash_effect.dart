import 'package:flame/components.dart';

/// 闪屏效果
///
/// 全屏闪光效果，用于暴击、大招等高光时刻的视觉强化。
/// 支持不同颜色的闪光和渐变过渡。
class FlashEffect extends Component {
  /// 闪光颜色（ARGB 整数值）
  final int color;

  /// 闪光最大透明度 (0.0 - 1.0)
  final double maxOpacity;

  /// 闪屏持续时间（秒）
  final double duration;

  /// 闪光模式
  final FlashMode mode;

  /// 当前已播放时间
  double elapsedTime = 0;

  /// 是否正在播放
  bool isPlaying = false;

  /// 是否已完成
  bool get isFinished => elapsedTime >= duration;

  /// 特效完成回调
  void Function()? onComplete;

  FlashEffect({
    this.color = 0xFFFFFFFF,
    this.maxOpacity = 0.8,
    this.duration = 0.2,
    this.mode = FlashMode.flashIn,
    this.onComplete,
  });

  @override
  void update(double dt) {
    super.update(dt);
    if (!isPlaying) return;
    elapsedTime += dt;
    // TODO: 根据模式更新透明度
    if (isFinished) {
      isPlaying = false;
      onComplete?.call();
    }
  }

  /// 播放闪屏效果
  void play() {
    // TODO: 开始播放闪屏效果
    throw UnimplementedError();
  }

  /// 停止闪屏效果
  void stop() {
    // TODO: 停止闪屏并恢复画面
    throw UnimplementedError();
  }
}

/// 闪光模式
enum FlashMode {
  /// 闪入（透明到不透明再到透明）
  flashIn,

  /// 渐入（透明到不透明）
  fadeIn,

  /// 渐出（不透明到透明）
  fadeOut,

  /// 持续闪烁
  blink,
}
