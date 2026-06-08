/// Buff 类型
enum BuffType {
  attack(label: '攻击加成'),
  defense(label: '防御加成'),
  speed(label: '速度加成'),
  rage(label: '怒气加成'),
  shield(label: '护盾'),
  burn(label: '灼烧'),
  freeze(label: '冰冻'),
  stun(label: '眩晕'),
  poison(label: '中毒'),
  heal(label: '治疗'),
  critical(label: '暴击加成'),
  dodge(label: '闪避加成');

  const BuffType({required this.label});

  final String label;

  /// 是否为减益效果
  bool get isDebuff => switch (this) {
        BuffType.burn ||
        BuffType.freeze ||
        BuffType.stun ||
        BuffType.poison =>
          true,
        _ => false,
      };

  static BuffType fromJson(String json) => BuffType.values.firstWhere(
        (e) => e.name == json,
        orElse: () => BuffType.attack,
      );

  String toJson() => name;
}
