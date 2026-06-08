import 'package:flame/components.dart';

import '../../shared/enums/kingdom.dart';
import '../../shared/enums/troop_type.dart';
import 'general_attack_animation.dart';
import 'general_death_animation.dart';
import 'general_hurt_animation.dart';
import 'general_idle_animation.dart';
import 'general_skill_animation.dart';
import 'general_ultimate_animation.dart';
import 'hp_bar_component.dart';
import 'rage_bar_component.dart';

/// 武将组件
///
/// 代表战场上的一个武将实体，包含精灵、动画和状态信息。
/// 管理武将的各种动画状态（待机、攻击、技能、受击、阵亡等）。
class GeneralComponent extends PositionComponent {
  /// 武将唯一标识
  final String generalId;

  /// 武将名称
  final String name;

  /// 所属阵营
  final Kingdom kingdom;

  /// 兵种类型
  final TroopType troopType;

  /// 是否为己方武将
  final bool isAlly;

  /// 当前生命值
  double currentHp;

  /// 最大生命值
  final double maxHp;

  /// 当前怒气值 (0-100)
  double currentRage;

  /// 最大怒气值
  static const double maxRage = 100.0;

  /// 攻击力
  double attack;

  /// 防御力
  double defense;

  /// 速度
  double speed;

  /// 暴击率
  double criticalRate;

  /// 闪避率
  double dodgeRate;

  /// 待机动画
  late final GeneralIdleAnimation idleAnimation;

  /// 攻击动画
  late final GeneralAttackAnimation attackAnimation;

  /// 技能动画
  late final GeneralSkillAnimation skillAnimation;

  /// 大招动画
  late final GeneralUltimateAnimation ultimateAnimation;

  /// 受击动画
  late final GeneralHurtAnimation hurtAnimation;

  /// 阵亡动画
  late final GeneralDeathAnimation deathAnimation;

  /// 血条组件
  late final HpBarComponent hpBar;

  /// 怒气条组件
  late final RageBarComponent rageBar;

  /// 是否存活
  bool get isAlive => currentHp > 0;

  GeneralComponent({
    required this.generalId,
    required this.name,
    required this.kingdom,
    required this.troopType,
    required this.isAlly,
    required this.currentHp,
    required this.maxHp,
    this.currentRage = 0,
    this.attack = 0,
    this.defense = 0,
    this.speed = 0,
    this.criticalRate = 0,
    this.dodgeRate = 0,
    super.position,
    super.size,
    super.anchor,
  });

  @override
  Future<void> onLoad() async {
    // TODO: 加载武将精灵资源
    // TODO: 创建并添加各动画组件
    // TODO: 创建并添加血条、怒气条
  }

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 更新武将状态
  }

  /// 播放待机动画
  void playIdle() {
    // TODO: 切换到待机动画状态
    throw UnimplementedError();
  }

  /// 播放攻击动画
  void playAttack() {
    // TODO: 切换到攻击动画状态
    throw UnimplementedError();
  }

  /// 播放技能动画
  void playSkill() {
    // TODO: 切换到技能动画状态
    throw UnimplementedError();
  }

  /// 播放大招动画
  void playUltimate() {
    // TODO: 切换到大招动画状态
    throw UnimplementedError();
  }

  /// 播放受击动画
  void playHurt() {
    // TODO: 切换到受击动画状态
    throw UnimplementedError();
  }

  /// 播放阵亡动画
  void playDeath() {
    // TODO: 切换到阵亡动画状态
    throw UnimplementedError();
  }

  /// 受到伤害
  void takeDamage(double damage) {
    // TODO: 扣减生命值，更新血条，触发受击动画
    throw UnimplementedError();
  }

  /// 接受治疗
  void receiveHeal(double heal) {
    // TODO: 恢复生命值，更新血条
    throw UnimplementedError();
  }

  /// 增加怒气
  void addRage(double amount) {
    // TODO: 增加怒气值，更新怒气条
    throw UnimplementedError();
  }

  /// 移动到指定位置（攻击移动等）
  void moveTo(Vector2 target, {void Function()? onComplete}) {
    // TODO: 平滑移动到目标位置
    throw UnimplementedError();
  }
}
