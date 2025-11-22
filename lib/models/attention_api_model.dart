class LookMeListReq {
  final int pageNum;
  final int pageSize;

  const LookMeListReq({this.pageNum = 1, this.pageSize = 20});

  Map<String, dynamic> toJson() => {'pageNum': pageNum, 'pageSize': pageSize};
}

class LookMeListResp {
  final int code;
  final String? message;
  final LookMeData? data;

  LookMeListResp({required this.code, this.message, this.data});

  factory LookMeListResp.fromJson(Map<String, dynamic> json) => LookMeListResp(
    code: json['code'] as int? ?? -1,
    message: json['message'] as String?,
    data: json['data'] != null
        ? LookMeData.fromJson(json['data'] as Map<String, dynamic>)
        : null,
  );
}

class LookMeData {
  final int vip;
  final int vipMaturityDays;
  final int totalCount;
  final bool hasNext;
  final double? distance;
  final List<LookMeVisitor> visitors;

  const LookMeData({
    required this.vip,
    required this.vipMaturityDays,
    required this.totalCount,
    required this.hasNext,
    required this.distance,
    required this.visitors,
  });

  bool get isVip => vip == 1;

  LookMeData copyWith({
    int? vip,
    int? vipMaturityDays,
    int? totalCount,
    bool? hasNext,
    double? distance,
    List<LookMeVisitor>? visitors,
  }) {
    return LookMeData(
      vip: vip ?? this.vip,
      vipMaturityDays: vipMaturityDays ?? this.vipMaturityDays,
      totalCount: totalCount ?? this.totalCount,
      hasNext: hasNext ?? this.hasNext,
      distance: distance ?? this.distance,
      visitors: List<LookMeVisitor>.from(visitors ?? this.visitors),
    );
  }

  factory LookMeData.fromJson(Map<String, dynamic> json) {
    final rawList =
        json['list'] as List<dynamic>? ??
        json['visitors'] as List<dynamic>? ??
        [];
    return LookMeData(
      vip: json['vip'] as int? ?? 0,
      vipMaturityDays: json['vipMaturityDays'] as int? ?? 0,
      totalCount: json['totalCount'] as int? ?? rawList.length,
      hasNext: json['hasNext'] as bool? ?? false,
      distance: (json['distance'] as num?)?.toDouble(),
      visitors: rawList
          .map((item) => LookMeVisitor.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class LookMeVisitor {
  final String uid;
  final String? avatar;
  final String? userName;
  final int sex;
  final int age;
  final String? city;
  final int realType;
  final int vip;
  final String? createTime;
  final double? latitude;
  final double? longitude;
  final String? lookTimeFormat;

  const LookMeVisitor({
    required this.uid,
    this.avatar,
    this.userName,
    required this.sex,
    required this.age,
    this.city,
    required this.realType,
    required this.vip,
    this.createTime,
    this.latitude,
    this.longitude,
    this.lookTimeFormat,
  });

  factory LookMeVisitor.fromJson(Map<String, dynamic> json) => LookMeVisitor(
    uid: (json['uid'] ?? json['userId'] ?? '').toString(),
    avatar: json['avatar'] as String?,
    userName: json['userName'] as String? ?? json['nickname'] as String?,
    sex: json['sex'] as int? ?? 0,
    age: json['age'] as int? ?? 0,
    city: json['city'] as String?,
    realType: json['realType'] as int? ?? 0,
    vip: json['vip'] as int? ?? 0,
    createTime: json['createTime'] as String?,
    latitude: (json['latitude'] as num?)?.toDouble(),
    longitude: (json['longitude'] as num?)?.toDouble(),
    lookTimeFormat:
        json['lookTimeFormat'] as String? ?? json['time'] as String?,
  );
}

class LikeListReq {
  final int pageNum;
  final int pageSize;
  final String type;

  LikeListReq({
    required this.pageNum,
    required this.pageSize,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {'pageNum': pageNum, 'pageSize': pageSize, 'type': type};
  }
}

class LikeListResp {
  final int code;
  final String message;
  final LikeListData? data;

  LikeListResp({required this.code, required this.message, this.data});

  factory LikeListResp.fromJson(Map<String, dynamic> json) {
    return LikeListResp(
      code: json['code'] ?? 0,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? LikeListData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class LikeListData {
  final int distance;
  final bool hasNext;
  final List<AttentionUserInfo> list;
  final int totalCount;
  final int vip;
  final int vipMaturityDays;

  LikeListData({
    required this.distance,
    required this.hasNext,
    required this.list,
    required this.totalCount,
    required this.vip,
    required this.vipMaturityDays,
  });

  factory LikeListData.fromJson(Map<String, dynamic> json) {
    return LikeListData(
      distance: json['distance'] ?? 0,
      hasNext: json['hasNext'] ?? false,
      list:
          (json['list'] as List<dynamic>?)
              ?.map(
                (e) => AttentionUserInfo.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          [],
      totalCount: json['totalCount'] ?? 0,
      vip: json['vip'] ?? 0,
      vipMaturityDays: json['vipMaturityDays'] ?? 0,
    );
  }
}

class AttentionUserInfo {
  final int age;
  final String avatar;
  final String city;
  final String createTime;
  final double latitude;
  final double longitude;
  final String lookTimeFormat;
  final int realType;
  final int sex;
  final int uid;
  final String userName;
  final int vip;

  AttentionUserInfo({
    required this.age,
    required this.avatar,
    required this.city,
    required this.createTime,
    required this.latitude,
    required this.longitude,
    required this.lookTimeFormat,
    required this.realType,
    required this.sex,
    required this.uid,
    required this.userName,
    required this.vip,
  });

  factory AttentionUserInfo.fromJson(Map<String, dynamic> json) {
    return AttentionUserInfo(
      age: json['age'] ?? 0,
      avatar: json['avatar'] ?? '',
      city: json['city'] ?? '',
      createTime: json['createTime'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      lookTimeFormat: json['lookTimeFormat'] ?? '',
      realType: json['realType'] ?? 0,
      sex: json['sex'] ?? 0,
      uid: json['uid'] ?? 0,
      userName: json['userName'] ?? '',
      vip: json['vip'] ?? 0,
    );
  }
}
