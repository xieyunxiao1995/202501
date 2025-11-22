/// 邀请活动 VIP 档位配置
class InviteVipConfig {
  /// howMany 赠送天数
  final int? howMany;

  /// VIP 档位天数
  final int? vipDay;

  InviteVipConfig({this.howMany, this.vipDay});

  factory InviteVipConfig.fromJson(Map<String, dynamic> json) {
    return InviteVipConfig(howMany: json['howMany'], vipDay: json['vipDay']);
  }
}

/// 邀请页面数据
class InvitePageData {
  /// 活动 1 文案
  final String? act1Desc;

  /// 活动 2 文案
  final String? act2Desc;

  /// 收益余额
  final int? incomeBalance;

  /// 邀请背景图 URL
  final String? inviteBgUrl;

  /// 邀请码
  final String? inviteCode;

  /// 邀请获得钻石数量
  final int? inviteDiamondAmount;

  /// 邀请总收益（VIP 天数）
  final int? inviteIncome;

  /// 邀请成员人数
  final int? inviteNumber;

  /// 邀请 URL 二维码
  final String? inviteQrCodeUrl;

  /// 邀请规则
  final String? inviteRulesDesc;

  /// 邀请 URL（生成二维码）
  final String? inviteUrl;

  /// 微信公众号邀请链接
  final String? inviteUrlH5;

  /// 邀请合伙人客服二维码
  final String? partnerQRCodeUrl;

  /// 城市合伙人比例
  final int? shareRatioCity;

  /// 初级合伙人比例
  final int? shareRatioPrimary;

  /// 高级合伙人比例
  final int? shareRatioSenior;

  /// VIP 邀请档位
  final List<InviteVipConfig>? vipConfigs;

  InvitePageData({
    this.act1Desc,
    this.act2Desc,
    this.incomeBalance,
    this.inviteBgUrl,
    this.inviteCode,
    this.inviteDiamondAmount,
    this.inviteIncome,
    this.inviteNumber,
    this.inviteQrCodeUrl,
    this.inviteRulesDesc,
    this.inviteUrl,
    this.inviteUrlH5,
    this.partnerQRCodeUrl,
    this.shareRatioCity,
    this.shareRatioPrimary,
    this.shareRatioSenior,
    this.vipConfigs,
  });

  factory InvitePageData.fromJson(Map<String, dynamic> json) {
    return InvitePageData(
      act1Desc: json['act1_desc'],
      act2Desc: json['act2_desc'],
      incomeBalance: json['incomeBalance'],
      inviteBgUrl: json['inviteBgUrl'],
      inviteCode: json['inviteCode'],
      inviteDiamondAmount: json['inviteDiamondAmount'],
      inviteIncome: json['inviteIncome'],
      inviteNumber: json['inviteNumber'],
      inviteQrCodeUrl: json['inviteQrCodeUrl'],
      inviteRulesDesc: json['inviteRulesDesc'],
      inviteUrl: json['inviteUrl'],
      inviteUrlH5: json['inviteUrlH5'],
      partnerQRCodeUrl: json['partnerQRCodeUrl'],
      shareRatioCity: json['shareRatioCity'],
      shareRatioPrimary: json['shareRatioPrimary'],
      shareRatioSenior: json['shareRatioSenior'],
      vipConfigs: json['vipConfigs'] != null
          ? (json['vipConfigs'] as List)
                .map((i) => InviteVipConfig.fromJson(i))
                .toList()
          : null,
    );
  }
}

/// 邀请页面接口响应体
class InvitePageResp {
  /// 状态码
  final int code;

  /// 数据体
  final InvitePageData? data;

  /// 错误信息
  final String? message;

  InvitePageResp({required this.code, this.data, this.message});

