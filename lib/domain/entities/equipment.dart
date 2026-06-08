import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/enums/item_type.dart' as enums;
import '../../shared/enums/rarity.dart' as enums;

part 'equipment.freezed.dart';
part 'equipment.g.dart';

/// 装备实体
///
/// 表示武将可穿戴的装备，提供攻击、防御、生命、速度等属性加成。
/// 装备可组成套装，获得额外效果。
@freezed
class Equipment with _$Equipment {
  const factory Equipment({
    /// 装备唯一标识
    required String id,

    /// 装备名称
    required String name,

    /// 道具类型
    required enums.ItemType type,

    /// 稀有度
    required enums.Rarity rarity,

    /// 攻击加成
    @Default(0) int atkBonus,

    /// 防御加成
    @Default(0) int defBonus,

    /// 生命加成
    @Default(0) int hpBonus,

    /// 速度加成
    @Default(0) int spdBonus,

    /// 装备等级
    @Default(1) int level,

    /// 套装描述
    String? setDescription,
  }) = _Equipment;

  factory Equipment.fromJson(Map<String, dynamic> json) =>
      _$EquipmentFromJson(json);
}
