import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/enums/formation_type.dart' as enums;

part 'formation.freezed.dart';
part 'formation.g.dart';

/// 阵法实体
///
/// 表示战斗中的阵法配置，不同阵法提供不同位置的属性加成。
/// 阵法类型决定了加成的分布方式，影响战斗策略。
@freezed
class Formation with _$Formation {
  const factory Formation({
    /// 阵法唯一标识
    required String id,

    /// 阵法类型（长蛇阵/双龙出水阵/三才阵/四象阵/五行阵/六合阵/七星阵/八卦阵/九宫阵）
    required enums.FormationType type,

    /// 阵法名称
    required String name,

    /// 阵法描述
    @Default('') String description,

    /// 各位置加成（位置索引 -> 攻击/防御/速度加成）
    @Default({}) Map<int, PositionBonus> positionBonuses,
  }) = _Formation;

  factory Formation.fromJson(Map<String, dynamic> json) =>
      _$FormationFromJson(json);
}

/// 位置加成
///
/// 表示阵法中某一位置的属性加成值。
@freezed
class PositionBonus with _$PositionBonus {
  const factory PositionBonus({
    /// 攻击加成
    @Default(0) int atk,

    /// 防御加成
    @Default(0) int def,

    /// 速度加成
    @Default(0) int spd,
  }) = _PositionBonus;

  factory PositionBonus.fromJson(Map<String, dynamic> json) =>
      _$PositionBonusFromJson(json);
}
