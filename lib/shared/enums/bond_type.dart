/// 羁绊类型
enum BondType {
  peachGarden(label: '桃园结义'),
  fiveTigers(label: '五虎上将'),
  fiveAdvisors(label: '五大谋士'),
  dragonPhoenix(label: '龙凤呈祥'),
  swornBrothers(label: '义结金兰'),
  lordRetainer(label: '君臣之义'),
  bloodBrothers(label: '歃血为盟'),
  teacherStudent(label: '师徒传承'),
  rivalFriends(label: '亦敌亦友'),
  familyBond(label: '血脉相连');

  const BondType({required this.label});

  final String label;

  static BondType fromJson(String json) => BondType.values.firstWhere(
        (e) => e.name == json,
        orElse: () => BondType.peachGarden,
      );

  String toJson() => name;
}
