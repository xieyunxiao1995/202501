import 'package:flame/components.dart';

/// 镜头控制器
///
/// 管理战斗场景的相机移动、缩放和聚焦。
/// 在关键战斗事件时自动聚焦到目标武将或区域。
class CameraController extends Component with HasGameReference {
  /// 当前聚焦位置
  Vector2 focusPosition = Vector2.zero();

  /// 目标缩放值
  double targetZoom = 1.0;

  /// 移动速度
  double moveSpeed = 200.0;

  /// 缩放速度
  double zoomSpeed = 1.0;

  /// 是否正在移动
  bool isMoving = false;

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 平滑移动相机到目标位置
  }

  /// 聚焦到指定位置
  void focusOn(Vector2 position, {double? zoom}) {
    // TODO: 平滑移动相机到指定位置
    throw UnimplementedError();
  }

  /// 聚焦到武将
  void focusOnGeneral(String generalId) {
    // TODO: 查找武将组件并聚焦
    throw UnimplementedError();
  }

  /// 缩放
  void setZoom(double zoom) {
    // TODO: 平滑缩放到指定倍率
    throw UnimplementedError();
  }

  /// 震动效果
  void shake({double intensity = 5.0, double duration = 0.3}) {
    // TODO: 触发相机震动效果
    throw UnimplementedError();
  }

  /// 重置到默认位置
  void reset() {
    // TODO: 重置相机到初始位置和缩放
    throw UnimplementedError();
  }
}