  factory InvitePageResp.fromJson(Map<String, dynamic> json) {
    return InvitePageResp(
      code: json['code'],
      data: json['data'] != null ? InvitePageData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

/// 邀请列表请求参数
class InviteListReq {
  /// 页码
  final int pageNum;

  /// 每页数量
  final int pageSize;

  InviteListReq({required this.pageNum, required this.pageSize});

  Map<String, dynamic> toJson() {
    return {'pageNum': pageNum, 'pageSize': pageSize};
  }
}

/// 邀请成员列表项
class InviteListItem {
  /// 头像
  final String? avatar;

  /// 获得收益（VIP 天数）
  final int? income;

  /// 邀请时间
  final String? inviteTime;

  /// 性别 0 女 1 男
  final int? sex;

  /// 充值 VIP 天数
  final int? targetIncome;

  /// 昵称
  final String? userName;

  /// 显示 ID
  final int? userNumber;

  InviteListItem({
    this.avatar,
    this.income,
    this.inviteTime,
    this.sex,
    this.targetIncome,
    this.userName,
    this.userNumber,
  });

  factory InviteListItem.fromJson(Map<String, dynamic> json) {
    return InviteListItem(
      avatar: json['avatar'],
      income: json['income'],
      inviteTime: json['inviteTime'],
      sex: json['sex'],
      targetIncome: json['targetIncome'],
      userName: json['userName'],
      userNumber: json['userNumber'],
    );
  }
}

/// 邀请列表数据
class InviteListData {
  /// 是否存在下一页
  final bool? hasNext;

  /// 邀请成员列表
  final List<InviteListItem>? list;

  InviteListData({this.hasNext, this.list});

  factory InviteListData.fromJson(Map<String, dynamic> json) {
    return InviteListData(
      hasNext: json['hasNext'],
      list: json['list'] != null
          ? (json['list'] as List)
                .map((i) => InviteListItem.fromJson(i))
                .toList()
          : null,
    );
  }
}

/// 邀请列表接口响应体
class InviteListResp {
  /// 状态码
  final int code;

  /// 数据体
  final InviteListData? data;

  /// 错误信息
  final String? message;

  InviteListResp({required this.code, this.data, this.message});

  factory InviteListResp.fromJson(Map<String, dynamic> json) {
    return InviteListResp(
      code: json['code'],
      data: json['data'] != null ? InviteListData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

/// 邀请收益榜单列表项
class InviteIncomeTopItem {
  /// 用户头像
  final String? avatar;

  /// 获取收益（元）
  final double? income;

  /// 用户昵称（脱敏）
  final String? userName;

  InviteIncomeTopItem({this.avatar, this.income, this.userName});

  factory InviteIncomeTopItem.fromJson(Map<String, dynamic> json) {
    final incomeValue = json['income'];
    return InviteIncomeTopItem(
      avatar: json['avatar'],
      income: incomeValue is num ? incomeValue.toDouble() : null,
      userName: json['userName'],
    );
  }
}

/// 邀请收益榜单数据
class InviteIncomeTopData {
  /// 邀请收益列表
  final List<InviteIncomeTopItem>? list;

  InviteIncomeTopData({this.list});

  factory InviteIncomeTopData.fromJson(Map<String, dynamic> json) {
    return InviteIncomeTopData(
      list: json['list'] != null
          ? (json['list'] as List)
                .map((i) => InviteIncomeTopItem.fromJson(i))
                .toList()
          : null,
    );
  }
}

/// 绑定邀请关系请求参数
class InviteBindUserReq {
  final String mobile;
  final String bindReason;
  final String imageUrl;

  InviteBindUserReq({
    required this.mobile,
    required this.bindReason,
    required this.imageUrl,
  });

  Map<String, dynamic> toJson() {
    return {'mobile': mobile, 'bindReason': bindReason, 'imageUrl': imageUrl};
  }
}

/// 绑定邀请关系响应体 (通常只需要 code 和 message)
class InviteBindUserResp {
  final int code;
  final String? message;

  InviteBindUserResp({required this.code, this.message});

  factory InviteBindUserResp.fromJson(Map<String, dynamic> json) {
    return InviteBindUserResp(code: json['code'], message: json['message']);
  }
}

/// 邀请收益榜单响应体
class InviteIncomeTopResp {
  /// 状态码
  final int code;

  /// 数据体
  final InviteIncomeTopData? data;

  /// 错误信息
  final String? message;

  InviteIncomeTopResp({required this.code, this.data, this.message});

  factory InviteIncomeTopResp.fromJson(Map<String, dynamic> json) {
    return InviteIncomeTopResp(
      code: json['code'],
      data: json['data'] != null
          ? InviteIncomeTopData.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }
}

// ==================== 会员赠送相关 ====================

/// 权益配置项
class BenefitItem {
  /// 权益内容
  final String? benefit;

  /// 等级
  final String? level;

  BenefitItem({this.benefit, this.level});

  factory BenefitItem.fromJson(Map<String, dynamic> json) {
    return BenefitItem(
      benefit: json['benefit'],
      level: json['level'],
    );
  }
}

/// 会员赠送权益配置数据
class VipGiftBenefitConfigData {
  /// 权益配置列表
  final List<BenefitItem>? benefitList;

  /// 可赠送月会员次数
  final int? monthGiftCount;

  /// 规则列表
  final List<String>? ruleList;

  /// 可赠送周会员次数
  final int? weekGiftCount;

  VipGiftBenefitConfigData({
    this.benefitList,
    this.monthGiftCount,
    this.ruleList,
    this.weekGiftCount,
  });

  factory VipGiftBenefitConfigData.fromJson(Map<String, dynamic> json) {
    return VipGiftBenefitConfigData(
      benefitList: json['benefitList'] != null
          ? (json['benefitList'] as List)
              .map((i) => BenefitItem.fromJson(i))
              .toList()
          : null,
      monthGiftCount: json['monthGiftCount'],
      ruleList: json['ruleList'] != null
          ? (json['ruleList'] as List).map((i) => i.toString()).toList()
          : null,
      weekGiftCount: json['weekGiftCount'],
    );
  }
}

/// 会员赠送权益配置响应体
class VipGiftBenefitConfigResp {
  /// 状态码
  final int code;

  /// 数据体
  final VipGiftBenefitConfigData? data;

  /// 错误信息
  final String? message;

  VipGiftBenefitConfigResp({required this.code, this.data, this.message});

  factory VipGiftBenefitConfigResp.fromJson(Map<String, dynamic> json) {
    return VipGiftBenefitConfigResp(
      code: json['code'],
      data: json['data'] != null
          ? VipGiftBenefitConfigData.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }
}

/// 会员赠送请求参数
class VipGiftBenefitGiveReq {
  /// 赠送类型：MONTH_VIP, WEEK_VIP
  final String giftType;

  /// 接收者真遇ID
  final String toUserNumber;

  VipGiftBenefitGiveReq({
    required this.giftType,
    required this.toUserNumber,
  });

  Map<String, dynamic> toJson() {
    return {
      'giftType': giftType,
      'toUserNumber': toUserNumber,
    };
  }
}

/// 会员赠送响应体
class VipGiftBenefitGiveResp {
  /// 状态码
  final int code;

  /// 数据体
  final Map<String, dynamic>? data;

  /// 错误信息
  final String? message;

  VipGiftBenefitGiveResp({required this.code, this.data, this.message});

  factory VipGiftBenefitGiveResp.fromJson(Map<String, dynamic> json) {
    return VipGiftBenefitGiveResp(
      code: json['code'],
      data: json['data'],
      message: json['message'],
    );
  }
}

/// 获取对方用户信息请求参数
class VipGiftBenefitGetToUserInfoReq {
  /// 对方ID
  final String userNumber;

  VipGiftBenefitGetToUserInfoReq({required this.userNumber});

  Map<String, dynamic> toJson() {
    return {'userNumber': userNumber};
  }
}

/// 用户信息数据
class ToUserInfoData {
  /// 用户头像
  final String? avatar;

  /// 用户昵称
  final String? userName;

  /// 用户显示ID
  final String? userNumber;

  ToUserInfoData({this.avatar, this.userName, this.userNumber});

  factory ToUserInfoData.fromJson(Map<String, dynamic> json) {
    return ToUserInfoData(
      avatar: json['avatar'],
      userName: json['userName'],
      userNumber: json['userNumber'],
    );
  }
}

/// 获取对方用户信息响应体
class VipGiftBenefitGetToUserInfoResp {
  /// 状态码
  final int code;

  /// 数据体
  final ToUserInfoData? data;

  /// 错误信息
  final String? message;

  VipGiftBenefitGetToUserInfoResp({required this.code, this.data, this.message});

  factory VipGiftBenefitGetToUserInfoResp.fromJson(Map<String, dynamic> json) {
    return VipGiftBenefitGetToUserInfoResp(
      code: json['code'],
      data: json['data'] != null ? ToUserInfoData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

/// 会员赠送记录请求参数
class VipGiftBenefitRecordsReq {
  /// 页码
  final int pageNum;

  /// 每页数量
  final int pageSize;

  VipGiftBenefitRecordsReq({
    required this.pageNum,
    required this.pageSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'pageNum': pageNum,
      'pageSize': pageSize,
    };
  }
}

/// 会员赠送记录项
class VipGiftRecordItem {
  /// 赠送时间
  final String? createTime;

  /// 会员名称
  final String? giftVipName;

  /// 记录id
  final int? id;

  /// 接收用户头像
  final String? toAvatar;

  /// 接收用户昵称
  final String? toUserName;

  /// 接收用户id
  final String? toUserNumber;

  VipGiftRecordItem({
    this.createTime,
    this.giftVipName,
    this.id,
    this.toAvatar,
    this.toUserName,
    this.toUserNumber,
  });

  factory VipGiftRecordItem.fromJson(Map<String, dynamic> json) {
    return VipGiftRecordItem(
      createTime: json['createTime'],
      giftVipName: json['giftVipName'],
      id: json['id'],
      toAvatar: json['toAvatar'],
      toUserName: json['toUserName'],
      toUserNumber: json['toUserNumber'],
    );
  }
}

/// 会员赠送记录数据
class VipGiftBenefitRecordsData {
  /// 是否有下一页
  final bool? hasNext;

  /// 记录列表
  final List<VipGiftRecordItem>? list;

  VipGiftBenefitRecordsData({this.hasNext, this.list});

  factory VipGiftBenefitRecordsData.fromJson(Map<String, dynamic> json) {
    return VipGiftBenefitRecordsData(
      hasNext: json['hasNext'],
      list: json['list'] != null
          ? (json['list'] as List)
              .map((i) => VipGiftRecordItem.fromJson(i))
              .toList()
          : null,
    );
  }
}

/// 会员赠送记录响应体
class VipGiftBenefitRecordsResp {
  /// 状态码
  final int code;

  /// 数据体
  final VipGiftBenefitRecordsData? data;

  /// 错误信息
  final String? message;

  VipGiftBenefitRecordsResp({required this.code, this.data, this.message});

  factory VipGiftBenefitRecordsResp.fromJson(Map<String, dynamic> json) {
    return VipGiftBenefitRecordsResp(
      code: json['code'],
      data: json['data'] != null
          ? VipGiftBenefitRecordsData.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }
}
