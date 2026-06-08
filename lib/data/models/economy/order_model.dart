import 'package:freezed_annotation/freezed_annotation.dart';

part 'order_model.freezed.dart';
part 'order_model.g.dart';

/// 订单数据模型（DTO）
///
/// 表示玩家的充值订单信息，包含订单号、金额和状态。
@freezed
@JsonSerializable()
class OrderModel with _$OrderModel {
  const factory OrderModel({
    /// 订单唯一标识
    required String id,

    /// 用户 ID
    required String userId,

    /// 商品 ID
    required String productId,

    /// 订单金额（分）
    required int amount,

    /// 订单状态（pending/paid/delivered/refunded）
    @Default('pending') String status,

    /// 创建时间戳（毫秒）
    @Default(0) int createdAt,

    /// 支付时间戳（毫秒）
    int? paidAt,
  }) = _OrderModel;

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
}
