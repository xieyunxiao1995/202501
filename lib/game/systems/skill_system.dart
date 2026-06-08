import 'package:flame/components.dart';

import '../components/general_component.dart';

/// 技能系统
///
/// 管理技能释放流程，包括技能条件判断、目标选择、效果执行。
/// 支持普攻、战法、大招和被动技能四种类型。
class SkillSystem extends Component with HasGameReference {
  /// 技能释放前回调
  void Function(String generalId, String skillId)? onSkillCast;

  /// 技能释放后回调
  void Function(String generalId, String skillId)? onSkillComplete;

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 更新技能系统状态
  }

  /// 释放技能
  ///
  /// [actor] 释放技能的武将
  /// [skillId] 技能标识
  /// [targetIds] 目标武将ID列表
  void castSkill(GeneralComponent actor, String skillId, List<String> targetIds) {
    // TODO: 检查技能条件、选择目标、执行效果
    throw UnimplementedError();
  }

  /// 选择技能目标
  ///
  /// 根据技能的目标选择规则，自动选择合法目标。
  List<GeneralComponent> selectTargets(
    GeneralComponent actor,
    String skillId,
    List<GeneralComponent> allGenerals,
  ) {
    // TODO: 根据技能目标类型选择合法目标
    throw UnimplementedError();
  }

  /// 检查技能是否可释放
  bool canCastSkill(GeneralComponent actor, String skillId) {
    // TODO: 检查冷却时间、怒气/资源是否足够等条件
    throw UnimplementedError();
  }

  /// 处理被动技能触发
  void processPassiveSkill(GeneralComponent owner, String triggerEvent) {
    // TODO: 根据触发事件检查并执行被动技能
    throw UnimplementedError();
  }
}
