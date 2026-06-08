import 'package:flame/components.dart';

import '../../shared/enums/buff_type.dart';
import '../components/general_component.dart';

/// Buff 系统
///
/// 管理增益和减益效果的添加、移除、叠加和回合更新。
/// Buff 可影响攻击、防御、速度等属性，Debuff 包括灼烧、冰冻、眩晕等。
class BuffSystem extends Component with HasGameReference {
  /// Buff 添加回调
  void Function(String generalId, BuffType buffType, int stacks)? onBuffAdded;

  /// Buff 移除回调
  void Function(String generalId, BuffType buffType)? onBuffRemoved;

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 更新 Buff 系统状态
  }

  /// 添加 Buff
  void addBuff(
    GeneralComponent target,
    BuffType buffType, {
    int duration = 1,
    int stacks = 1,
    double value = 0,
  }) {
    // TODO: 添加 Buff 到目标武将，处理叠加逻辑
    throw UnimplementedError();
  }

  /// 移除 Buff
  void removeBuff(GeneralComponent target, BuffType buffType) {
    // TODO: 从目标武将移除指定 Buff
    throw UnimplementedError();
  }

  /// 移除所有 Buff
  void removeAllBuffs(GeneralComponent target) {
    // TODO: 移除目标武将身上的所有 Buff
    throw UnimplementedError();
  }

  /// 回合更新 Buff
  ///
  /// 每回合结束时减少 Buff 回合数，到期移除。
  void processTurnEnd(GeneralComponent general) {
    // TODO: 处理 Buff 回合递减和到期移除
    throw UnimplementedError();
  }

  /// 处理 Buff 持续效果
  ///
  /// 处理灼烧、中毒等每回合触发的持续伤害/治疗效果。
  void processContinuousEffect(GeneralComponent general) {
    // TODO: 处理持续伤害和治疗 Buff
    throw UnimplementedError();
  }

  /// 计算属性修正值
  ///
  /// 根据武将身上的所有 Buff 计算属性修正总值。
  Map<String, double> calculateModifiers(GeneralComponent general) {
    // TODO: 汇总所有 Buff 的属性修正值
    throw UnimplementedError();
  }
}
