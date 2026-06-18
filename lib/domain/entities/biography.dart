/// 武将传记实体
///
/// 表示武将的人物传记，包含正史和演义两个维度的故事内容。
/// 传记按章节解锁，玩家可通过收集武将碎片或完成特定任务来解锁。
class Biography {
  /// 传记唯一标识
  final String id;

  /// 关联武将 ID
  final String generalId;

  /// 正史文本
  final String historyText;

  /// 演义文本
  final String romanceText;

  /// 是否已解锁
  final bool unlocked;

  /// 已解锁的章节列表
  final List<String> unlockedChapters;

  const Biography({
    required this.id,
    required this.generalId,
    this.historyText = '',
    this.romanceText = '',
    this.unlocked = false,
    this.unlockedChapters = const [],
  });

  factory Biography.fromJson(Map<String, dynamic> json) {
    return Biography(
      id: json['id'] as String,
      generalId: json['generalId'] as String? ?? json['general_id'] as String? ?? '',
      historyText: json['historyText'] as String? ?? json['history_text'] as String? ?? '',
      romanceText: json['romanceText'] as String? ?? json['romance_text'] as String? ?? '',
      unlocked: json['unlocked'] as bool? ?? false,
      unlockedChapters: (json['unlockedChapters'] as List<dynamic>? ?? json['unlocked_chapters'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'generalId': generalId,
        'historyText': historyText,
        'romanceText': romanceText,
        'unlocked': unlocked,
        'unlockedChapters': unlockedChapters,
      };

  Biography copyWith({
    String? id,
    String? generalId,
    String? historyText,
    String? romanceText,
    bool? unlocked,
    List<String>? unlockedChapters,
  }) {
    return Biography(
      id: id ?? this.id,
      generalId: generalId ?? this.generalId,
      historyText: historyText ?? this.historyText,
      romanceText: romanceText ?? this.romanceText,
      unlocked: unlocked ?? this.unlocked,
      unlockedChapters: unlockedChapters ?? this.unlockedChapters,
    );
  }
}
