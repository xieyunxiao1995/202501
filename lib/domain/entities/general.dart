import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/enums/kingdom.dart' as enums;
import '../../shared/enums/profession.dart' as enums;
import '../../shared/enums/rarity.dart' as enums;

part 'general.freezed.dart';
part 'general.g.dart';

/// 武将实体
///
/// 表示游戏中的武将角色，包含基础属性、阵营、职业、稀有度等信息。
/// 武将是战斗的核心单位，可装备兵器、战马，拥有技能和计谋。
@freezed
class General with _$General {
  const factory General({
    /// 武将唯一标识
    required String id,

    /// 武将名称
    required String name,

    /// 所属阵营（魏/蜀/吴/群/晋/女将）
    required enums.Kingdom kingdom,

    /// 职业类型（猛将/守将/武圣/刺客/军师/辅助/奇谋）
    required enums.Profession profession,

    /// 稀有度（普通/稀有/史诗/传说/至尊/绝世）
    required enums.Rarity rarity,

    /// 星级（1-7）
    @Default(1) int star,

    /// 等级
    @Default(1) int level,

    /// 攻击力
    @Default(0) int atk,

    /// 防御力
    @Default(0) int def,

    /// 生命值
    @Default(0) int hp,

    /// 速度
    @Default(0) int spd,

    /// 技能 ID 列表
    @Default([]) List<String> skillIds,

    /// 计谋 ID
    String? tacticId,

    /// 装备 ID
    String? equipmentId,

    /// 专属兵器 ID
    String? weaponId,

    /// 战马 ID
    String? horseId,

    /// 羁绊 ID 列表
    @Default([]) List<String> bondIds,

    /// 是否已觉醒
    @Default(false) bool isAwakened,

    /// 战力值
    @Default(0) int power,
  }) = _General;

  factory General.fromJson(Map<String, dynamic> json) =>
      _$GeneralFromJson(json);
}
