class RealStatusResp {
  final int code;
  final RealStatusData? data;
  final String? message;

  RealStatusResp({required this.code, this.data, this.message});

  factory RealStatusResp.fromJson(Map<String, dynamic> json) {
    return RealStatusResp(
      code: json['code'],
      data: json['data'] != null ? RealStatusData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class RealStatusData {
  /// 实名状态: 0未认证 1已认证 2审核中
  final int? realNameStatus;

  RealStatusData({this.realNameStatus});

  factory RealStatusData.fromJson(Map<String, dynamic> json) {
    return RealStatusData(
      realNameStatus: json['realNameStatus'],
    );
  }
}

// --- Real Name Authentication Models ---

/// 联系方式类型枚举
enum AccountType {
  qq,
  wx,
}

extension AccountTypeExtension on AccountType {
  String toJsonValue() {
    switch (this) {
      case AccountType.qq:
        return 'QQ';
      case AccountType.wx:
        return 'WX';
    }
  }
}

/// 真人认证请求
class RealNameReq {
  /// 联系方式类型(QQ,WX)
  final AccountType? accountType;

  /// 头像URL
  final String? avatarUrl;

  /// 真人照片URL（必需）
  final String realPersonUrl;

  /// 联系方式账号
  final String? wxAccount;

  RealNameReq({
    this.accountType,
    this.avatarUrl,
    required this.realPersonUrl,
    this.wxAccount,
  });

  Map<String, dynamic> toJson() {
    return {
      if (accountType != null) 'accountType': accountType!.toJsonValue(),
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      'realPersonUrl': realPersonUrl,
      if (wxAccount != null) 'wxAccount': wxAccount,
    };
  }
}

/// 真人认证响应
class RealNameResp {
  final int code;
  final Map<String, dynamic>? data;
  final String? message;

  RealNameResp({required this.code, this.data, this.message});

  factory RealNameResp.fromJson(Map<String, dynamic> json) {
    return RealNameResp(
      code: json['code'],
      data: json['data'],
      message: json['message'],
    );
  }
}
