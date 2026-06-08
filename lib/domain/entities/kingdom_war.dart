import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/enums/battle_status.dart' as enums;

part 'kingdom_war.freezed.dart';
part 'kingdom_war.g.dart';

/// 国战实体
///
/// 表示三国国战中的战场信息，包含地图、城市争夺和参战人数。
/// 国战是联盟级别的 PVP 玩法，各阵营争夺城市控制权。
@freezed
class KingdomWar with _$KingdomWar {
  const factory KingdomWar({
    /// 国战唯一标识
    required String id,

    /// 地图 ID
    required String mapId,

    /// 战斗状态（空闲/准备中/战斗中/暂停/已结束）
    @Default(enums.BattleStatus.idle) enums.BattleStatus status,

    /// 战场上的城市列表（城市 ID -> 控制阵营等信息的映射）
    @Default([]) List<Map<String, dynamic>> cities,

    /// 参战人数
    @Default(0) int participantCount,
  }) = _KingdomWar;

  factory KingdomWar.fromJson(Map<String, dynamic> json) =>
      _$KingdomWarFromJson(json);
}
