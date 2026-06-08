import 'package:freezed_annotation/freezed_annotation.dart';

part 'shop_model.freezed.dart';
part 'shop_model.g.dart';

/// 商店数据模型（DTO）
///
/// 表示游戏中的商店配置，包含商店类型、名称和商品列表。
@freezed
@JsonSerializable()
class ShopModel with _$ShopModel {
  const factory ShopModel({
    /// 商店唯一标识
    required String id,

    /// 商店名称
    required String name,

    /// 商店类型标识
    required String type,

    /// 商品 ID 列表
    @Default([]) List<String> itemIds,

    /// 刷新时间间隔（秒）
    @Default(86400) int refreshInterval,

    /// 下次刷新时间戳（毫秒）
    @Default(0) int nextRefreshTime,
  }) = _ShopModel;

  factory ShopModel.fromJson(Map<String, dynamic> json) =>
      _$ShopModelFromJson(json);
}
