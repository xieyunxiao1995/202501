import 'package:flame/components.dart';

import '../../shared/enums/formation_type.dart';
import 'lineup_slot_component.dart';

/// 阵法网格组件
///
/// 管理阵法的前军、中军、后军三个区域，
/// 每个区域包含两个站位槽位，共计六个位置。
/// 阵法类型决定了各区域的属性加成。
class FormationGridComponent extends PositionComponent {
  /// 阵法类型
  FormationType formationType;

  /// 前军站位槽位列表
  final List<LineupSlotComponent> frontSlots = [];

  /// 中军站位槽位列表
  final List<LineupSlotComponent> midSlots = [];

  /// 后军站位槽位列表
  final List<LineupSlotComponent> backSlots = [];

  /// 是否为己方阵营
  final bool isAlly;

  FormationGridComponent({
    required this.formationType,
    required this.isAlly,
    super.position,
    super.size,
    super.anchor,
  });

  @override
  Future<void> onLoad() async {
    // TODO: 根据阵法类型创建前/中/后军槽位
    // TODO: 设置各区域的布局位置
  }

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 更新阵法网格动画
  }

  /// 切换阵法类型
  void changeFormation(FormationType newFormation) {
    // TODO: 切换阵法并重新布局槽位
    throw UnimplementedError();
  }

  /// 获取指定位置的槽位
  LineupSlotComponent? getSlot(int index) {
    // TODO: 根据 index (0-5) 返回对应槽位
    throw UnimplementedError();
  }

  /// 获取阵法属性加成
  Map<String, double> getFormationBonus() {
    // TODO: 根据阵法类型计算属性加成
    throw UnimplementedError();
  }
}
