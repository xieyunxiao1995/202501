/// 武将传记数据模型（DTO）
///
/// 表示武将传记内容，包含历史文本、演义文本、解锁状态和章节列表。
class BiographyModel {
  /// 传记唯一标识
  final String id;

  /// 所属武将 ID
  final String generalId;

  /// 历史传记文本
  final String? historyText;

  /// 演义传记文本
  final String? romanceText;

  /// 是否已解锁
  final bool unlocked;

  /// 章节列表
  final List<String> chapters;

  const BiographyModel({
    required this.id,
    required this.generalId,
    this.historyText,
    this.romanceText,
    this.unlocked = false,
    this.chapters = const [],
  });

  factory BiographyModel.fromJson(Map<String, dynamic> json) {
    return BiographyModel(
      id: json['id'] as String,
      generalId: json['generalId'] as String,
      historyText: json['historyText'] as String?,
      romanceText: json['romanceText'] as String?,
      unlocked: json['unlocked'] as bool? ?? false,
      chapters: (json['chapters'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'generalId': generalId,
      'historyText': historyText,
      'romanceText': romanceText,
      'unlocked': unlocked,
      'chapters': chapters,
    };
  }

  BiographyModel copyWith({
    String? id,
    String? generalId,
    String? historyText,
    String? romanceText,
    bool? unlocked,
    List<String>? chapters,
  }) {
    return BiographyModel(
      id: id ?? this.id,
      generalId: generalId ?? this.generalId,
      historyText: historyText ?? this.historyText,
      romanceText: romanceText ?? this.romanceText,
      unlocked: unlocked ?? this.unlocked,
      chapters: chapters ?? this.chapters,
    );
  }
}
