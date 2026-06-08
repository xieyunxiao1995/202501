import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency_model.freezed.dart';
part 'currency_model.g.dart';

/// 货币数据模型（DTO）
///
/// 表示玩家持有的各类货币数量，如金币、元宝、美玉等。
@freezed
@JsonSerializable()
class CurrencyModel with _$CurrencyModel {
  const factory CurrencyModel({
    /// 货币类型标识
    required String type,

    /// 当前数量
    @Default(0) int amount,
  }) = _CurrencyModel;

  factory CurrencyModel.fromJson(Map<String, dynamic> json) =>
      _$CurrencyModelFromJson(json);
}
