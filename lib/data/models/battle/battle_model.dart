import 'lineup_model.dart';

/// 战斗数据模型（DTO）
///
/// 表示一场战斗的完整数据，包含双方阵容、回合信息和战斗状态。
class BattleModel {
  /// 战斗唯一标识
  final String id;

  /// 己方阵容
  final LineupModel lineup;

  /// 敌方阵容
  final LineupModel enemyLineup;

  /// 当前回合数
  final int currentRound;

  /// 最大回合数
  final int maxRounds;

  /// 战斗状态标识（idle/preparing/inProgress/paused/ended）
  final String status;

  const BattleModel({
    required this.id,
    required this.lineup,
    required this.enemyLineup,
    this.currentRound = 0,
    this.maxRounds = 10,
    this.status = 'idle',
  });

  factory BattleModel.fromJson(Map<String, dynamic> json) {
    return BattleModel(
      id: json['id'] as String,
      lineup: LineupModel.fromJson(json['lineup'] as Map<String, dynamic>),
      enemyLineup: LineupModel.fromJson(json['enemyLineup'] as Map<String, dynamic>),
      currentRound: (json['currentRound'] as num?)?.toInt() ?? 0,
      maxRounds: (json['maxRounds'] as num?)?.toInt() ?? 10,
      status: json['status'] as String? ?? 'idle',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'lineup': lineup.toJson(),
        'enemyLineup': enemyLineup.toJson(),
        'currentRound': currentRound,
        'maxRounds': maxRounds,
        'status': status,
      };

  BattleModel copyWith({
    String? id,
    LineupModel? lineup,
    LineupModel? enemyLineup,
    int? currentRound,
    int? maxRounds,
    String? status,
  }) {
    return BattleModel(
      id: id ?? this.id,
      lineup: lineup ?? this.lineup,
      enemyLineup: enemyLineup ?? this.enemyLineup,
      currentRound: currentRound ?? this.currentRound,
      maxRounds: maxRounds ?? this.maxRounds,
      status: status ?? this.status,
    );
  }
}
