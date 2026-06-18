/// 登录请求模型（DTO）
///
/// 用于封装用户登录请求参数，包括用户名、密码和设备标识。
class LoginRequestModel {
  /// 用户名
  final String username;

  /// 密码
  final String password;

  /// 设备唯一标识
  final String deviceId;

  const LoginRequestModel({
    required this.username,
    required this.password,
    required this.deviceId,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) {
    return LoginRequestModel(
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
      deviceId: json['device_id'] as String? ?? (json['deviceId'] as String? ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
        'username': username,
        'password': password,
        'device_id': deviceId,
      };

  LoginRequestModel copyWith({
    String? username,
    String? password,
    String? deviceId,
  }) {
    return LoginRequestModel(
      username: username ?? this.username,
      password: password ?? this.password,
      deviceId: deviceId ?? this.deviceId,
    );
  }
}
