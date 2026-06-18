/// 国战排名数据模型（DTO）
///
/// 表示国战中的阵营排名信息，包含阵营、积分和排名。
class KingdomRankModel {
  /// 排名记录唯一标识
  final String id;

  /// 阵营标识（wei/shu/wu）
  final String kingdom;

  /// 赛季编号
  final int season;

  /// 积分
  final int score;

  /// 排名
  final int rank;

  /// 占领城池数
  final int citiesOccupied;

  /// 击杀总数
  final int totalKills;

  const KingdomRankModel({
    required this.id,
    required this.kingdom,
    required this.season,
    this.score = 0,
    this.rank = 0,
    this.citiesOccupied = 0,
    this.totalKills = 0,
  });

  factory KingdomRankModel.fromJson(Map<String, dynamic> json) {
    return KingdomRankModel(
      id: json['id'] as String,
      kingdom: json['kingdom'] as String,
      season: (json['season'] as num?)?.toInt() ?? 0,
      score: (json['score'] as num?)?.toInt() ?? 0,
      rank: (json['rank'] as num?)?.toInt() ?? 0,
      citiesOccupied: (json['cities_occupied'] as num?)?.toInt() ?? (json['citiesOccupied'] as num?)?.toInt() ?? 0,
      totalKills: (json['total_kills'] as num?)?.toInt() ?? (json['totalKills'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'kingdom': kingdom,
        'season': season,
        'score': score,
        'rank': rank,
        'cities_occupied': citiesOccupied,
        'total_kills': totalKills,
      };

  KingdomRankModel copyWith({
    String? id,
    String? kingdom,
    int? season,
    int? score,
    int? rank,
    int? citiesOccupied,
    int? totalKills,
  }) {
    return KingdomRankModel(
      id: id ?? this.id,
      kingdom: kingdom ?? this.kingdom,
      season: season ?? this.season,
      score: score ?? this.score,
      rank: rank ?? this.rank,
      citiesOccupied: citiesOccupied ?? this.citiesOccupied,
      totalKills: totalKills ?? this.totalKills,
    );
  }
}
