enum PartType {
  head,
  body,
  leg,
  tail,
  soul,
}

class Part {
  final String id;
  final String name;
  final PartType type;
  final String description;
  final Map<String, dynamic> stats; // e.g., {'attack': 10, 'defense': 5}
  final String origin; // e.g., "Nine-Tailed Fox"

  const Part({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.stats,
    required this.origin,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type.index,
      'description': description,
      'stats': stats,
      'origin': origin,
    };
  }

  factory Part.fromJson(Map<String, dynamic> json) {
    return Part(
      id: json['id'],
      name: json['name'],
      type: PartType.values[json['type']],
      description: json['description'],
      stats: json['stats'],
      origin: json['origin'],
    );
  }

  int get power {
    int score = 0;
    if (stats.containsKey('attack')) score += (stats['attack'] as int) * 2;
    if (stats.containsKey('defense')) score += (stats['defense'] as int) * 2;
    if (stats.containsKey('hp')) score += ((stats['hp'] as int) / 5).round();
    if (stats.containsKey('vision')) score += (stats['vision'] as int);
    if (stats.containsKey('speed')) score += (stats['speed'] as int) * 3;
    return score;
  }
}
