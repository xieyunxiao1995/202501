import 'package:freezed_annotation/freezed_annotation.dart';
import '../../shared/enums/item_type.dart' as enums;
import '../../shared/enums/rarity.dart' as enums;

part 'item.freezed.dart';
part 'item.g.dart';

/// 道具实体
///
/// 表示游戏中的各类道具，包括材料、经验书、进阶石、招贤令等。
/// 道具可堆叠，通过数量字段记录持有量。
@freezed
class Item with _$Item {
  const factory Item({
    /// 道具唯一标识
    required String id,

    /// 道具名称
    required String name,

    /// 道具类型（材料/经验书/进阶石/觉醒石/招贤令/装备材料/礼物/宝箱）
    required enums.ItemType type,

    /// 稀有度
    required enums.Rarity rarity,

    /// 持有数量
    @Default(0) int quantity,

    /// 道具描述
    @Default('') String description,

    /// 图标路径
    String? iconPath,
  }) = _Item;

  factory Item.fromJson(Map<String, dynamic> json) => _$ItemFromJson(json);
}
