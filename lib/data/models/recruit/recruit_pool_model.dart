import 'package:freezed_annotation/freezed_annotation.dart';

part 'recruit_pool_model.freezed.dart';
part 'recruit_pool_model.g.dart';

/// 招募池数据模型（DTO）
///
/// 表示招募卡池的配置信息，包含卡池类型、保底机制和可用武将。
@freezed
@JsonSerializable()
class RecruitPoolModel with _$RecruitPoolModel {
  const factory RecruitPoolModel({
    /// 卡池唯一标识
    required String id,

    /// 卡池名称
    required String name,

    /// 卡池类型（normal/premium/limited/friendship）
    required String type,

    /// 可招募武将 ID 列表
    @Default([]) List<String> generalIds,

    /// 保底次数
    @Default(90) int pityThreshold,

    /// 消耗货币类型
    @Default('premium') String costCurrencyType,

    /// 单次消耗数量
    @Default(1) int costPerPull,

    /// 十连消耗数量
    @Default(10) int costPerTenPull,

    /// 开始时间戳（毫秒，限时卡池）
    int? startTime,

    /// 结束时间戳（毫秒，限时卡池）
    int? endTime,
  }) = _RecruitPoolModel;

  factory RecruitPoolModel.fromJson(Map<String, dynamic> json) =>
      _$RecruitPoolModelFromJson(json);
}
