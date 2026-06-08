/// 资源类型
enum ResourceType {
  grain(label: '粮食'),
  gold(label: '金币'),
  wood(label: '木材'),
  iron(label: '铁矿');

  const ResourceType({required this.label});

  final String label;

  static ResourceType fromJson(String json) => ResourceType.values.firstWhere(
        (e) => e.name == json,
        orElse: () => ResourceType.grain,
      );

  String toJson() => name;
}
