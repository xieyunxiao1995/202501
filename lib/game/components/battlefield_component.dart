import 'package:flame/components.dart';

import '../../shared/enums/formation_type.dart';
import 'formation_grid_component.dart';

/// 战场组件
///
/// 管理战场背景、网格和阵法标识。
/// 包含双方阵营的阵法网格，作为战场最底层的视觉组件。
class BattlefieldComponent extends PositionComponent {
  /// 己方阵法网格
  late final FormationGridComponent allyGrid;

  /// 敌方阵法网格
  late final FormationGridComponent enemyGrid;

  /// 己方阵法类型
  FormationType allyFormation;

  /// 敌方阵法类型
  FormationType enemyFormation;

  /// 战场背景资源名称
  String backgroundKey;

  BattlefieldComponent({
    required this.allyFormation,
    required this.enemyFormation,
    this.backgroundKey = 'battlefield_default',
    super.position,
    super.size,
    super.anchor,
  });

  @override
  Future<void> onLoad() async {
    // TODO: 加载战场背景精灵
    // TODO: 创建己方和敌方阵法网格
    // TODO: 添加阵法标识装饰
  }

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 更新战场动画效果
  }

  /// 切换战场背景
  void changeBackground(String key) {
    // TODO: 切换战场背景资源
    throw UnimplementedError();
  }

  /// 更新阵法类型
  void updateFormation(bool isAlly, FormationType formationType) {
    // TODO: 更新指定阵营的阵法类型并刷新网格
    throw UnimplementedError();
  }
}
