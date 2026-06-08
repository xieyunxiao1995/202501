import 'package:flame/components.dart';

/// 技能特效基类
///
/// 所有技能特效的基类，定义特效的通用生命周期和接口。
/// 子类通过覆写 [onPlay] 和 [onUpdate] 实现具体的特效逻辑。
class SkillEffect extends Component {
  /// 特效持续时间（秒）
  final double duration;

  /// 当前已播放时间
  double elapsedTime = 0;

  /// 是否正在播放
  bool isPlaying = false;

  /// 是否已完成
  bool get isFinished => elapsedTime >= duration;

  /// 特效完成回调
  void Function()? onComplete;

  SkillEffect({
    required this.duration,
    this.onComplete,
  });

  @override
  void update(double dt) {
    super.update(dt);
    if (!isPlaying) return;
    elapsedTime += dt;
    onUpdate(dt);
    if (isFinished) {
      isPlaying = false;
      onComplete?.call();
    }
  }

  /// 播放特效
  void play() {
    // TODO: 初始化特效状态并开始播放
    throw UnimplementedError();
  }

  /// 每帧更新逻辑（子类覆写）
  void onUpdate(double dt) {
    // TODO: 子类实现具体的特效更新逻辑
  }

  /// 停止特效
  void stop() {
    // TODO: 停止特效播放并清理
    throw UnimplementedError();
  }
}
