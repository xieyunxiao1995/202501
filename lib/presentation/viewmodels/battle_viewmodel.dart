import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../states/battle_state.dart';

/// 战斗 ViewModel Provider
final battleViewModelProvider =
    NotifierProvider<BattleViewModel, BattleState>(
  BattleViewModel.new,
);

/// 战斗 ViewModel
///
/// 管理战斗流程，包括战斗准备、回合推进、技能释放和战斗结算。
class BattleViewModel extends Notifier<BattleState> {
  @override
  BattleState build() => const BattleState.idle();

  /// 开始战斗
  void startBattle({
    required String battleType,
    required List<String> ownGeneralIds,
    required List<String> enemyGeneralIds,
  }) {
    // TODO: 实现开始战斗逻辑
  }

  /// 推进到下一回合
  void nextRound() {
    // TODO: 实现回合推进逻辑
  }

  /// 释放技能
  void useSkill(String generalId, String skillId) {
    // TODO: 实现技能释放逻辑
  }

  /// 暂停战斗
  void pauseBattle() {
    // TODO: 实现暂停逻辑
  }

  /// 恢复战斗
  void resumeBattle() {
    // TODO: 实现恢复逻辑
  }

  /// 加速战斗
  void speedUp() {
    // TODO: 实现加速逻辑
  }

  /// 结束战斗
  void endBattle() {
    // TODO: 实现结束战斗逻辑
  }
}
