import '../../shared/enums/battle_status.dart' as enums;

/// 国战实体
///
/// 表示三国国战中的战场信息，包含地图、城市争夺和参战人数。
/// 国战是联盟级别的 PVP 玩法，各阵营争夺城市控制权。
class KingdomWar {
  /// 国战唯一标识
  final String id;

  /// 地图 ID
  final String mapId;

  /// 战斗状态（空闲/准备中/战斗中/暂停/已结束）
  final enums.BattleStatus status;

  /// 战场上的城市列表（城市 ID -> 控制阵营等信息的映射）
  final List<Map<String, dynamic>> cities;

  /// 参战人数
  final int participantCount;

  const KingdomWar({
    required this.id,
    required this.mapId,
    this.status = enums.BattleStatus.idle,
    this.cities = const [],
    this.participantCount = 0,
  });

  factory KingdomWar.fromJson(Map<String, dynamic> json) {
    return KingdomWar(
      id: json['id'] as String,
      mapId: json['mapId'] as String? ?? json['map_id'] as String? ?? '',
      status: json['status'] != null
          ? enums.BattleStatus.fromJson(json['status'] as String)
          : enums.BattleStatus.idle,
      cities: (json['cities'] as List<dynamic>?)
              ?.cast<Map<String, dynamic>>()
              .toList() ??
          const [],
      participantCount: (json['participantCount'] as num? ?? json['participant_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'mapId': mapId,
        'status': status.toJson(),
        'cities': cities,
        'participantCount': participantCount,
      };

  KingdomWar copyWith({
    String? id,
    String? mapId,
    enums.BattleStatus? status,
    List<Map<String, dynamic>>? cities,
    int? participantCount,
  }) {
    return KingdomWar(
      id: id ?? this.id,
      mapId: mapId ?? this.mapId,
      status: status ?? this.status,
      cities: cities ?? this.cities,
      participantCount: participantCount ?? this.participantCount,
    );
  }
}

