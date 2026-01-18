import 'enums.dart';

class PlayerStats {
  int hp;
  int maxHp;
  int shield;
  int power;
  int gold;
  int score;
  int highScore;
  int floor;
  String classId;
  List<String> relics;
  int skillCharge;
  int combo;
  int keys;
  int poison;
  int weak;
  int burn; // New Status Effect
  int level;
  int xp;
  int maxXp;
  List<String> perks;
  GameElement currentElement;
  String? equippedSoulId;

  PlayerStats({
    required this.hp,
    required this.maxHp,
    required this.shield,
    required this.power,
    required this.gold,
    required this.score,
    required this.highScore,
    required this.floor,
    required this.classId,
    required this.relics,
    required this.skillCharge,
    required this.combo,
    required this.keys,
    required this.poison,
    required this.weak,
    required this.burn,
    required this.level,
    required this.xp,
    required this.maxXp,
    required this.perks,
    this.currentElement = GameElement.none,
    this.equippedSoulId,
  });

  PlayerStats copyWith({
    int? hp,
    int? maxHp,
    int? shield,
    int? power,
    int? gold,
    int? score,
    int? highScore,
    int? floor,
    String? classId,
    List<String>? relics,
    int? skillCharge,
    int? combo,
    int? keys,
    int? poison,
    int? weak,
    int? burn,
    int? level,
    int? xp,
    int? maxXp,
    List<String>? perks,
    GameElement? currentElement,
    String? equippedSoulId,
  }) {
    return PlayerStats(
      hp: hp ?? this.hp,
      maxHp: maxHp ?? this.maxHp,
      shield: shield ?? this.shield,
      power: power ?? this.power,
      gold: gold ?? this.gold,
      score: score ?? this.score,
      highScore: highScore ?? this.highScore,
      floor: floor ?? this.floor,
      classId: classId ?? this.classId,
      relics: relics ?? this.relics,
      skillCharge: skillCharge ?? this.skillCharge,
      combo: combo ?? this.combo,
      keys: keys ?? this.keys,
      poison: poison ?? this.poison,
      weak: weak ?? this.weak,
      burn: burn ?? this.burn,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      maxXp: maxXp ?? this.maxXp,
      perks: perks ?? this.perks,
      currentElement: currentElement ?? this.currentElement,
      equippedSoulId: equippedSoulId ?? this.equippedSoulId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hp': hp,
      'maxHp': maxHp,
      'shield': shield,
      'power': power,
      'gold': gold,
      'score': score,
      'highScore': highScore,
      'floor': floor,
      'classId': classId,
      'relics': relics,
      'skillCharge': skillCharge,
      'combo': combo,
      'keys': keys,
      'poison': poison,
      'weak': weak,
      'burn': burn,
      'level': level,
      'xp': xp,
      'maxXp': maxXp,
      'perks': perks,
      'currentElement': currentElement.index,
      'equippedSoulId': equippedSoulId,
    };
  }

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      hp: json['hp'],
      maxHp: json['maxHp'],
      shield: json['shield'],
      power: json['power'],
      gold: json['gold'],
      score: json['score'],
      highScore: json['highScore'],
      floor: json['floor'],
      classId: json['classId'],
      relics: List<String>.from(json['relics']),
      skillCharge: json['skillCharge'],
      combo: json['combo'],
      keys: json['keys'],
      poison: json['poison'],
      weak: json['weak'],
      burn: json['burn'] ?? 0,
      level: json['level'],
      xp: json['xp'],
      maxXp: json['maxXp'],
      perks: List<String>.from(json['perks']),
      currentElement: GameElement.values[json['currentElement'] ?? 0],
      equippedSoulId: json['equippedSoulId'],
    );
  }
}
