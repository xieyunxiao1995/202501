import 'package:freezed_annotation/freezed_annotation.dart';

part 'emoji_model.freezed.dart';
part 'emoji_model.g.dart';

/// 表情数据模型（DTO）
///
/// 表示聊天中可使用的表情配置，包含表情标识、名称和资源路径。
@freezed
@JsonSerializable()
class EmojiModel with _$EmojiModel {
  const factory EmojiModel({
    /// 表情唯一标识
    required String id,

    /// 表情名称
    required String name,

    /// 表情资源路径
    required String assetPath,

    /// 表情分类
    @Default('default') String category,

    /// 排序权重
    @Default(0) int sortWeight,
  }) = _EmojiModel;

  factory EmojiModel.fromJson(Map<String, dynamic> json) =>
      _$EmojiModelFromJson(json);
}
