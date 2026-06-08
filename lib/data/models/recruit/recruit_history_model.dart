import 'package:freezed_annotation/freezed_annotation.dart';

part 'recruit_history_model.freezed.dart';
part 'recruit_history_model.g.dart';

/// 招募历史数据模型（DTO）
///
/// 表示玩家的招募历史记录，包含卡池、次数和结果列表。
@freezed
@JsonSerializable()
class RecruitHistoryModel with _$RecruitHistoryModel {
  const factory RecruitHistoryModel({
    /// 历史记录唯一标识
    required String id,

    /// 卡池 ID
    required String poolId,

    /// 总招募次数
    @Default(0) int totalPulls,

    /// 结果 ID 列表
    @Default([]) List<String> resultIds,
  }) = _RecruitHistoryModel;

  factory RecruitHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$RecruitHistoryModelFromJson(json);
}
