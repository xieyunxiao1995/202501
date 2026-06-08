import 'package:flame/components.dart';

import '../../shared/enums/buff_type.dart';

/// Buff/Debuff 图标组件
///
/// 显示武将身上增益或减益效果的小图标。
/// 包含剩余回合数、叠加层数等信息，可点击查看详细说明。
class BuffIconComponent extends PositionComponent {
  /// Buff 类型
  final BuffType buffType;

  /// 剩余回合数
  int remainingTurns;

  /// 叠加层数
  int stacks;

  /// 效果数值
  double value;

  /// 是否为减益效果
  bool get isDebuff => buffType.isDebuff;

  /// 图标资源键
  final String iconKey;

  BuffIconComponent({
    required this.buffType,
    this.remainingTurns = 1,
    this.stacks = 1,
    this.value = 0,
    required this.iconKey,
    super.position,
    super.size,
    super.anchor,
  });

  @override
  Future<void> onLoad() async {
    // TODO: 加载 Buff 图标精灵
    // TODO: 创建层数文本和回合数文本
  }

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 更新 Buff 图标动画（快到期时闪烁）
  }

  /// 减少回合数
  void decrementTurn() {
    // TODO: 减少剩余回合数
    throw UnimplementedError();
  }

  /// 增加叠加层数
  void addStack(int count) {
    // TODO: 增加叠加层数
    throw UnimplementedError();
  }

  /// 刷新效果数值
  void refreshValue(double newValue) {
    // TODO: 更新效果数值
    throw UnimplementedError();
  }
}
