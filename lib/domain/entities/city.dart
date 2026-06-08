import 'package:freezed_annotation/freezed_annotation.dart';

part 'city.freezed.dart';
part 'city.g.dart';

/// 主城实体
///
/// 表示玩家的主城，包含建筑和资源信息。
/// 主城等级决定了可建造的建筑数量和类型。
@freezed
class City with _$City {
  const factory City({
    /// 主城唯一标识
    required String id,

    /// 主城等级
    @Default(1) int level,

    /// 已建造的建筑 ID 列表
    @Default([]) List<String> buildingIds,

    /// 资源储备（资源类型名称 -> 数量）
    @Default({}) Map<String, int> resources,
  }) = _City;

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
}
