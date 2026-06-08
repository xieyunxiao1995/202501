import 'package:freezed_annotation/freezed_annotation.dart';

part 'chapter_model.freezed.dart';
part 'chapter_model.g.dart';

/// 章节数据模型（DTO）
///
/// 表示游戏中的一个章节，包含章节名称、排序和包含的关卡列表。
@freezed
@JsonSerializable()
class ChapterModel with _$ChapterModel {
  const factory ChapterModel({
    /// 章节唯一标识
    required String id,

    /// 章节名称
    required String name,

    /// 章节排序序号
    @Default(0) int order,

    /// 关卡 ID 列表
    @Default([]) List<String> stageIds,

    /// 章节描述
    String? description,

    /// 是否已解锁
    @Default(false) bool unlocked,
  }) = _ChapterModel;

  factory ChapterModel.fromJson(Map<String, dynamic> json) =>
      _$ChapterModelFromJson(json);
}
