/// 战斗状态
enum BattleStatus {
  idle(label: '空闲'),
  preparing(label: '准备中'),
  inProgress(label: '战斗中'),
  paused(label: '暂停'),
  ended(label: '已结束');

  const BattleStatus({required this.label});

  final String label;

  static BattleStatus fromJson(String json) => BattleStatus.values.firstWhere(
        (e) => e.name == json,
        orElse: () => BattleStatus.idle,
      );

  String toJson() => name;
}
