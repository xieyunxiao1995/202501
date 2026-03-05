/// 关卡数据类
class Stage {
  final int id;
  final String name;
  final int recLevel;
  final String bg;
  final List<String> drops;
  final List<Map<String, String>> story; // 新增剧情字段

  const Stage({
    required this.id,
    required this.name,
    required this.recLevel,
    required this.bg,
    required this.drops,
    required this.story,
  });

  factory Stage.fromJson(Map<String, dynamic> json) {
    return Stage(
      id: json['id'] as int,
      name: json['name'] as String,
      recLevel: json['recLevel'] as int,
      bg: json['bg'] as String,
      drops: (json['drops'] as List).cast<String>(),
      story: (json['story'] as List? ?? [])
          .map((e) => Map<String, String>.from(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'recLevel': recLevel,
      'bg': bg,
      'drops': drops,
      'story': story,
    };
  }
}
