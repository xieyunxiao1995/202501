/// 道具类型
enum ItemType {
  material(label: '材料'),
  expBook(label: '经验书'),
  evolveStone(label: '进阶石'),
  awakenStone(label: '觉醒石'),
  recruitTicket(label: '招贤令'),
  equipmentMaterial(label: '装备材料'),
  gift(label: '礼物'),
  box(label: '宝箱');

  const ItemType({required this.label});

  final String label;

  static ItemType fromJson(String json) => ItemType.values.firstWhere(
        (e) => e.name == json,
        orElse: () => ItemType.material,
      );

  String toJson() => name;
}
