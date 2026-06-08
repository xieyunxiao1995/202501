import 'package:freezed_annotation/freezed_annotation.dart';

part 'kingdom_rank_model.freezed.dart';
part 'kingdom_rank_model.g.dart';

/// 国战排名数据模型（DTO）
///
/// 表示国战中的阵营排名信息，包含阵营、积分和排名。
@freezed
@JsonSerializable()
class KingdomRankModel with _$KingdomRankModel {
  const factory KingdomRankModel({
    /// 排名记录唯一标识
    required String id,

    /// 阵营标识（wei/shu/wu）
    required String kingdom,

    /// 赛季编号
    required int season,

    /// 积分
    @Default(0) int score,

    /// 排名
    @Default(0) int rank,

    /// 占领城池数
    @Default(0) int citiesOccupied,

    /// 击杀总数
    @Default(0) int totalKills,
  }) = _KingdomRankModel;

  factory KingdomRankModel.fromJson(Map<String, dynamic> json) =>
      _$KingdomRankModelFromJson(json);
}
