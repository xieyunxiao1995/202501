import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_message_model.freezed.dart';
part 'chat_message_model.g.dart';

/// 聊天消息数据模型（DTO）
///
/// 表示聊天频道中的单条消息，包含发送者、内容和时间戳。
@freezed
@JsonSerializable()
class ChatMessageModel with _$ChatMessageModel {
  const factory ChatMessageModel({
    /// 消息唯一标识
    required String id,

    /// 发送者 ID
    required String senderId,

    /// 发送者昵称
    required String senderName,

    /// 消息内容
    required String content,

    /// 频道类型（world/alliance/private/system）
    required String channel,

    /// 发送时间戳（毫秒）
    @Default(0) int timestamp,

    /// 发送者头像
    String? senderAvatar,
  }) = _ChatMessageModel;

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);
}
