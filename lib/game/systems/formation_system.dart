import 'package:flame/components.dart';

import '../../shared/enums/formation_type.dart';

/// 阵法系统
///
/// 管理阵法类型的属性加成、阵法克制关系和阵法切换。
/// 不同阵法对不同位置的武将提供不同的属性加成。
class FormationSystem extends Component with HasGameReference {
  /// 己方当前阵法
  FormationType allyFormation;

  /// 敌方当前阵法
  FormationType enemyFormation;

  /// 阵法切换回调
  void Function(bool isAlly, FormationType newFormation)? onFormationChanged;

  FormationSystem({
    this.allyFormation = FormationType.longSnake,
    this.enemyFormation = FormationType.longSnake,
  });

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 更新阵法系统状态
  }

  /// 计算阵法属性加成
  ///
  /// 根据阵法类型和武将所在位置计算属性加成。
  Map<String, double> getFormationBonus(FormationType formation, int slotIndex) {
    // TODO: 根据阵法类型和槽位索引返回属性加成
    throw UnimplementedError();
  }

  /// 切换阵法
  void changeFormation(bool isAlly, FormationType newFormation) {
    // TODO: 切换阵营的阵法类型并刷新加成
    throw UnimplementedError();
  }

  /// 计算阵法克制加成
  double getCounterBonus(FormationType attackerFormation, FormationType defenderFormation) {
    // TODO: 根据阵法克制关系计算加成
    throw UnimplementedError();
  }

  /// 获取阵法区域信息
  ///
  /// 返回指定阵法的前/中/后军区域配置。
  Map<String, dynamic> getFormationRegions(FormationType formation) {
    // TODO: 返回阵法区域布局信息
    throw UnimplementedError();
  }
}
