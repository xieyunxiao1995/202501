import 'package:freezed_annotation/freezed_annotation.dart';

part 'general_model.freezed.dart';
part 'general_model.g.dart';

/// 武将数据模型（DTO）
///
/// 对应 [General] 实体，面向 API 契约的武将数据传输对象。
/// 包含武将基础属性、阵营、职业、稀有度、星级、等级、战斗属性等。
@freezed
@JsonSerializable()
class GeneralModel with _$GeneralModel {
  const factory GeneralModel({
    /// 武将唯一标识
    required String id,

    /// 武将名称
    required String name,

    /// 所属阵营标识（wei/shu/wu/qun/jin/female）
    required String kingdom,

    /// 职业标识（berserker/guardian/warSage/assassin/strategist/support/trickster）
    required String profession,

    /// 稀有度标识（n/r/sr/ssr/ur/legendary）
    required String rarity,

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

    /// 是否已觉醒
    @Default(false) bool isAwakened,

    /// 战力值
    @Default(0) int power,
  }) = _GeneralModel;

  factory GeneralModel.fromJson(Map<String, dynamic> json) =>
      _$GeneralModelFromJson(json);
}
