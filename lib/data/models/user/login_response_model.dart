import 'user_model.dart';

/// 登录响应模型（DTO）
///
/// 封装登录接口返回数据，包含访问令牌、刷新令牌和用户信息。
class LoginResponseModel {
  /// 访问令牌
  final String token;

  /// 刷新令牌
  final String refreshToken;

  /// 用户信息
  final UserModel user;

  const LoginResponseModel({
    required this.token,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] as String? ?? '',
      refreshToken: json['refresh_token'] as String? ?? (json['refreshToken'] as String? ?? ''),
      user: json['user'] != null
          ? UserModel.fromJson(json['user'] as Map<String, dynamic>)
          : UserModel(id: '', name: ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'token': token,
        'refresh_token': refreshToken,
        'user': user.toJson(),
      };

  LoginResponseModel copyWith({
    String? token,
    String? refreshToken,
    UserModel? user,
  }) {
    return LoginResponseModel(
      token: token ?? this.token,
      refreshToken: refreshToken ?? this.refreshToken,
      user: user ?? this.user,
    );
  }
}
