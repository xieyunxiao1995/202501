import '../../shared/enums/battle_status.dart';
import '../../shared/enums/formation_type.dart';
import '../../shared/enums/kingdom.dart';

/// 战斗数据持有类
///
/// 集中持有战斗过程中的所有数据状态，供各系统读取和修改。
/// 包含双方阵容、战斗状态、回合信息等核心数据。
class BattleData {
  /// 战斗唯一标识
  final String battleId;

  /// 己方武将ID列表
  final List<String> allyGeneralIds;

  /// 敌方武将ID列表
  final List<String> enemyGeneralIds;

  /// 己方阵法类型
  FormationType allyFormation;

  /// 敌方阵法类型
  FormationType enemyFormation;

  /// 当前战斗状态
  BattleStatus status;

  /// 当前回合数
  int currentTurn;

  /// 最大回合数（超时判负）
  final int maxTurns;

  /// 己方阵营
  final Kingdom allyKingdom;

  /// 敌方阵营
  final Kingdom enemyKingdom;

  /// 战斗场景背景标识
  final String backgroundKey;

  /// 是否为 PVP 战斗
  final bool isPvp;

  /// 战斗事件日志
  final List<Map<String, dynamic>> eventLog = [];

  BattleData({
    required this.battleId,
    required this.allyGeneralIds,
    required this.enemyGeneralIds,
    this.allyFormation = FormationType.longSnake,
    this.enemyFormation = FormationType.longSnake,
    this.status = BattleStatus.idle,
    this.currentTurn = 0,
    this.maxTurns = 30,
    this.allyKingdom = Kingdom.wei,
    this.enemyKingdom = Kingdom.shu,
    this.backgroundKey = 'default',
    this.isPvp = false,
  });

  /// 添加战斗事件到日志
  void addEvent(Map<String, dynamic> event) {
    eventLog.add(event);
  }

  /// 获取指定回合的事件列表
  List<Map<String, dynamic>> getEventsForTurn(int turn) {
    return eventLog.where((e) => e['turn'] == turn).toList();
  }

  /// 重置战斗数据（重新开始战斗时使用）
  void reset() {
    status = BattleStatus.idle;
    currentTurn = 0;
    eventLog.clear();
  }
}
