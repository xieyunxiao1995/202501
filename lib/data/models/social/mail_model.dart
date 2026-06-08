import 'package:freezed_annotation/freezed_annotation.dart';

part 'mail_model.freezed.dart';
part 'mail_model.g.dart';

/// 邮件数据模型（DTO）
///
/// 表示玩家收到的邮件，包含邮件标题、内容、附件和读取状态。
@freezed
@JsonSerializable()
class MailModel with _$MailModel {
  const factory MailModel({
    /// 邮件唯一标识
    required String id,

    /// 邮件标题
    required String title,

    /// 邮件内容
    required String content,

    /// 发送者名称
    @Default('系统') String sender,

    /// 是否已读
    @Default(false) bool read,

    /// 是否已领取附件
    @Default(false) bool claimed,

    /// 附件列表（物品ID -> 数量）
    @Default({}) Map<String, int> attachments,

    /// 发送时间戳（毫秒）
    @Default(0) int sentAt,

    /// 过期时间戳（毫秒）
    @Default(0) int expireAt,
  }) = _MailModel;

  factory MailModel.fromJson(Map<String, dynamic> json) =>
      _$MailModelFromJson(json);
}
