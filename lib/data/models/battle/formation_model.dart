import 'package:freezed_annotation/freezed_annotation.dart';

part 'formation_model.freezed.dart';
part 'formation_model.g.dart';

/// 阵法数据模型（DTO）
///
/// 表示战斗阵法配置，包含阵法类型、名称、站位和属性加成。
@freezed
@JsonSerializable()
class FormationModel with _$FormationModel {
  const factory FormationModel({
    /// 阵法唯一标识
    required String id,

    /// 阵法类型标识
    required String type,

    /// 阵法名称
    required String name,

    /// 站位配置（位置索引 -> 武将ID）
    @Default({}) Map<int, String> positions,

    /// 属性加成列表
    @Default({}) Map<String, double> bonuses,
  }) = _FormationModel;

  factory FormationModel.fromJson(Map<String, dynamic> json) =>
      _$FormationModelFromJson(json);
}
