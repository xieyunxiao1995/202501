/// 站位
enum Position {
  vanguard(label: '前军', positionIndex: 0),
  center(label: '中军', positionIndex: 1),
  rear(label: '后军', positionIndex: 2);

  const Position({required this.label, required this.positionIndex});

  final String label;
  final int positionIndex;

  static Position fromJson(String json) => Position.values.firstWhere(
        (e) => e.name == json,
        orElse: () => Position.vanguard,
      );

  String toJson() => name;
}
