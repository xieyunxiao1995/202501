import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/enums/rarity.dart' as enums;

part 'horse.freezed.dart';
part 'horse.g.dart';

/// 战马实体
///
/// 表示武将可骑乘的战马，提供属性加成和特殊技能。
/// 战马的稀有度决定了其属性上限和技能强度。
@freezed
class Horse with _$Horse {
  const factory Horse({
    /// 战马唯一标识
    required String id,

    /// 战马名称
    required String name,

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

    /// 特殊技能描述
    String? specialSkill,
  }) = _Horse;

  factory Horse.fromJson(Map<String, dynamic> json) => _$HorseFromJson(json);
}
