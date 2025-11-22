/// 钻石兑换配置列表项
class DiamondExchangeConfigItem {
  /// 配置ID
  final int? id;

  /// 兑换数量
  final int? exchangeAmount;

  /// 消耗的收益数量
  final int? incomeAmount;

  /// 赠送数量（有些返回会包含该字段）
  final int? giveAmount;

  /// 标签标识（有些返回会包含该字段）
  final int? tag;

  DiamondExchangeConfigItem({
    this.id,
    this.exchangeAmount,
    this.incomeAmount,
    this.giveAmount,
    this.tag,
  });

  factory DiamondExchangeConfigItem.fromJson(Map<String, dynamic> json) {
    return DiamondExchangeConfigItem(
      id: json['id'],
      exchangeAmount: json['exchangeAmount'],
      incomeAmount: json['incomeAmount'],
      giveAmount: json['giveAmount'],
      tag: json['tag'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'exchangeAmount': exchangeAmount,
      'incomeAmount': incomeAmount,
      'giveAmount': giveAmount,
      'tag': tag,
    };
  }
}

/// 提现待审记录
class DiamondWithdrawReviewItem {
  /// 审核记录 ID
  final int? id;

  /// 提交时间
  final String? createTime;

  /// 提现金额
  final num? money;

  DiamondWithdrawReviewItem({this.id, this.createTime, this.money});

  factory DiamondWithdrawReviewItem.fromJson(Map<String, dynamic> json) {
    return DiamondWithdrawReviewItem(
      id: json['id'],
      createTime: json['createTime'],
      money: json['money'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'createTime': createTime, 'money': money};
  }
}

/// 钻石提现配置数据体
class DiamondWithdrawConfigData {
  /// 可提现钻石数量
  final num? availableDiamond;

  /// 钻石余额
  final num? diamond;

  /// 真实姓名
  final String? realName;

  /// 提现待审列表
  final List<DiamondWithdrawReviewItem>? reviewList;

  /// 提现手续费 6%
  final String? serviceRate;

  /// 钻石兑换比例 例如100 = 1元等于100钻石
  final int? shellRate;

  /// 支付宝账号
  final String? zfbAccount;

  /// 支付宝手机号
  final String? zfbMobile;

  DiamondWithdrawConfigData({
    this.availableDiamond,
    this.diamond,
    this.realName,
    this.reviewList,
    this.serviceRate,
    this.shellRate,
    this.zfbAccount,
    this.zfbMobile,
  });

  factory DiamondWithdrawConfigData.fromJson(Map<String, dynamic> json) {
    return DiamondWithdrawConfigData(
      availableDiamond: json['availableDiamond'],
      diamond: json['diamond'],
      realName: json['realName'],
      reviewList: json['reviewList'] != null
          ? (json['reviewList'] as List)
                .map((e) => DiamondWithdrawReviewItem.fromJson(e))
                .toList()
          : null,
      serviceRate: json['serviceRate'],
      shellRate: json['shellRate'],
      zfbAccount: json['zfbAccount'],
      zfbMobile: json['zfbMobile'],
    );
  }
}

/// 钻石提现配置响应体
class DiamondWithdrawConfigResp {
  /// 状态码
  final int code;

  /// 数据
  final DiamondWithdrawConfigData? data;

  /// 错误信息
  final String? message;

  DiamondWithdrawConfigResp({required this.code, this.data, this.message});

  factory DiamondWithdrawConfigResp.fromJson(Map<String, dynamic> json) {
    return DiamondWithdrawConfigResp(
      code: json['code'],
      data: json['data'] != null
          ? DiamondWithdrawConfigData.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }
}

/// 申请提现请求体
class DiamondWithdrawApplyReq {
  /// 提现数量
  final int diamond;

  /// 支付宝账号
  final String zfbAccount;

  /// 支付宝手机号
  final String zfbMobile;

  DiamondWithdrawApplyReq({
    required this.diamond,
    required this.zfbAccount,
    required this.zfbMobile,
  });

  Map<String, dynamic> toJson() {
    return {
      'diamond': diamond,
      'zfbAccount': zfbAccount,
      'zfbMobile': zfbMobile,
    };
  }
}

/// 撤销提现请求体
class DiamondWithdrawCancelReq {
  /// 提现记录ID
  final int id;

  DiamondWithdrawCancelReq({required this.id});

  Map<String, dynamic> toJson() {
    return {'id': id};
  }
}

/// 钻石兑换配置数据体
class DiamondExchangeConfigData {
  /// 收益余额
  final num? balanceAmount;

  /// 配置列表
  final List<DiamondExchangeConfigItem>? list;

  DiamondExchangeConfigData({this.balanceAmount, this.list});

  factory DiamondExchangeConfigData.fromJson(Map<String, dynamic> json) {
    return DiamondExchangeConfigData(
      balanceAmount: json['balanceAmount'],
      list: json['list'] != null
          ? (json['list'] as List)
                .map((e) => DiamondExchangeConfigItem.fromJson(e))
                .toList()
          : null,
    );
  }
}

/// 钻石兑换配置响应体
class DiamondExchangeConfigResp {
  /// 状态码
  final int code;

  /// 数据
  final DiamondExchangeConfigData? data;

  /// 错误信息
  final String? message;

  DiamondExchangeConfigResp({required this.code, this.data, this.message});

  factory DiamondExchangeConfigResp.fromJson(Map<String, dynamic> json) {
    return DiamondExchangeConfigResp(
      code: json['code'],
      data: json['data'] != null
          ? DiamondExchangeConfigData.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }
}

/// 邀请收益列表请求
class InviteIncomeListReq {
  InviteIncomeListReq({required this.pageNum, required this.pageSize});

  final int pageNum;
  final int pageSize;

  Map<String, dynamic> toJson() => {'pageNum': pageNum, 'pageSize': pageSize};
}

/// 单条邀请收益
class InviteIncomeItem {
  InviteIncomeItem({this.income, this.incomeDesc, this.incomeTime});

  // 获得收益(钻石)
  final int? income;
  // 收益文案
  final String? incomeDesc;
  // 收益获得时间
  final String? incomeTime;

  factory InviteIncomeItem.fromJson(Map<String, dynamic> json) =>
      InviteIncomeItem(
        income: json['income'] as int?,
        incomeDesc: json['incomeDesc'] as String?,
        incomeTime: json['incomeTime'] as String?,
      );
}

/// 邀请收益分页数据
class InviteIncomePage {
  InviteIncomePage({this.hasNext, this.list});

  final bool? hasNext;
  final List<InviteIncomeItem>? list;

  factory InviteIncomePage.fromJson(Map<String, dynamic> json) =>
      InviteIncomePage(
        hasNext: json['hasNext'] as bool?,
        list: (json['list'] as List<dynamic>?)
            ?.map(
              (item) => InviteIncomeItem.fromJson(item as Map<String, dynamic>),
            )
            .toList(),
      );
}

/// 邀请收益列表响应
class InviteIncomeListResp {
  InviteIncomeListResp({required this.code, this.data, this.message});

  final int code;
  final InviteIncomePage? data;
  final String? message;

  factory InviteIncomeListResp.fromJson(Map<String, dynamic> json) =>
      InviteIncomeListResp(
        code: json['code'] as int? ?? -1,
        data: json['data'] != null
            ? InviteIncomePage.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        message: json['message'] as String?,
      );
}
