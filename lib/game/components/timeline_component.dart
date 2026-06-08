import 'package:flame/components.dart';

import 'general_component.dart';

/// 行动时间轴组件
///
/// 显示所有武将的行动顺序时间轴，根据速度属性排列。
/// 当前行动武将高亮显示，玩家可预览后续行动顺序。
class TimelineComponent extends PositionComponent {
  /// 时间轴上的武将列表（按行动顺序排列）
  List<GeneralComponent> actionOrder = [];

  /// 当前行动武将索引
  int currentActionIndex = 0;

  /// 预览显示的行动数量
  final int previewCount;

  /// 单个头像尺寸
  final double avatarSize;

  TimelineComponent({
    this.previewCount = 8,
    this.avatarSize = 36.0,
    super.position,
    super.size,
    super.anchor,
  });

  @override
  Future<void> onLoad() async {
    // TODO: 创建时间轴背景和头像容器
  }

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 更新时间轴动画（滚动、高亮）
  }

  /// 更新行动顺序
  void updateActionOrder(List<GeneralComponent> order) {
    // TODO: 根据新的行动顺序刷新时间轴显示
    throw UnimplementedError();
  }

  /// 推进到下一个行动
  void advanceToNext() {
    // TODO: 推进当前行动索引并刷新显示
    throw UnimplementedError();
  }

  /// 获取当前行动武将
  GeneralComponent? get currentGeneral {
    // TODO: 返回当前行动的武将
    throw UnimplementedError();
  }
}
