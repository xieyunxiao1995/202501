/// 爵位
enum Title {
  commoner(label: '白身'),
  baron(label: '男爵'),
  viscount(label: '子爵'),
  earl(label: '伯爵'),
  marquis(label: '侯爵'),
  duke(label: '公爵'),
  prince(label: '王爷');

  const Title({required this.label});

  final String label;

  static Title fromJson(String json) => Title.values.firstWhere(
        (e) => e.name == json,
        orElse: () => Title.commoner,
      );

  String toJson() => name;
}
