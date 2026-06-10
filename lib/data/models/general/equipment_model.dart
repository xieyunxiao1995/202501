import 'package:freezed_annotation/freezed_annotation.dart';

part 'equipment_model.freezed.dart';
part 'equipment_model.g.dart';

/// 装备数据模型（DTO）
///
/// 表示武将可穿戴的装备数据，包含装备类型、稀有度和各项属性加成。
@freezed
class EquipmentModel with _$EquipmentModel {
  const factory EquipmentModel({
    /// 装备唯一标识
    required String id,

    /// 装备名称
    required String name,

    /// 装备类型标识
    required String type,

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

    /// 装备等级
    @Default(1) int level,
  }) = _EquipmentModel;

  factory EquipmentModel.fromJson(Map<String, dynamic> json) =>
      _$EquipmentModelFromJson(json);
}
