import 'package:freezed_annotation/freezed_annotation.dart';

part 'weapon_model.freezed.dart';
part 'weapon_model.g.dart';

/// 专属兵器数据模型（DTO）
///
/// 表示武将专属兵器数据，关联特定武将，包含属性加成和特殊效果。
@freezed
@JsonSerializable()
class WeaponModel with _$WeaponModel {
  const factory WeaponModel({
    /// 兵器唯一标识
    required String id,

    /// 兵器名称
    required String name,

    /// 所属武将 ID
    required String generalId,

    /// 攻击力加成
    @Default(0) int atk,

    /// 防御力加成
    @Default(0) int def,

    /// 生命值加成
    @Default(0) int hp,

    /// 速度加成
    @Default(0) int spd,

    /// 兵器等级
    @Default(1) int level,

    /// 特殊效果描述
    String? specialEffect,
  }) = _WeaponModel;

  factory WeaponModel.fromJson(Map<String, dynamic> json) =>
      _$WeaponModelFromJson(json);
}
