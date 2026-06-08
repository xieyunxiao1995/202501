import 'package:freezed_annotation/freezed_annotation.dart';
import 'user_model.dart';

part 'login_response_model.freezed.dart';
part 'login_response_model.g.dart';

/// 登录响应模型（DTO）
///
/// 封装登录接口返回数据，包含访问令牌、刷新令牌和用户信息。
@freezed
@JsonSerializable()
class LoginResponseModel with _$LoginResponseModel {
  const factory LoginResponseModel({
    /// 访问令牌
    required String token,

    /// 刷新令牌
    required String refreshToken,

    /// 用户信息
    required UserModel user,
  }) = _LoginResponseModel;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
}
