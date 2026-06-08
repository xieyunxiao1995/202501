import 'package:flame/components.dart';

import 'general_component.dart';

/// 站位槽组件
///
/// 代表战场上的一个站位位置，共6个槽位分为前/中/后军。
/// 每个槽位可以容纳一个武将组件。
class LineupSlotComponent extends PositionComponent {
  /// 槽位索引 (0-5)
  final int slotIndex;

  /// 槽位所属区域：前军(0-1)、中军(2-3)、后军(4-5)
  String get region => switch (slotIndex) {
        >= 0 && <= 1 => '前军',
        >= 2 && <= 3 => '中军',
        >= 4 && <= 5 => '后军',
        _ => '未知',
      };

  /// 当前槽位上的武将组件
  GeneralComponent? currentGeneral;

  /// 槽位是否被占据
  bool get isOccupied => currentGeneral != null;

  /// 槽位高亮状态
  bool isHighlighted = false;

  LineupSlotComponent({
    required this.slotIndex,
    super.position,
    super.size,
    super.anchor,
  });

  @override
  Future<void> onLoad() async {
    // TODO: 加载槽位背景精灵
    // TODO: 设置高亮效果的初始状态
  }

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 更新槽位高亮动画
  }

  /// 放置武将到槽位
  void placeGeneral(GeneralComponent general) {
    // TODO: 将武将组件放置到当前槽位
    throw UnimplementedError();
  }

  /// 移除槽位上的武将
  GeneralComponent? removeGeneral() {
    // TODO: 从槽位移除武将并返回
    throw UnimplementedError();
  }

  /// 设置槽位高亮
  void setHighlight(bool highlight) {
    // TODO: 设置高亮状态，用于目标选择等场景
    throw UnimplementedError();
  }
}
