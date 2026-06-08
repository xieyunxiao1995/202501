import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/enums/bond_type.dart' as enums;

part 'bond.freezed.dart';
part 'bond.g.dart';

/// 羁绊实体
///
/// 表示武将之间的羁绊关系，当阵容中同时上阵指定武将时激活。
/// 羁绊提供属性加成，类型涵盖桃园结义、五虎上将等经典组合。
@freezed
class Bond with _$Bond {
  const factory Bond({
    /// 羁绊唯一标识
    required String id,

    /// 羁绊名称
    required String name,

    /// 羁绊类型（桃园结义/五虎上将/五大谋士/龙凤呈祥/义结金兰/君臣之义/歃血为盟/师徒传承/亦敌亦友/血脉相连）
    required enums.BondType type,

    /// 触发所需的武将 ID 列表
    @Default([]) List<String> requiredGeneralIds,

    /// 攻击加成
    @Default(0) int atkBonus,

    /// 防御加成
    @Default(0) int defBonus,

    /// 生命加成
    @Default(0) int hpBonus,

    /// 羁绊描述
    @Default('') String description,
  }) = _Bond;

  factory Bond.fromJson(Map<String, dynamic> json) => _$BondFromJson(json);
}
