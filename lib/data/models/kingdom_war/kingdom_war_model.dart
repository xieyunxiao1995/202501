/// 国战数据模型（DTO）
///
/// 表示国战活动的整体状态，包含赛季、阶段和阵营积分。
class KingdomWarModel {
  /// 国战唯一标识
  final String id;

  /// 赛季编号
  final int season;

  /// 当前阶段（preparation/battle/settlement）
  final String phase;

  /// 魏国积分
  final int weiScore;

  /// 蜀国积分
  final int shuScore;

  /// 吴国积分
  final int wuScore;

  /// 开始时间戳（毫秒）
  final int startTime;

  /// 结束时间戳（毫秒）
  final int endTime;

  const KingdomWarModel({
    required this.id,
    required this.season,
    this.phase = 'preparation',
    this.weiScore = 0,
    this.shuScore = 0,
    this.wuScore = 0,
    this.startTime = 0,
    this.endTime = 0,
  });

  factory KingdomWarModel.fromJson(Map<String, dynamic> json) {
    return KingdomWarModel(
      id: json['id'] as String,
      season: (json['season'] as num?)?.toInt() ?? 0,
      phase: json['phase'] as String? ?? 'preparation',
      weiScore: (json['wei_score'] as num?)?.toInt() ?? (json['weiScore'] as num?)?.toInt() ?? 0,
      shuScore: (json['shu_score'] as num?)?.toInt() ?? (json['shuScore'] as num?)?.toInt() ?? 0,
      wuScore: (json['wu_score'] as num?)?.toInt() ?? (json['wuScore'] as num?)?.toInt() ?? 0,
      startTime: (json['start_time'] as num?)?.toInt() ?? (json['startTime'] as num?)?.toInt() ?? 0,
      endTime: (json['end_time'] as num?)?.toInt() ?? (json['endTime'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'season': season,
        'phase': phase,
        'wei_score': weiScore,
        'shu_score': shuScore,
        'wu_score': wuScore,
        'start_time': startTime,
        'end_time': endTime,
      };

  KingdomWarModel copyWith({
    String? id,
    int? season,
    String? phase,
    int? weiScore,
    int? shuScore,
    int? wuScore,
    int? startTime,
    int? endTime,
  }) {
    return KingdomWarModel(
      id: id ?? this.id,
      season: season ?? this.season,
      phase: phase ?? this.phase,
      weiScore: weiScore ?? this.weiScore,
      shuScore: shuScore ?? this.shuScore,
      wuScore: wuScore ?? this.wuScore,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
