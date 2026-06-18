import 'general_model.dart';
import 'equipment_model.dart';
import 'weapon_model.dart';
import 'horse_model.dart';

/// 武将详情模型（DTO）
///
/// 武将的完整详情信息，包含基础武将数据及装备、专属兵器、战马、羁绊等。
class GeneralDetailModel {
  /// 基础武将信息
  final GeneralModel general;

  /// 装备信息
  final EquipmentModel? equipment;

  /// 专属兵器信息
  final WeaponModel? weapon;

  /// 战马信息
  final HorseModel? horse;

  /// 羁绊 ID 列表
  final List<String> bondIds;

  const GeneralDetailModel({
    required this.general,
    this.equipment,
    this.weapon,
    this.horse,
    this.bondIds = const [],
  });

  factory GeneralDetailModel.fromJson(Map<String, dynamic> json) {
    return GeneralDetailModel(
      general: GeneralModel.fromJson(json['general'] as Map<String, dynamic>),
      equipment: json['equipment'] != null
          ? EquipmentModel.fromJson(json['equipment'] as Map<String, dynamic>)
          : null,
      weapon: json['weapon'] != null
          ? WeaponModel.fromJson(json['weapon'] as Map<String, dynamic>)
          : null,
      horse: json['horse'] != null
          ? HorseModel.fromJson(json['horse'] as Map<String, dynamic>)
          : null,
      bondIds: (json['bondIds'] as List<dynamic>?)
              ?.map((e) => e as String).toList() ??
          const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'general': general.toJson(),
        if (equipment != null) 'equipment': equipment!.toJson(),
        if (weapon != null) 'weapon': weapon!.toJson(),
        if (horse != null) 'horse': horse!.toJson(),
        'bondIds': bondIds,
      };

  GeneralDetailModel copyWith({
    GeneralModel? general,
    EquipmentModel? equipment,
    WeaponModel? weapon,
    HorseModel? horse,
    List<String>? bondIds,
  }) {
    return GeneralDetailModel(
      general: general ?? this.general,
      equipment: equipment ?? this.equipment,
      weapon: weapon ?? this.weapon,
      horse: horse ?? this.horse,
      bondIds: bondIds ?? this.bondIds,
    );
  }
}
