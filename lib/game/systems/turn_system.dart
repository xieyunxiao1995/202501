import 'package:flame/components.dart';

import '../components/general_component.dart';

/// 回合系统
///
/// 根据武将速度属性决定行动顺序，管理回合流程。
/// 每回合按照速度从高到低依次行动，速度相同时随机决定。
/// 负责回合开始/结束的触发和状态管理。
class TurnSystem extends Component with HasGameReference {
  /// 当前回合数
  int currentTurn = 0;

  /// 行动顺序队列
  List<GeneralComponent> actionQueue = [];

  /// 当前行动的武将
  GeneralComponent? currentActor;

  /// 回合开始回调
  void Function(int turn)? onTurnStart;

  /// 回合结束回调
  void Function(int turn)? onTurnEnd;

  /// 武将行动回调
  void Function(GeneralComponent general)? onGeneralAction;

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 处理回合流程
  }

  /// 计算行动顺序
  ///
  /// 根据所有存活武将的速度属性排序生成行动队列。
  /// 速度相同时随机决定先后顺序。
  void calculateActionOrder(List<GeneralComponent> generals) {
    // TODO: 根据速度排序生成行动队列
    throw UnimplementedError();
  }

  /// 开始新回合
  void startNewTurn() {
    // TODO: 开始新回合，触发回合开始事件
    throw UnimplementedError();
  }

  /// 结束当前回合
  void endCurrentTurn() {
    // TODO: 结束当前回合，触发回合结束事件
    throw UnimplementedError();
  }

  /// 推进到下一个行动武将
  void advanceToNext() {
    // TODO: 将行动权交给队列中的下一个武将
    throw UnimplementedError();
  }

  /// 获取行动预览顺序
  List<GeneralComponent> getActionPreview(int count) {
    // TODO: 返回接下来 count 个行动武将的预览列表
    throw UnimplementedError();
  }
}
