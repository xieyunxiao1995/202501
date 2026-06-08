/// 建筑类型
enum BuildingType {
  lordHall(label: '主公殿'),
  trainingGround(label: '演武场'),
  councilHall(label: '议事厅'),
  weaponForge(label: '兵器坊'),
  stable(label: '马厩'),
  tavern(label: '酒馆'),
  granary(label: '粮仓'),
  mint(label: '铸币厂'),
  academy(label: '书院'),
  observatory(label: '观星台'),
  arena(label: '校场');

  const BuildingType({required this.label});

  final String label;

  static BuildingType fromJson(String json) => BuildingType.values.firstWhere(
        (e) => e.name == json,
        orElse: () => BuildingType.lordHall,
      );

  String toJson() => name;
}
