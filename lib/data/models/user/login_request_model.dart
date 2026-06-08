import 'package:freezed_annotation/freezed_annotation.dart';

part 'login_request_model.freezed.dart';
part 'login_request_model.g.dart';

/// 登录请求模型（DTO）
///
/// 用于封装用户登录请求参数，包括用户名、密码和设备标识。
@freezed
@JsonSerializable()
class LoginRequestModel with _$LoginRequestModel {
  const factory LoginRequestModel({
    /// 用户名
    required String username,

    /// 密码
    required String password,

    /// 设备唯一标识
    required String deviceId,
  }) = _LoginRequestModel;

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);
}
