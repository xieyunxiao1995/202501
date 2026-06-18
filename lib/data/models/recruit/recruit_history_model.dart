/// 招募历史数据模型（DTO）
///
/// 表示玩家的招募历史记录，包含卡池、次数和结果列表。
class RecruitHistoryModel {
  /// 历史记录唯一标识
  final String id;

  /// 卡池 ID
  final String poolId;

  /// 总招募次数
  final int totalPulls;

  /// 结果 ID 列表
  final List<String> resultIds;

  const RecruitHistoryModel({
    required this.id,
    required this.poolId,
    this.totalPulls = 0,
    this.resultIds = const [],
  });

  factory RecruitHistoryModel.fromJson(Map<String, dynamic> json) {
    return RecruitHistoryModel(
      id: json['id'] as String,
      poolId: json['pool_id'] as String? ?? json['poolId'] as String? ?? '',
      totalPulls: (json['total_pulls'] as num?)?.toInt() ?? (json['totalPulls'] as num?)?.toInt() ?? 0,
      resultIds: (json['result_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pool_id': poolId,
        'total_pulls': totalPulls,
        'result_ids': resultIds,
      };

  RecruitHistoryModel copyWith({
    String? id,
    String? poolId,
    int? totalPulls,
    List<String>? resultIds,
  }) {
    return RecruitHistoryModel(
      id: id ?? this.id,
      poolId: poolId ?? this.poolId,
      totalPulls: totalPulls ?? this.totalPulls,
      resultIds: resultIds ?? this.resultIds,
    );
  }
}
