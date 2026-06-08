/// 货币类型
enum CurrencyType {
  gold(label: '金币'),
  premium(label: '元宝'),
  jade(label: '美玉'),
  stamina(label: '体力'),
  honor(label: '荣誉'),
  kingdomCoin(label: '国战币'),
  guildContrib(label: '联盟贡献'),
  prestige(label: '声望');

  const CurrencyType({required this.label});

  final String label;

  static CurrencyType fromJson(String json) =>
      CurrencyType.values.firstWhere(
        (e) => e.name == json,
        orElse: () => CurrencyType.gold,
      );

  String toJson() => name;
}
