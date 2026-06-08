import 'package:flame/components.dart';

/// 回合指示器组件
///
/// 显示当前回合数和行动方标识。
/// 包含回合数文本、行动方高亮、回合切换动画。
class TurnIndicatorComponent extends PositionComponent {
  /// 当前回合数
  int currentTurn;

  /// 当前行动方是否为己方
  bool isAllyTurn;

  /// 回合切换动画时长（秒）
  final double switchDuration;

  TurnIndicatorComponent({
    this.currentTurn = 1,
    this.isAllyTurn = true,
    this.switchDuration = 0.5,
    super.position,
    super.size,
    super.anchor,
  });

  @override
  Future<void> onLoad() async {
    // TODO: 创建回合数文本和行动方标识
  }

  @override
  void update(double dt) {
    super.update(dt);
    // TODO: 更新回合切换动画
  }

  /// 切换回合
  void nextTurn(bool isAlly) {
    // TODO: 切换到下一回合，播放切换动画
    throw UnimplementedError();
  }

  /// 设置回合数
  void setTurn(int turn) {
    // TODO: 设置当前回合数
    throw UnimplementedError();
  }
}
