/// 兵种
enum TroopType {
  infantry(label: '步兵', icon: '🚶'),
  cavalry(label: '骑兵', icon: '🐎'),
  archer(label: '弓兵', icon: '🏹'),
  spear(label: '枪兵', icon: '🔱'),
  shield(label: '盾兵', icon: '🛡️'),
  strategist(label: '谋士', icon: '📖');

  const TroopType({required this.label, required this.icon});

  final String label;
  final String icon;

  /// 兵种相克：骑兵>步兵>枪兵>骑兵，弓兵>谋士>盾兵>弓兵
  TroopType? get counteredBy => switch (this) {
        TroopType.infantry => TroopType.cavalry,
        TroopType.cavalry => TroopType.spear,
        TroopType.spear => TroopType.infantry,
        TroopType.archer => TroopType.shield,
        TroopType.shield => TroopType.strategist,
        TroopType.strategist => TroopType.archer,
      };

  TroopType? get counters => switch (this) {
        TroopType.infantry => TroopType.spear,
        TroopType.cavalry => TroopType.infantry,
        TroopType.spear => TroopType.cavalry,
        TroopType.archer => TroopType.strategist,
        TroopType.shield => TroopType.archer,
        TroopType.strategist => TroopType.shield,
      };

  bool isCounteredBy(TroopType other) => counteredBy == other;

  bool countersTo(TroopType other) => counters == other;

  static TroopType fromJson(String json) => TroopType.values.firstWhere(
        (e) => e.name == json,
        orElse: () => TroopType.infantry,
      );

  String toJson() => name;
}
