/// 职业
enum Profession {
  berserker(label: '猛将', icon: '⚔️'),
  guardian(label: '守将', icon: '🛡️'),
  warSage(label: '武圣', icon: '🗡️'),
  assassin(label: '刺客', icon: '🗡️'),
  strategist(label: '军师', icon: '📜'),
  support(label: '辅助', icon: '💚'),
  trickster(label: '奇谋', icon: '🎭');

  const Profession({required this.label, required this.icon});

  final String label;
  final String icon;

  static Profession fromJson(String json) => Profession.values.firstWhere(
        (e) => e.name == json,
        orElse: () => Profession.berserker,
      );

  String toJson() => name;
}
