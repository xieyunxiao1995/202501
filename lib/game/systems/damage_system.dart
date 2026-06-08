import 'package:flame/components.dart';

import '../components/general_component.dart';

/// 伤害系统
///
/// 负责伤害计算、伤害类型判定和伤害表现。
/// 综合考虑攻击力、防御力、暴击、闪避、兵种克制等因素。
class DamageSystem extends Component with HasGameReference {
  /// 伤害计算回调
  void Function(String sourceId, String targetId, double damage)? onDamageCalculated;

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 更新伤害系统状态
  }

  /// 计算伤害
  ///
  /// 综合考虑攻防、暴击、克制等因素计算最终伤害值。
  /// 返回包含伤害详情的 Map。
  Map<String, dynamic> calculateDamage(
    GeneralComponent attacker,
    GeneralComponent defender, {
    double skillMultiplier = 1.0,
    bool isSkillAttack = false,
  }) {
    // TODO: 计算基础伤害 → 暴击判定 → 闪避判定 → 克制加成 → 最终伤害
    throw UnimplementedError();
  }

  /// 应用伤害
  ///
  /// 将计算好的伤害应用到目标武将身上。
  void applyDamage(GeneralComponent target, double damage) {
    // TODO: 扣减目标生命值，触发受击动画和飘字
    throw UnimplementedError();
  }

  /// 判定暴击
  bool rollCritical(double criticalRate) {
    // TODO: 根据暴击率判定是否暴击
    throw UnimplementedError();
  }

  /// 判定闪避
  bool rollDodge(double dodgeRate) {
    // TODO: 根据闪避率判定是否闪避
    throw UnimplementedError();
  }

  /// 计算兵种克制加成
  double getTroopCounterBonus(GeneralComponent attacker, GeneralComponent defender) {
    // TODO: 根据兵种相克关系计算伤害加成
    throw UnimplementedError();
  }
}
