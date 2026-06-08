import 'package:freezed_annotation/freezed_annotation.dart';

part 'lineup.freezed.dart';
part 'lineup.g.dart';

/// 阵容实体
///
/// 表示战斗阵容配置，由武将列表、阵法和羁绊组成。
/// 阵容决定了战斗中武将的站位和配合效果。
@freezed
class Lineup with _$Lineup {
  const factory Lineup({
    /// 阵容唯一标识
    required String id,

    /// 阵容名称
    required String name,

    /// 武将 ID 列表（最多 6 位武将）
    @Default([]) List<String> generalIds,

    /// 使用的阵法 ID
    String? formationId,

    /// 激活的羁绊 ID 列表
    @Default([]) List<String> bondIds,
  }) = _Lineup;

  factory Lineup.fromJson(Map<String, dynamic> json) => _$LineupFromJson(json);
}
