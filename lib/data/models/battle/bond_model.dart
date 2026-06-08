import 'package:freezed_annotation/freezed_annotation.dart';

part 'bond_model.freezed.dart';
part 'bond_model.g.dart';

/// 羁绊数据模型（DTO）
///
/// 表示武将之间的羁绊效果配置，包含所需武将、属性加成和描述。
@freezed
@JsonSerializable()
class BondModel with _$BondModel {
  const factory BondModel({
    /// 羁绊唯一标识
    required String id,

    /// 羁绊名称
    required String name,

    /// 羁绊类型标识
    required String type,

    /// 所需武将 ID 列表
    @Default([]) List<String> requiredGeneralIds,

    /// 攻击加成
    @Default(0) int atk,

    /// 防御加成
    @Default(0) int def,

    /// 生命加成
    @Default(0) int hp,

    /// 羁绊描述
    String? description,
  }) = _BondModel;

  factory BondModel.fromJson(Map<String, dynamic> json) =>
      _$BondModelFromJson(json);
}
