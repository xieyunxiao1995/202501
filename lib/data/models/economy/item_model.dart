import 'package:freezed_annotation/freezed_annotation.dart';

part 'item_model.freezed.dart';
part 'item_model.g.dart';

/// 道具数据模型（DTO）
///
/// 表示游戏中的道具配置，包含道具类型、稀有度和描述。
@freezed
@JsonSerializable()
class ItemModel with _$ItemModel {
  const factory ItemModel({
    /// 道具唯一标识
    required String id,

    /// 道具名称
    required String name,

    /// 道具类型标识
    required String type,

    /// 稀有度标识
    @Default('n') String rarity,

    /// 道具描述
    String? description,

    /// 拥有数量
    @Default(0) int count,

    /// 是否可使用
    @Default(false) bool usable,

    /// 图标路径
    String? icon,
  }) = _ItemModel;

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);
}
