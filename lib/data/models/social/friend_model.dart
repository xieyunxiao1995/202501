import 'package:freezed_annotation/freezed_annotation.dart';

part 'friend_model.freezed.dart';
part 'friend_model.g.dart';

/// 好友数据模型（DTO）
///
/// 表示好友列表中的好友信息，包含好友基本信息和在线状态。
@freezed
@JsonSerializable()
class FriendModel with _$FriendModel {
  const factory FriendModel({
    /// 好友用户 ID
    required String userId,

    /// 好友昵称
    required String nickname,

    /// 好友等级
    @Default(1) int level,

    /// 是否在线
    @Default(false) bool online,

    /// 最后上线时间戳（毫秒）
    @Default(0) int lastOnlineTime,

    /// 亲密度
    @Default(0) int intimacy,

    /// 头像路径
    String? avatar,
  }) = _FriendModel;

  factory FriendModel.fromJson(Map<String, dynamic> json) =>
      _$FriendModelFromJson(json);
}
