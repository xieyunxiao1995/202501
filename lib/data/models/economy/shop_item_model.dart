import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_item_model.freezed.dart';
part 'shop_item_model.g.dart';

/// 商店商品数据模型（DTO）
///
/// 表示商店中的单个商品，包含价格、限购和折扣信息。
@freezed
@JsonSerializable()
class ShopItemModel with _$ShopItemModel {
  const factory ShopItemModel({
    /// 商品唯一标识
    required String id,

    /// 商品名称
    required String name,

    /// 物品 ID
    required String itemId,

    /// 价格
    required int price,

    /// 货币类型标识
    required String currencyType,

    /// 限购数量（0表示不限购）
    @Default(0) int purchaseLimit,

    /// 已购买数量
    @Default(0) int purchased,

    /// 折扣比例（0.0-1.0，1.0为无折扣）
    @Default(1.0) double discount,

    /// 是否在售
    @Default(true) bool available,
  }) = _ShopItemModel;

  factory ShopItemModel.fromJson(Map<String, dynamic> json) =>
      _$ShopItemModelFromJson(json);
}
