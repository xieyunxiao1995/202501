import 'package:freezed_annotation/freezed_annotation.dart';

part 'lineup_model.freezed.dart';
part 'lineup_model.g.dart';

/// 出战阵容数据模型（DTO）
///
/// 表示一个出战阵容配置，包含阵容名称、武将列表、阵法关联和羁绊效果。
@freezed
@JsonSerializable()
class LineupModel with _$LineupModel {
  const factory LineupModel({
    /// 阵容唯一标识
    required String id,

    /// 阵容名称
    required String name,

    /// 武将 ID 列表（最多3位）
    @Default([]) List<String> generalIds,

    /// 关联阵法 ID
    String? formationId,

    /// 羁绊 ID 列表
    @Default([]) List<String> bondIds,
  }) = _LineupModel;

  factory LineupModel.fromJson(Map<String, dynamic> json) =>
      _$LineupModelFromJson(json);
}
