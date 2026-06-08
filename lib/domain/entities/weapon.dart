import 'package:freezed_annotation/freezed_annotation.dart';

part 'weapon.freezed.dart';
part 'weapon.g.dart';

/// 专属兵器实体
///
/// 表示武将的专属兵器，绑定特定武将使用。
/// 专属兵器拥有比普通装备更强的属性加成和特殊效果。
@freezed
class Weapon with _$Weapon {
  const factory Weapon({
    /// 兵器唯一标识
    required String id,

    /// 兵器名称
    required String name,

    /// 绑定武将 ID
    required String generalId,

    /// 攻击加成
    @Default(0) int atkBonus,

    /// 防御加成
    @Default(0) int defBonus,

    /// 生命加成
    @Default(0) int hpBonus,

    /// 速度加成
    @Default(0) int spdBonus,

    /// 兵器等级
    @Default(1) int level,

    /// 兵器最大等级
    @Default(30) int maxLevel,

    /// 特殊效果描述
    String? specialEffect,
  }) = _Weapon;

  factory Weapon.fromJson(Map<String, dynamic> json) => _$WeaponFromJson(json);
}
