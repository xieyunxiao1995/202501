/// 任务类型
enum QuestType {
  daily(label: '日常'),
  weekly(label: '周常'),
  achievement(label: '成就'),
  battlePass(label: '通行证');

  const QuestType({required this.label});

  final String label;

  static QuestType fromJson(String json) => QuestType.values.firstWhere(
        (e) => e.name == json,
        orElse: () => QuestType.daily,
      );

  String toJson() => name;
}
