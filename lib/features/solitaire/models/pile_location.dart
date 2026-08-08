enum PileType { stock, waste, tableau, foundation }

class PileLocation {
  const PileLocation(this.type, {this.index, this.cardIndex});

  final PileType type;
  final int? index;
  final int? cardIndex;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'type': type.name,
    'index': index,
    'cardIndex': cardIndex,
  };

  factory PileLocation.fromJson(Map<String, dynamic> json) => PileLocation(
    PileType.values.byName(json['type'] as String),
    index: json['index'] as int?,
    cardIndex: json['cardIndex'] as int?,
  );

  @override
  bool operator ==(Object other) =>
      other is PileLocation &&
      other.type == type &&
      other.index == index &&
      other.cardIndex == cardIndex;

  @override
  int get hashCode => Object.hash(type, index, cardIndex);
}
