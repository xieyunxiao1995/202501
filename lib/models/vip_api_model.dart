import 'package:zhenyu_flutter/models/index_api_model.dart';

/// VIP套餐配置信息
class VipPlanInfo {
  /// 是否支持支付宝 0不支持 1支持
  final int? aliPay;

  /// 天数
  final int? days;

  /// 赠送金币(0不展示 >0展示)
  final int? giveCoin;

  /// 配置ID
  final int? id;

  /// 苹果充值id
  final String? iosId;

  /// 原价
  final String? originalPrice;

  /// 价格
  final String? price;

  /// 限时优惠 0不展示 1展示
  final int? recommend;

  /// 单价 单位 元/天
  final String? unitPrice;

  /// 配置名称
  final String? vipName;

  /// 是否支持微信支付 0不支持 1支持
  final int? wxPay;

  //  打印（调试用的）
  @override
  String toString() {
    return 'VipPlanInfo(iosId: $iosId, vipName: $vipName, price: $price, '
        'days: $days, giveCoin: $giveCoin, aliPay: $aliPay, wxPay: $wxPay)';
  }

  VipPlanInfo({
    this.aliPay,
    this.days,
    this.giveCoin,
    this.id,
    this.iosId,
    this.originalPrice,
    this.price,
    this.recommend,
    this.unitPrice,
    this.vipName,
    this.wxPay,
  });

  factory VipPlanInfo.fromJson(Map<String, dynamic> json) {
    return VipPlanInfo(
      aliPay: json['aliPay'],
      days: json['days'],
      giveCoin: json['giveCoin'],
      id: json['id'],
      iosId: json['iosId'],
      originalPrice: json['originalPrice'],
      price: json['price'],
      recommend: json['recommend'],
      unitPrice: json['unitPrice'],
      vipName: json['vipName'],
      wxPay: json['wxPay'],
    );
  }
}

/// 充值配置-VIP 响应体数据
class VipConfigData {
  /// 广告Banner轮播配置
  final List<BannerInfo>? bannerList;

  /// 折扣剩余天数(3天内注册的用户返回)0:表示无折扣,3:表示剩余3天
  final int? discountDaysRemaining;

  /// 配置列表
  final List<VipPlanInfo>? list;

  /// 是否VIP 0否 1是
  final int? vip;

  /// VIP失效时间
  final String? vipInvalidTime;

  VipConfigData({
    this.bannerList,
    this.discountDaysRemaining,
    this.list,
    this.vip,
    this.vipInvalidTime,
  });

  factory VipConfigData.fromJson(Map<String, dynamic> json) {
    return VipConfigData(
      bannerList: json['bannerList'] != null
          ? (json['bannerList'] as List)
                .map((i) => BannerInfo.fromJson(i))
                .toList()
          : null,
      discountDaysRemaining: json['discountDaysRemaining'],
      list: json['list'] != null
          ? (json['list'] as List).map((i) => VipPlanInfo.fromJson(i)).toList()
          : null,
      vip: json['vip'],
      vipInvalidTime: json['vipInvalidTime'],
    );
  }
}

/// 充值配置-VIP 接口总响应体
class VipConfigResp {
  /// 状态码
  final int code;

  /// 数据
  final VipConfigData? data;

  /// 错误信息
  final String? message;

  VipConfigResp({required this.code, this.data, this.message});

