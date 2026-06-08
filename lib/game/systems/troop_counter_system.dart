import 'package:flame/components.dart';

import '../../shared/enums/troop_type.dart';
import '../components/general_component.dart';

/// 兵种相克系统
///
/// 管理兵种之间的克制关系和克制加成计算。
/// 骑兵>步兵>枪兵>骑兵，弓兵>谋士>盾兵>弓兵。
class TroopCounterSystem extends Component with HasGameReference {
  /// 克制伤害加成比例
  final double counterDamageBonus;

  /// 被克制伤害减免比例
  final double counterDamageReduction;

  TroopCounterSystem({
    this.counterDamageBonus = 0.3,
    this.counterDamageReduction = -0.2,
  });

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 更新兵种相克系统状态
  }

  /// 判断是否克制
  bool isCountering(TroopType attacker, TroopType defender) {
    // TODO: 判断攻击方兵种是否克制防守方兵种
    throw UnimplementedError();
  }

  /// 计算克制加成
  double calculateCounterMultiplier(TroopType attacker, TroopType defender) {
    // TODO: 根据克制关系返回伤害倍率
    throw UnimplementedError();
  }

  /// 获取克制提示文本
  String getCounterDescription(TroopType attacker, TroopType defender) {
    // TODO: 返回克制关系的描述文本
    throw UnimplementedError();
  }

  /// 批量计算阵容克制评分
  double evaluateLineupCounter(
    List<GeneralComponent> allyTeam,
    List<GeneralComponent> enemyTeam,
  ) {
    // TODO: 综合评估两阵容间的克制关系评分
    throw UnimplementedError();
  }
}
