import 'package:freezed_annotation/freezed_annotation.dart';

part 'horse_model.freezed.dart';
part 'horse_model.g.dart';

/// 战马数据模型（DTO）
///
/// 表示武将可骑乘的战马数据，包含稀有度、属性加成和特殊技能。
@freezed
@JsonSerializable()
class HorseModel with _$HorseModel {
  const factory HorseModel({
    /// 战马唯一标识
    required String id,

    /// 战马名称
    required String name,

    /// 稀有度标识
    required String rarity,

    /// 攻击力加成
    @Default(0) int atk,

    /// 防御力加成
    @Default(0) int def,

    /// 生命值加成
    @Default(0) int hp,

    /// 速度加成
    @Default(0) int spd,

    /// 特殊技能描述
    String? specialSkill,
  }) = _HorseModel;

  factory HorseModel.fromJson(Map<String, dynamic> json) =>
      _$HorseModelFromJson(json);
}
