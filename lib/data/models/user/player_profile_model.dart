import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_profile_model.freezed.dart';
part 'player_profile_model.g.dart';

/// 玩家档案模型（DTO）
///
/// 用于展示玩家个人档案信息，包含用户ID、昵称、等级、VIP、爵位和阵营。
@freezed
@JsonSerializable()
class PlayerProfileModel with _$PlayerProfileModel {
  const factory PlayerProfileModel({
    /// 用户 ID
    required String userId,

    /// 昵称
    required String nickname,

    /// 等级
    @Default(1) int level,

    /// VIP 等级
    @Default(0) int vip,

    /// 爵位标识
    @Default('commoner') String title,

    /// 所属阵营标识
    String? kingdom,
  }) = _PlayerProfileModel;

  factory PlayerProfileModel.fromJson(Map<String, dynamic> json) =>
      _$PlayerProfileModelFromJson(json);
}
