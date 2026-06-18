/// 爵位模型（DTO）
///
/// 表示游戏中的爵位配置数据，包含 ID、名称、稀有度和描述。
class MainTitleModel {
  /// 爵位唯一标识
  final String id;

  /// 爵位名称
  final String name;

  /// 稀有度
  final String rarity;

  /// 爵位描述
  final String? description;

  const MainTitleModel({
    required this.id,
    required this.name,
    this.rarity = 'n',
    this.description,
  });

  factory MainTitleModel.fromJson(Map<String, dynamic> json) {
    return MainTitleModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      rarity: json['rarity'] as String? ?? 'n',
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'rarity': rarity,
        if (description != null) 'description': description,
      };

  MainTitleModel copyWith({
    String? id,
    String? name,
    String? rarity,
    String? description,
  }) {
    return MainTitleModel(
      id: id ?? this.id,
      name: name ?? this.name,
      rarity: rarity ?? this.rarity,
      description: description ?? this.description,
    );
  }
}
