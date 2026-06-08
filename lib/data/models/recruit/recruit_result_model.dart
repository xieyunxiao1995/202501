import 'package:freezed_annotation/freezed_annotation.dart';

part 'recruit_result_model.freezed.dart';
part 'recruit_result_model.g.dart';

/// 招募结果数据模型（DTO）
///
/// 表示单次招募的结果，包含获得的武将或物品信息。
@freezed
@JsonSerializable()
class RecruitResultModel with _$RecruitResultModel {
  const factory RecruitResultModel({
    /// 结果唯一标识
    required String id,

    /// 卡池 ID
    required String poolId,

    /// 获得类型（general/item/fragment）
    required String resultType,

    /// 获得物品 ID
    required String itemId,

    /// 获得数量
    @Default(1) int count,

    /// 稀有度标识
    required String rarity,

    /// 是否为新获得
    @Default(false) bool isNew,

    /// 招募时间戳（毫秒）
    @Default(0) int timestamp,
  }) = _RecruitResultModel;

  factory RecruitResultModel.fromJson(Map<String, dynamic> json) =>
      _$RecruitResultModelFromJson(json);
}