  factory VipConfigResp.fromJson(Map<String, dynamic> json) {
    return VipConfigResp(
      code: json['code'],
      data: json['data'] != null ? VipConfigData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

/// Apple Pay 请求体
class ApplePayRequest {
  /// 是否正式环境
  final bool chooseEnv;

  /// 配置ID
  final int id;

  /// 支付类型， COIN=金币 VIP=vip,可用值:COIN,ORDER,VIP
  final String orderTradeType;

  /// 加密数据
  final String receipt;

  ApplePayRequest({
    required this.chooseEnv,
    required this.id,
    required this.orderTradeType,
    required this.receipt,
  });

  Map<String, dynamic> toJson() {
    return {
      'chooseEnv': chooseEnv,
      'id': id,
      'orderTradeType': orderTradeType,
      'receipt': receipt,
    };
  }
}

class VipPayRequest {
  final int id;
  final String payType;
  final int? scene;

  VipPayRequest({required this.id, required this.payType, this.scene});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{'id': id, 'payType': payType};
    if (scene != null) {
      data['scene'] = scene;
    }
    return data;
  }
}

class VipPayData {
  final int? configId;
  final String? data;
  final int? orderId;
  final int? payType;

  VipPayData({this.configId, this.data, this.orderId, this.payType});

  factory VipPayData.fromJson(Map<String, dynamic> json) {
    return VipPayData(
      configId: json['configId'],
      data: json['data'],
      orderId: json['orderId'],
      payType: json['payType'],
    );
  }
}

class VipPayResp {
  final int code;
  final VipPayData? data;
  final String? message;

  VipPayResp({required this.code, this.data, this.message});

  factory VipPayResp.fromJson(Map<String, dynamic> json) {
    return VipPayResp(
      code: json['code'],
      data: json['data'] != null ? VipPayData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

/// 充值配置项
class RechargeConfigVo {
  /// 是否支持支付宝 1支持
  final int? aliPay;

  /// 金币数量
  final int? amount;

  /// 赠送数量
  final int? giveAmount;

  /// 配置ID
  final int? id;

  /// 苹果充值id
  final String? iosId;

  /// 价格 元
  final String? price;

  /// 推荐标签 1推荐
  final String? tag;

  /// 总数量=金币数量+赠送数量
  final int? totalAmount;

  /// 是否支持微信 1支持
  final int? wxPay;

  RechargeConfigVo({
    this.aliPay,
    this.amount,
    this.giveAmount,
    this.id,
    this.iosId,
    this.price,
    this.tag,
    this.totalAmount,
    this.wxPay,
  });

  factory RechargeConfigVo.fromJson(Map<String, dynamic> json) {
    return RechargeConfigVo(
      aliPay: json['aliPay'],
      amount: json['amount'],
      giveAmount: json['giveAmount'],
      id: json['id'],
      iosId: json['iosId'],
      price: json['price'],
      tag: json['tag'],
      totalAmount: json['totalAmount'],
      wxPay: json['wxPay'],
    );
  }
}

/// 充值配置-金币 响应体
class RechargeConfigData {
  /// 余额数量
  final int? balanceAmount;

  /// 广告Banner轮播配置
  final List<BannerInfo>? bannerList;

  /// 配置列表
  final List<RechargeConfigVo>? list;

  RechargeConfigData({this.balanceAmount, this.bannerList, this.list});

  factory RechargeConfigData.fromJson(Map<String, dynamic> json) {
    return RechargeConfigData(
      balanceAmount: json['balanceAmount'],
      bannerList: json['bannerList'] != null
          ? (json['bannerList'] as List)
                .map((i) => BannerInfo.fromJson(i))
                .toList()
          : null,
      list: json['list'] != null
          ? (json['list'] as List)
                .map((i) => RechargeConfigVo.fromJson(i))
                .toList()
          : null,
    );
  }
}

/// 充值配置-金币 接口总响应体
class RechargeConfigResp {
  /// 状态码
  final int code;

  /// 数据
  final RechargeConfigData? data;

  /// 错误信息
  final String? message;

  RechargeConfigResp({required this.code, this.data, this.message});

  factory RechargeConfigResp.fromJson(Map<String, dynamic> json) {
    return RechargeConfigResp(
      code: json['code'],
      data: json['data'] != null
          ? RechargeConfigData.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }
}

/// 账单列表请求体
class BillListRequest {
  /// 年月份 (yyyy-MM)，为空则查询全部
  final String? monthOfYear;

  /// 页码，从 1 开始
  final int pageNum;

  /// 每页条数
  final int pageSize;

  /// 列表类型(EXPENSE:支出, INCOME:收入)，允许后端约定其他值
  final String type;

  BillListRequest({
    this.monthOfYear,
    required this.pageNum,
    required this.pageSize,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'monthOfYear': monthOfYear ?? '',
      'pageNum': pageNum,
      'pageSize': pageSize,
      'type': type,
    };
  }
}

/// 账单列表单条记录
class BillListItem {
  /// 变动值
  final int? changeValue;

  /// 变动币种类型(COIN:金币, DIAMONDS:钻石)
  final String? company;

  /// 账单创建时间
  final String? createTime;

  /// 账单描述文案
  final String? info;

  /// 账单类型编码(暂未使用)
  final int? recordTypeCode;

  /// 账单标题
  final String? title;

  BillListItem({
    this.changeValue,
    this.company,
    this.createTime,
    this.info,
    this.recordTypeCode,
    this.title,
  });

  factory BillListItem.fromJson(Map<String, dynamic> json) {
    return BillListItem(
      changeValue: json['changeValue'],
      company: json['company'],
      createTime: json['createTime'],
      info: json['info'],
      recordTypeCode: json['recordTypeCode'],
      title: json['title'],
    );
  }
}

/// 账单列表响应数据体
class BillListData {
  /// 是否还有下一页
  final bool? hasNext;

  /// 账单记录列表
  final List<BillListItem>? list;

  BillListData({this.hasNext, this.list});

  factory BillListData.fromJson(Map<String, dynamic> json) {
    return BillListData(
      hasNext: json['hasNext'],
      list: json['list'] != null
          ? (json['list'] as List)
                .map((item) => BillListItem.fromJson(item))
                .toList()
          : null,
    );
  }
}

/// 账单列表接口响应体
class BillListResp {
  /// 状态码
  final int code;

  /// 数据内容
  final BillListData? data;

  /// 错误信息
  final String? message;

  BillListResp({required this.code, this.data, this.message});

  factory BillListResp.fromJson(Map<String, dynamic> json) {
    return BillListResp(
      code: json['code'],
      data: json['data'] != null ? BillListData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

/// VIP优惠充值弹窗数据
class VipDiscountPopUpData {
  /// VIP优惠配置ID(使用此ID调用充值VIP接口)
  final int? configId;

  /// 活动剩余倒计时(秒)
  final int? countdownTime;

  /// 是否满足优惠条件(0:不满足无需处理,1:满足需弹窗)
  final int? eligibleStatus;

  /// 活动到期时间
  final String? expireTime;

  /// 价格
  final double? price;

  /// VIP名称
  final String? vipName;

  VipDiscountPopUpData({
    this.configId,
    this.countdownTime,
    this.eligibleStatus,
    this.expireTime,
    this.price,
    this.vipName,
  });

  factory VipDiscountPopUpData.fromJson(Map<String, dynamic> json) {
    return VipDiscountPopUpData(
      configId: json['configId'],
      countdownTime: json['countdownTime'],
      eligibleStatus: json['eligibleStatus'],
      expireTime: json['expireTime'],
      price: json['price']?.toDouble(),
      vipName: json['vipName'],
    );
  }
}

/// VIP优惠充值弹窗响应体
class VipDiscountPopUpResp {
  /// 状态码
  final int code;

  /// 数据
  final VipDiscountPopUpData? data;

  /// 错误信息
  final String? message;

  VipDiscountPopUpResp({required this.code, this.data, this.message});

  factory VipDiscountPopUpResp.fromJson(Map<String, dynamic> json) {
    return VipDiscountPopUpResp(
      code: json['code'],
      data: json['data'] != null
          ? VipDiscountPopUpData.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }
}

