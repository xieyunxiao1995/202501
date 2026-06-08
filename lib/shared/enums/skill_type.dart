/// 技能类型
enum SkillType {
  normal(label: '普攻'),
  active(label: '战法'),
  ultimate(label: '大招'),
  passive(label: '被动');

  const SkillType({required this.label});

  final String label;

  static SkillType fromJson(String json) => SkillType.values.firstWhere(
        (e) => e.name == json,
        orElse: () => SkillType.normal,
      );

  String toJson() => name;
}
