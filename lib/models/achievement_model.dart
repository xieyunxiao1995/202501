class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final AchievementType type;
  final int requirement;
  final int reward;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.type,
    required this.requirement,
    required this.reward,
  });

  bool isUnlocked(int currentValue) {
    return currentValue >= requirement;
  }
}

enum AchievementType {
  beastsCollected, // 收集异兽数量
  beastsEvolved,   // 进化异兽数量
  dungeonsCleared, // 通关地牢数量
  resourcesGathered, // 收集资源数量
  totemLevel,      // 图腾等级
  battleWins,      // 战斗胜利次数
}

class AchievementManager {
  static List<Achievement> getAllAchievements() {
    return [
      // 收集成就
      Achievement(
        id: 'collect_10',
        name: '初入山海',
        description: '收集10只异兽',
        icon: '🔍',
        type: AchievementType.beastsCollected,
        requirement: 10,
        reward: 500,
      ),
      Achievement(
        id: 'collect_30',
        name: '山海游侠',
        description: '收集30只异兽',
        icon: '🎒',
        type: AchievementType.beastsCollected,
        requirement: 30,
        reward: 1500,
      ),
      Achievement(
        id: 'collect_50',
        name: '山海大师',
        description: '收集50只异兽',
        icon: '👑',
        type: AchievementType.beastsCollected,
        requirement: 50,
        reward: 3000,
      ),

      // 进化成就
      Achievement(
        id: 'evolve_5',
        name: '进化之路',
        description: '进化5只异兽',
        icon: '⬆️',
        type: AchievementType.beastsEvolved,
        requirement: 5,
        reward: 1000,
      ),
      Achievement(
        id: 'evolve_20',
        name: '进化大师',
        description: '进化20只异兽',
        icon: '🌟',
        type: AchievementType.beastsEvolved,
        requirement: 20,
        reward: 3000,
      ),

      // 地牢成就
      Achievement(
        id: 'dungeon_5',
        name: '勇闯地牢',
        description: '通关5个地牢',
        icon: '⚔️',
        type: AchievementType.dungeonsCleared,
        requirement: 5,
        reward: 800,
      ),
      Achievement(
        id: 'dungeon_10',
        name: '地牢征服者',
        description: '通关10个地牢',
        icon: '🏆',
        type: AchievementType.dungeonsCleared,
        requirement: 10,
        reward: 2000,
      ),

      // 资源成就
      Achievement(
        id: 'spirit_10000',
        name: '富甲一方',
        description: '累计获得10000灵气',
        icon: '💰',
        type: AchievementType.resourcesGathered,
        requirement: 10000,
        reward: 2000,
      ),
      Achievement(
        id: 'spirit_50000',
        name: '灵气宗师',
        description: '累计获得50000灵气',
        icon: '💎',
        type: AchievementType.resourcesGathered,
        requirement: 50000,
        reward: 5000,
      ),

      // 图腾成就
      Achievement(
        id: 'totem_5',
        name: '部落兴起',
        description: '图腾达到5级',
        icon: '🏛️',
        type: AchievementType.totemLevel,
        requirement: 5,
        reward: 1500,
      ),
      Achievement(
        id: 'totem_10',
        name: '部落强盛',
        description: '图腾达到10级',
        icon: '🗿',
        type: AchievementType.totemLevel,
        requirement: 10,
        reward: 3000,
      ),

      // 战斗成就
      Achievement(
        id: 'battle_20',
        name: '战斗新星',
        description: '赢得20场战斗',
        icon: '⚡',
        type: AchievementType.battleWins,
        requirement: 20,
        reward: 1000,
      ),
      Achievement(
        id: 'battle_50',
        name: '战斗大师',
        description: '赢得50场战斗',
        icon: '🔥',
        type: AchievementType.battleWins,
        requirement: 50,
        reward: 2500,
      ),
    ];
  }

  static int getProgress(Achievement achievement, Map<String, int> stats) {
    switch (achievement.type) {
      case AchievementType.beastsCollected:
        return stats['beastsCollected'] ?? 0;
      case AchievementType.beastsEvolved:
        return stats['beastsEvolved'] ?? 0;
      case AchievementType.dungeonsCleared:
        return stats['dungeonsCleared'] ?? 0;
      case AchievementType.resourcesGathered:
        return stats['spiritGathered'] ?? 0;
      case AchievementType.totemLevel:
        return stats['totemLevel'] ?? 0;
      case AchievementType.battleWins:
        return stats['battleWins'] ?? 0;
    }
  }
}

class AchievementStats {
  final int beastsCollected;
  final int beastsEvolved;
  final int dungeonsCleared;
  final int spiritGathered;
  final int totemLevel;
  final int battleWins;
  final Set<String> claimedAchievements;

  AchievementStats({
    this.beastsCollected = 0,
    this.beastsEvolved = 0,
    this.dungeonsCleared = 0,
    this.spiritGathered = 0,
    this.totemLevel = 0,
    this.battleWins = 0,
    this.claimedAchievements = const {},
  });

  AchievementStats copyWith({
    int? beastsCollected,
    int? beastsEvolved,
    int? dungeonsCleared,
    int? spiritGathered,
    int? totemLevel,
    int? battleWins,
    Set<String>? claimedAchievements,
  }) {
    return AchievementStats(
      beastsCollected: beastsCollected ?? this.beastsCollected,
      beastsEvolved: beastsEvolved ?? this.beastsEvolved,
      dungeonsCleared: dungeonsCleared ?? this.dungeonsCleared,
      spiritGathered: spiritGathered ?? this.spiritGathered,
      totemLevel: totemLevel ?? this.totemLevel,
      battleWins: battleWins ?? this.battleWins,
      claimedAchievements: claimedAchievements ?? this.claimedAchievements,
    );
  }

  Map<String, int> toMap() {
    return {
      'beastsCollected': beastsCollected,
      'beastsEvolved': beastsEvolved,
      'dungeonsCleared': dungeonsCleared,
      'spiritGathered': spiritGathered,
      'totemLevel': totemLevel,
      'battleWins': battleWins,
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'beastsCollected': beastsCollected,
      'beastsEvolved': beastsEvolved,
      'dungeonsCleared': dungeonsCleared,
      'spiritGathered': spiritGathered,
      'totemLevel': totemLevel,
      'battleWins': battleWins,
      'claimedAchievements': claimedAchievements.toList(),
    };
  }

  factory AchievementStats.fromJson(Map<String, dynamic> json) {
    return AchievementStats(
      beastsCollected: json['beastsCollected'] ?? 0,
      beastsEvolved: json['beastsEvolved'] ?? 0,
      dungeonsCleared: json['dungeonsCleared'] ?? 0,
      spiritGathered: json['spiritGathered'] ?? 0,
      totemLevel: json['totemLevel'] ?? 0,
      battleWins: json['battleWins'] ?? 0,
      claimedAchievements:
          Set<String>.from(json['claimedAchievements'] ?? []),
    );
  }
}
