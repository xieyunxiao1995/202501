class UserSessionBatchReq {
  final String uid;

  UserSessionBatchReq({required this.uid});

  Map<String, dynamic> toJson() => {'uid': uid};
}

class UserSessionInfo {
  final int? realType;
  final int? uid;
  final int? vip;

  UserSessionInfo({this.realType, this.uid, this.vip});

  factory UserSessionInfo.fromJson(Map<String, dynamic> json) {
    return UserSessionInfo(
      realType: json['realType'],
      uid: json['uid'],
      vip: json['vip'],
    );
  }
}

class UserSessionBatchData {
  final List<UserSessionInfo>? userList;

  UserSessionBatchData({this.userList});

  factory UserSessionBatchData.fromJson(Map<String, dynamic> json) {
    return UserSessionBatchData(
      userList: json['userList'] != null
          ? (json['userList'] as List)
              .map((item) => UserSessionInfo.fromJson(item))
              .toList()
          : null,
    );
  }
}

class UserSessionBatchResp {
  final int code;
  final UserSessionBatchData? data;
  final String? message;

  UserSessionBatchResp({required this.code, this.data, this.message});

  factory UserSessionBatchResp.fromJson(Map<String, dynamic> json) {
    return UserSessionBatchResp(
      code: json['code'],
      data: json['data'] != null
          ? UserSessionBatchData.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }
}
