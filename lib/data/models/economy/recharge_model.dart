import 'package:freezed_annotation/freezed_annotation.dart';

part 'recharge_model.freezed.dart';
part 'recharge_model.g.dart';

/// 充值商品数据模型（DTO）
///
/// 表示可充值的商品配置，包含价格、元宝数量和首充奖励信息。
@freezed
@JsonSerializable()
class RechargeModel with _$RechargeModel {
  const factory RechargeModel({
    /// 商品唯一标识
    required String id,

    /// 商品名称
    required String name,

    /// 价格（分）
    required int price,

    /// 获得元宝数量
    required int premiumAmount,

    /// 是否首充奖励已领取
    @Default(false) bool firstBonusClaimed,

    /// 首充额外奖励（物品ID -> 数量）
    @Default({}) Map<String, int> firstBonusItems,

    /// 排序权重
    @Default(0) int sortWeight,
  }) = _RechargeModel;

  factory RechargeModel.fromJson(Map<String, dynamic> json) =>
      _$RechargeModelFromJson(json);
}
