/// 阵法类型
enum FormationType {
  longSnake(label: '长蛇阵', description: '一字长蛇，首尾相顾，攻守兼备'),
  doubleDragon(label: '双龙出水阵', description: '双龙齐出，水火交融，势不可挡'),
  threeTalent(label: '三才阵', description: '天地人三才合一，生生不息'),
  fourSymbol(label: '四象阵', description: '青龙白虎朱雀玄武，四方守护'),
  fiveElement(label: '五行阵', description: '金木水火土五行相生相克'),
  sixHarmony(label: '六合阵', description: '上下四方六合归一，固若金汤'),
  sevenStar(label: '七星阵', description: '北斗七星连珠，杀机暗藏'),
  eightTrigram(label: '八卦阵', description: '乾坤震巽坎离艮兑，变化无穷'),
  ninePalace(label: '九宫阵', description: '九宫飞星，天地玄黄，万法归宗');

  const FormationType({required this.label, required this.description});

  final String label;
  final String description;

  static FormationType fromJson(String json) =>
      FormationType.values.firstWhere(
        (e) => e.name == json,
        orElse: () => FormationType.longSnake,
      );

  String toJson() => name;
}
