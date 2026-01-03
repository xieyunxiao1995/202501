class PlayerStats {
  int hp;
  int maxHp;
  int currentFloor;
  int gold;
  int enemiesDefeated;
  int itemsCrafted;
  int deaths;

  PlayerStats({
    this.hp = 100,
    this.maxHp = 100,
    this.currentFloor = 1,
    this.gold = 0,
    this.enemiesDefeated = 0,
    this.itemsCrafted = 0,
    this.deaths = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'hp': hp,
      'maxHp': maxHp,
      'currentFloor': currentFloor,
      'gold': gold,
      'enemiesDefeated': enemiesDefeated,
      'itemsCrafted': itemsCrafted,
      'deaths': deaths,
    };
  }

  factory PlayerStats.fromJson(Map<String, dynamic> json) {
    return PlayerStats(
      hp: json['hp'] ?? 100,
      maxHp: json['maxHp'] ?? 100,
      currentFloor: json['currentFloor'] ?? 1,
      gold: json['gold'] ?? 0,
      enemiesDefeated: json['enemiesDefeated'] ?? 0,
      itemsCrafted: json['itemsCrafted'] ?? 0,
      deaths: json['deaths'] ?? 0,
    );
  }
}
