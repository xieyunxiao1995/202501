import 'package:flame/components.dart';

/// 倍速控制器
///
/// 管理战斗的播放速度，支持 1x、1.5x、2x、3x 等倍速。
/// 通过调整 dt 乘数影响所有系统的更新速度。
class SpeedController extends Component with HasGameReference {
  /// 可用倍速列表
  static const List<double> availableSpeeds = [1.0, 1.5, 2.0, 3.0];

  /// 当前倍速索引
  int _currentSpeedIndex = 0;

  /// 当前倍速
  double get currentSpeed => availableSpeeds[_currentSpeedIndex];

  /// 倍速变化回调
  void Function(double speed)? onSpeedChanged;

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 将 dt 乘以当前倍速后传递给各系统
  }

  /// 切换到下一倍速
  void cycleSpeed() {
    _currentSpeedIndex = (_currentSpeedIndex + 1) % availableSpeeds.length;
    onSpeedChanged?.call(currentSpeed);
  }

  /// 设置指定倍速
  void setSpeed(double speed) {
    final index = availableSpeeds.indexOf(speed);
    if (index >= 0) {
      _currentSpeedIndex = index;
      onSpeedChanged?.call(currentSpeed);
    }
  }

  /// 获取缩放后的 dt
  double getScaledDt(double rawDt) {
    // TODO: 返回乘以倍速后的 dt
    throw UnimplementedError();
  }
}
