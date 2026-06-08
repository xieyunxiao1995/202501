import 'package:freezed_annotation/freezed_annotation.dart';

part 'tactic_model.freezed.dart';
part 'tactic_model.g.dart';

/// 计谋数据模型（DTO）
///
/// 表示武将可使用的计谋配置数据，包含计谋类型、触发条件、效果值和冷却时间等。
@freezed
@JsonSerializable()
class TacticModel with _$TacticModel {
  const factory TacticModel({
    /// 计谋唯一标识
    required String id,

    /// 计谋名称
    required String name,

    /// 计谋类型标识
    required String type,

    /// 计谋描述
    String? description,

    /// 触发条件描述
    String? triggerCondition,

    /// 效果值
    @Default(0) double effectValue,

    /// 冷却回合数
    @Default(0) int cooldown,
  }) = _TacticModel;

  factory TacticModel.fromJson(Map<String, dynamic> json) =>
      _$TacticModelFromJson(json);
}
