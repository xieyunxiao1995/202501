import 'package:flame/game.dart';

import 'controllers/battle_controller.dart';
import 'controllers/camera_controller.dart';
import 'controllers/input_controller.dart';

/// 战斗游戏主类
///
/// Flame Game 子类，管理战斗场景的所有组件、系统和控制器。
/// 通过 BattleController 与 Flutter 层的 BattleViewModel 通信。
class BattleGame extends FlameGame {
  /// 战斗主控制器
  late final BattleController battleController;

  /// 输入控制器
  late final InputController inputController;

  /// 镜头控制器
  late final CameraController cameraController;

  /// 当前战斗倍速
  double speedMultiplier = 1.0;

  /// 是否自动战斗
  bool isAutoBattle = false;

  /// 是否暂停
  bool isPaused = false;

  @override
  Future<void> onLoad() async {
    // TODO: 初始化战场组件、武将组件、UI 组件
    battleController = BattleController();
    inputController = InputController();
    cameraController = CameraController();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (isPaused) return;
    // TODO: 更新战斗系统
  }
}
