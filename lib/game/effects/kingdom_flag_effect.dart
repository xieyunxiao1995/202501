import 'package:flame/components.dart';

import '../../shared/enums/kingdom.dart';

/// 国家旗帜飘扬特效
///
/// 战斗开始或关键事件时显示国家旗帜飘扬的视觉效果。
/// 旗帜带有飘动物理模拟，颜色对应魏蜀吴群晋阵营。
class KingdomFlagEffect extends PositionComponent {
  /// 阵营类型
  final Kingdom kingdom;

  /// 旗帜宽度
  final double flagWidth;

  /// 旗帜高度
  final double flagHeight;

  /// 飘动强度
  final double waveIntensity;

  /// 飘动频率
  final double waveFrequency;

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

  KingdomFlagEffect({
    required this.kingdom,
    this.flagWidth = 80.0,
    this.flagHeight = 120.0,
    this.waveIntensity = 10.0,
    this.waveFrequency = 2.0,
    this.duration = 0,
    this.onComplete,
    super.position,
    super.anchor,
  }) : super(size: Vector2(flagWidth, flagHeight));

  @override
  Future<void> onLoad() async {
    // TODO: 加载旗帜精灵，创建飘动网格
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!isPlaying) return;
    elapsedTime += dt;
    // TODO: 更新旗帜飘动物理模拟
    if (isFinished) {
      isPlaying = false;
      onComplete?.call();
    }
  }

  /// 播放旗帜特效
  void play() {
    // TODO: 开始播放旗帜飘扬特效
    throw UnimplementedError();
  }

  /// 停止旗帜特效
  void stop() {
    // TODO: 停止旗帜特效
    throw UnimplementedError();
  }
}
