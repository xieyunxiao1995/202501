/// 计谋类型
enum TacticType {
  fireAttack(label: '火攻', description: '以火攻敌，焚烧粮草营寨', emoji: '🔥'),
  waterAttack(label: '水攻', description: '引水淹敌，水淹七军', emoji: '🌊'),
  emptyFort(label: '空城计', description: '虚张声势，以空城退敌', emoji: '🏯'),
  sowDiscord(label: '离间计', description: '离间敌将，使其内讧', emoji: '🗡️'),
  selfHarm(label: '苦肉计', description: '自伤骗敌，以苦肉取信', emoji: '🩸'),
  borrowedKnife(label: '借刀杀人', description: '借力打力，以敌制敌', emoji: '🔪'),
  lureEnemy(label: '诱敌深入', description: '佯败诱敌，伏兵围歼', emoji: '🎯'),
  feint(label: '声东击西', description: '佯攻东面，实则击西', emoji: '🎭');

  const TacticType({
    required this.label,
    required this.description,
    required this.emoji,
  });

  final String label;
  final String description;
  final String emoji;

  static TacticType fromJson(String json) => TacticType.values.firstWhere(
        (e) => e.name == json,
        orElse: () => TacticType.fireAttack,
      );

  String toJson() => name;
}
