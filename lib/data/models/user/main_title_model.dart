import 'package:freezed_annotation/freezed_annotation.dart';

part 'main_title_model.freezed.dart';
part 'main_title_model.g.dart';

/// 爵位模型（DTO）
///
/// 表示游戏中的爵位配置数据，包含 ID、名称、稀有度和描述。
@freezed
@JsonSerializable()
class MainTitleModel with _$MainTitleModel {
  const factory MainTitleModel({
    /// 爵位唯一标识
    required String id,

    /// 爵位名称
    required String name,

    /// 稀有度
    @Default('n') String rarity,

    /// 爵位描述
    String? description,
  }) = _MainTitleModel;

  factory MainTitleModel.fromJson(Map<String, dynamic> json) =>
      _$MainTitleModelFromJson(json);
}
