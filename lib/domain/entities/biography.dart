import 'package:freezed_annotation/freezed_annotation.dart';

part 'biography.freezed.dart';
part 'biography.g.dart';

/// 武将传记实体
///
/// 表示武将的人物传记，包含正史和演义两个维度的故事内容。
/// 传记按章节解锁，玩家可通过收集武将碎片或完成特定任务来解锁。
@freezed
class Biography with _$Biography {
  const factory Biography({
    /// 传记唯一标识
    required String id,

    /// 关联武将 ID
    required String generalId,

    /// 正史文本
    @Default('') String historyText,

    /// 演义文本
    @Default('') String romanceText,

    /// 是否已解锁
    @Default(false) bool unlocked,

    /// 已解锁的章节列表
    @Default([]) List<String> unlockedChapters,
  }) = _Biography;

  factory Biography.fromJson(Map<String, dynamic> json) =>
      _$BiographyFromJson(json);
}
