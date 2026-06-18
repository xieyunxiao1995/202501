/// 章节数据模型（DTO）
///
/// 表示游戏中的一个章节，包含章节名称、排序和包含的关卡列表。
class ChapterModel {
  /// 章节唯一标识
  final String id;

  /// 章节名称
  final String name;

  /// 章节排序序号
  final int order;

  /// 关卡 ID 列表
  final List<String> stageIds;

  /// 章节描述
  final String? description;

  /// 是否已解锁
  final bool unlocked;

  const ChapterModel({
    required this.id,
    required this.name,
    this.order = 0,
    this.stageIds = const [],
    this.description,
    this.unlocked = false,
  });

  factory ChapterModel.fromJson(Map<String, dynamic> json) {
    return ChapterModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      order: (json['order'] as num?)?.toInt() ?? 0,
      stageIds: (json['stage_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      description: json['description'] as String?,
      unlocked: json['unlocked'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'order': order,
        'stage_ids': stageIds,
        if (description != null) 'description': description,
        'unlocked': unlocked,
      };

  ChapterModel copyWith({
    String? id,
    String? name,
    int? order,
    List<String>? stageIds,
    String? description,
    bool? unlocked,
  }) {
    return ChapterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      order: order ?? this.order,
      stageIds: stageIds ?? this.stageIds,
      description: description ?? this.description,
      unlocked: unlocked ?? this.unlocked,
    );
  }
}
