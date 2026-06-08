import 'package:flame/components.dart';

/// 武将立绘切入特效
///
/// 大招释放时武将立绘从屏幕侧面切入的视觉特效。
/// 包含立绘滑入、背景暗化、特效叠加等效果。
class CutInEffect extends PositionComponent {
  /// 武将立绘资源键
  final String portraitKey;

  /// 切入方向
  final CutInDirection direction;

  /// 切入动画时长（秒）
  final double enterDuration;

  /// 停留时长（秒）
  final double holdDuration;

  /// 退出动画时长（秒）
  final double exitDuration;

  /// 背景暗化程度 (0.0 - 1.0)
  final double backgroundDimming;

  /// 当前已播放时间
  double elapsedTime = 0;

  /// 是否正在播放
  bool isPlaying = false;

  /// 是否已完成
  bool get isFinished =>
      elapsedTime >= enterDuration + holdDuration + exitDuration;

  /// 特效完成回调
  void Function()? onComplete;

  CutInEffect({
    required this.portraitKey,
    this.direction = CutInDirection.fromLeft,
    this.enterDuration = 0.3,
    this.holdDuration = 0.8,
    this.exitDuration = 0.3,
    this.backgroundDimming = 0.6,
    this.onComplete,
    super.position,
    super.size,
    super.anchor,
  });

  @override
  Future<void> onLoad() async {
    // TODO: 加载武将立绘精灵和背景暗化层
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isPlaying) return;
    elapsedTime += dt;
    // TODO: 根据阶段（切入/停留/退出）更新立绘位置和透明度
    if (isFinished) {
      isPlaying = false;
      onComplete?.call();
    }
  }

  /// 播放切入特效
  void play() {
    // TODO: 开始播放立绘切入特效
    throw UnimplementedError();
  }

  /// 停止切入特效
  void stop() {
    // TODO: 停止切入特效并清理
    throw UnimplementedError();
  }
}

/// 切入方向
enum CutInDirection {
  /// 从左侧切入
  fromLeft,

  /// 从右侧切入
  fromRight,

  /// 从底部切入
  fromBottom,

  /// 缩放切入
  zoomIn,
}
