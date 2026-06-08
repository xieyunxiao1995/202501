import 'package:flame/components.dart';

import '../components/general_component.dart';

/// 怒气系统
///
/// 管理武将怒气值的获取、消耗和满怒触发。
/// 武将在受击、攻击、击杀等行为中获得怒气，怒气满后可释放大招。
class RageSystem extends Component with HasGameReference {
  /// 怒气变化回调
  void Function(String generalId, double oldRage, double newRage)? onRageChanged;

  /// 满怒回调
  void Function(String generalId)? onRageFull;

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 更新怒气系统状态
  }

  /// 增加怒气
  ///
  /// [general] 武将组件
  /// [amount] 怒气增量
  /// [source] 怒气来源（攻击/受击/击杀/被动等）
  void addRage(GeneralComponent general, double amount, {String source = 'unknown'}) {
    // TODO: 增加武将怒气值，满怒时触发回调
    throw UnimplementedError();
  }

  /// 消耗怒气（释放大招）
  void consumeRage(GeneralComponent general) {
    // TODO: 清空武将怒气值
    throw UnimplementedError();
  }

  /// 计算攻击获得怒气
  double calculateAttackRage(GeneralComponent attacker, GeneralComponent target) {
    // TODO: 计算攻击行为获得的怒气值
    throw UnimplementedError();
  }

  /// 计算受击获得怒气
  double calculateHurtRage(GeneralComponent target, double damageReceived) {
    // TODO: 计算受击行为获得的怒气值
    throw UnimplementedError();
  }

  /// 计算击杀获得怒气
  double calculateKillRage(GeneralComponent killer) {
    // TODO: 计算击杀获得的额外怒气值
    throw UnimplementedError();
  }
}
