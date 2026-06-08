import 'package:flame/components.dart';

/// 输入控制器
///
/// 管理战斗场景的用户输入处理，包括点击、拖拽和手势操作。
/// 将输入事件转换为战斗操作指令并分发给对应系统。
class InputController extends Component with HasGameReference {
  /// 是否启用输入
  bool isEnabled = true;

  /// 点击回调
  void Function(Vector2 position)? onTap;

  /// 拖拽开始回调
  void Function(Vector2 position)? onDragStart;

  /// 拖拽更新回调
  void Function(Vector2 position)? onDragUpdate;

  /// 拖拽结束回调
  void Function(Vector2 position)? onDragEnd;

  @override
  Future<void> onLoad() async {
    // TODO: 注册输入事件监听
  }

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 处理输入队列
  }

  /// 处理点击事件
  void handleTap(Vector2 position) {
    // TODO: 将点击位置转换为游戏内坐标，判断点击对象
    throw UnimplementedError();
  }

  /// 处理拖拽事件
  void handleDrag(Vector2 startPosition, Vector2 currentPosition) {
    // TODO: 处理拖拽操作（如选择目标区域）
    throw UnimplementedError();
  }

  /// 启用输入
  void enable() {
    isEnabled = true;
  }

  /// 禁用输入
  void disable() {
    isEnabled = false;
  }
}
