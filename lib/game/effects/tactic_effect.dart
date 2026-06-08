import 'package:flame/components.dart';

/// 计谋特效基类
///
/// 所有计谋特效的基类，定义计谋特效的通用生命周期和接口。
/// 计谋特效通常比普通技能特效更加宏大，影响范围更广。
class TacticEffect extends Component {
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

  TacticEffect({
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
    // TODO: 初始化计谋特效状态并开始播放
    throw UnimplementedError();
  }

  /// 每帧更新逻辑（子类覆写）
  void onUpdate(double dt) {
    // TODO: 子类实现具体的计谋特效更新逻辑
  }

  /// 停止特效
  void stop() {
    // TODO: 停止计谋特效播放并清理
    throw UnimplementedError();
  }
}
