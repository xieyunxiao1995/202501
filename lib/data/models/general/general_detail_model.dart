import 'package:freezed_annotation/freezed_annotation.dart';
import 'general_model.dart';
import 'equipment_model.dart';
import 'weapon_model.dart';
import 'horse_model.dart';

part 'general_detail_model.freezed.dart';
part 'general_detail_model.g.dart';

/// 武将详情模型（DTO）
///
/// 武将的完整详情信息，包含基础武将数据及装备、专属兵器、战马、羁绊等。
@freezed
@JsonSerializable()
class GeneralDetailModel with _$GeneralDetailModel {
  const factory GeneralDetailModel({
    /// 基础武将信息
    required GeneralModel general,

    /// 装备信息
    EquipmentModel? equipment,

    /// 专属兵器信息
    WeaponModel? weapon,

    /// 战马信息
    HorseModel? horse,

    /// 羁绊 ID 列表
    @Default([]) List<String> bondIds,
  }) = _GeneralDetailModel;

  factory GeneralDetailModel.fromJson(Map<String, dynamic> json) =>
      _$GeneralDetailModelFromJson(json);
}
