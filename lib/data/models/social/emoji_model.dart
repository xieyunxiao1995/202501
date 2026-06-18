/// 表情数据模型（DTO）
///
/// 表示聊天中可使用的表情配置，包含表情标识、名称和资源路径。
class EmojiModel {
  /// 表情唯一标识
  final String id;

  /// 表情名称
  final String name;

  /// 表情资源路径
  final String assetPath;

  /// 表情分类
  final String category;

  /// 排序权重
  final int sortWeight;

  const EmojiModel({
    required this.id,
    required this.name,
    required this.assetPath,
    this.category = 'default',
    this.sortWeight = 0,
  });

  factory EmojiModel.fromJson(Map<String, dynamic> json) {
    return EmojiModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      assetPath: json['asset_path'] as String? ?? json['assetPath'] as String? ?? '',
      category: json['category'] as String? ?? 'default',
      sortWeight: (json['sort_weight'] as num?)?.toInt() ?? (json['sortWeight'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'asset_path': assetPath,
        'category': category,
        'sort_weight': sortWeight,
      };

  EmojiModel copyWith({
    String? id,
    String? name,
    String? assetPath,
    String? category,
    int? sortWeight,
  }) {
    return EmojiModel(
      id: id ?? this.id,
      name: name ?? this.name,
      assetPath: assetPath ?? this.assetPath,
      category: category ?? this.category,
      sortWeight: sortWeight ?? this.sortWeight,
    );
  }
}
