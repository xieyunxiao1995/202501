import 'package:zhenyu_flutter/models/vip_api_model.dart';
import 'package:zhenyu_flutter/utils/http.dart';

class VipApi {
  /// 获取VIP充值配置
  static Future<VipConfigResp> getVipConfig() async {
    final response = await Http.request(
      "/recharge/vip/config",
      method: "POST", // 接口文档通常用POST获取配置，如果不行再改为GET
    );
    return VipConfigResp.fromJson(response.data);
  }

  /// Apple Pay 支付
  static Future iosPay(ApplePayRequest req) {
    return Http.request("/recharge/iosPay", method: "POST", data: req.toJson());
  }

  /// 充值支付
  static Future<VipPayResp> vipPay(VipPayRequest req) async {
    final response = await Http.request(
      "/recharge/vip/pay",
      method: "POST",
      data: req.toJson(),
    );
    return VipPayResp.fromJson(response.data);
  }

  /// 获取充值配置
  static Future<RechargeConfigResp> getRechargeConfig() async {
    final response = await Http.request("/recharge/config", method: "POST");
    return RechargeConfigResp.fromJson(response.data);
  }

  /// 获取账单列表
  static Future<BillListResp> getBillList(BillListRequest request) async {
    final response = await Http.request(
      "/bill/list",
      method: "POST",
      data: request.toJson(),
    );
    return BillListResp.fromJson(response.data);
  }

  /// 获取VIP优惠充值弹窗
  static Future<VipDiscountPopUpResp> getVipDiscountPopUp() async {
    final response = await Http.request(
      "/recharge/vip/discountPopUp",
      method: "POST",
    );
    return VipDiscountPopUpResp.fromJson(response.data);
  }
}
