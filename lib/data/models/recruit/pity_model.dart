/// 保底数据模型（DTO）
///
/// 表示玩家在某个卡池中的保底进度，包含当前计数和保底状态。
class PityModel {
  /// 卡池 ID
  final String poolId;

  /// 当前保底计数（距上次 SSR 的抽数）
  final int currentCount;

  /// 保底阈值
  final int threshold;

  /// 是否触发大保底（上次 SSR 非 UP 时下次必出 UP）
  final bool guaranteed;

  /// 距上次 SR 的抽数
  final int srCount;

  /// SR 保底阈值
  final int srThreshold;

  const PityModel({
    required this.poolId,
    this.currentCount = 0,
    this.threshold = 90,
    this.guaranteed = false,
    this.srCount = 0,
    this.srThreshold = 10,
  });

  factory PityModel.fromJson(Map<String, dynamic> json) {
    return PityModel(
      poolId: json['pool_id'] as String? ?? json['poolId'] as String? ?? '',
      currentCount: (json['current_count'] as num?)?.toInt() ?? (json['currentCount'] as num?)?.toInt() ?? 0,
      threshold: (json['threshold'] as num?)?.toInt() ?? 90,
      guaranteed: json['guaranteed'] as bool? ?? false,
      srCount: (json['sr_count'] as num?)?.toInt() ?? (json['srCount'] as num?)?.toInt() ?? 0,
      srThreshold: (json['sr_threshold'] as num?)?.toInt() ?? (json['srThreshold'] as num?)?.toInt() ?? 10,
    );
  }

  Map<String, dynamic> toJson() => {
        'pool_id': poolId,
        'current_count': currentCount,
        'threshold': threshold,
        'guaranteed': guaranteed,
        'sr_count': srCount,
        'sr_threshold': srThreshold,
      };

  PityModel copyWith({
    String? poolId,
    int? currentCount,
    int? threshold,
    bool? guaranteed,
    int? srCount,
    int? srThreshold,
  }) {
    return PityModel(
      poolId: poolId ?? this.poolId,
      currentCount: currentCount ?? this.currentCount,
      threshold: threshold ?? this.threshold,
      guaranteed: guaranteed ?? this.guaranteed,
      srCount: srCount ?? this.srCount,
      srThreshold: srThreshold ?? this.srThreshold,
    );
  }
}
