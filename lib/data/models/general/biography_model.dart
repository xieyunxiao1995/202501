import 'package:freezed_annotation/freezed_annotation.dart';

part 'biography_model.freezed.dart';
part 'biography_model.g.dart';

/// 武将传记数据模型（DTO）
///
/// 表示武将传记内容，包含历史文本、演义文本、解锁状态和章节列表。
@freezed
@JsonSerializable()
class BiographyModel with _$BiographyModel {
  const factory BiographyModel({
    /// 传记唯一标识
    required String id,

    /// 所属武将 ID
    required String generalId,

    /// 历史传记文本
    String? historyText,

    /// 演义传记文本
    String? romanceText,

    /// 是否已解锁
    @Default(false) bool unlocked,

    /// 章节列表
    @Default([]) List<String> chapters,
  }) = _BiographyModel;

  factory BiographyModel.fromJson(Map<String, dynamic> json) =>
      _$BiographyModelFromJson(json);
}
