/// 招募池数据模型（DTO）
///
/// 表示招募卡池的配置信息，包含卡池类型、保底机制和可用武将。
class RecruitPoolModel {
  /// 卡池唯一标识
  final String id;

  /// 卡池名称
  final String name;

  /// 卡池类型（normal/premium/limited/friendship）
  final String type;

  /// 可招募武将 ID 列表
  final List<String> generalIds;

  /// 保底次数
  final int pityThreshold;

  /// 消耗货币类型
  final String costCurrencyType;

  /// 单次消耗数量
  final int costPerPull;

  /// 十连消耗数量
  final int costPerTenPull;

  /// 开始时间戳（毫秒，限时卡池）
  final int? startTime;

  /// 结束时间戳（毫秒，限时卡池）
  final int? endTime;

  const RecruitPoolModel({
    required this.id,
    required this.name,
    required this.type,
    this.generalIds = const [],
    this.pityThreshold = 90,
    this.costCurrencyType = 'premium',
    this.costPerPull = 1,
    this.costPerTenPull = 10,
    this.startTime,
    this.endTime,
  });

  factory RecruitPoolModel.fromJson(Map<String, dynamic> json) {
    return RecruitPoolModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      generalIds: (json['general_ids'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      pityThreshold: (json['pity_threshold'] as num?)?.toInt() ?? (json['pityThreshold'] as num?)?.toInt() ?? 90,
      costCurrencyType: json['cost_currency_type'] as String? ?? json['costCurrencyType'] as String? ?? 'premium',
      costPerPull: (json['cost_per_pull'] as num?)?.toInt() ?? (json['costPerPull'] as num?)?.toInt() ?? 1,
      costPerTenPull: (json['cost_per_ten_pull'] as num?)?.toInt() ?? (json['costPerTenPull'] as num?)?.toInt() ?? 10,
      startTime: (json['start_time'] as num?)?.toInt() ?? (json['startTime'] as num?)?.toInt(),
      endTime: (json['end_time'] as num?)?.toInt() ?? (json['endTime'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'general_ids': generalIds,
        'pity_threshold': pityThreshold,
        'cost_currency_type': costCurrencyType,
        'cost_per_pull': costPerPull,
        'cost_per_ten_pull': costPerTenPull,
        if (startTime != null) 'start_time': startTime,
        if (endTime != null) 'end_time': endTime,
      };

  RecruitPoolModel copyWith({
    String? id,
    String? name,
    String? type,
    List<String>? generalIds,
    int? pityThreshold,
    String? costCurrencyType,
    int? costPerPull,
    int? costPerTenPull,
    int? startTime,
    int? endTime,
  }) {
    return RecruitPoolModel(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      generalIds: generalIds ?? this.generalIds,
      pityThreshold: pityThreshold ?? this.pityThreshold,
      costCurrencyType: costCurrencyType ?? this.costCurrencyType,
      costPerPull: costPerPull ?? this.costPerPull,
      costPerTenPull: costPerTenPull ?? this.costPerTenPull,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
