import 'package:zhenyu_flutter/models/diamond_api_model.dart';
import 'package:zhenyu_flutter/utils/http.dart';

class DiamondApi {
  /// 获取钻石兑换配置
  static Future<DiamondExchangeConfigResp> getWithdrawExchangeConfig() async {
    final response = await Http.request(
      "/withdraw/exchange/config",
      method: "POST",
    );
    return DiamondExchangeConfigResp.fromJson(response.data);
  }

  /// 兑换钻石到账户
  static Future<Map<String, dynamic>> withdrawExchangeApply(
    int configId,
  ) async {
    final response = await Http.request(
      "/withdraw/exchange/apply",
      method: "POST",
      data: {'configId': configId},
    );
    return response.data as Map<String, dynamic>;
  }

  /// 获取钻石提现配置
  static Future<DiamondWithdrawConfigResp> getWithdrawConfig() async {
    final response = await Http.request("/withdraw/config", method: "POST");
    return DiamondWithdrawConfigResp.fromJson(response.data);
  }

  /// 申请提现
  static Future<Map<String, dynamic>> withdrawApply(
    DiamondWithdrawApplyReq request,
  ) async {
    final response = await Http.request(
      "/withdraw/apply",
      method: "POST",
      data: request.toJson(),
    );
    return response.data as Map<String, dynamic>;
  }

  /// 撤销提现
  static Future<Map<String, dynamic>> withdrawCancel(
    DiamondWithdrawCancelReq request,
  ) async {
    final response = await Http.request(
      "/withdraw/apply/cancel",
      method: "POST",
      data: request.toJson(),
    );
    return response.data as Map<String, dynamic>;
  }

  /// 邀请收益列表
  static Future<InviteIncomeListResp> getInviteIncomeList(
    InviteIncomeListReq req,
  ) async {
    final response = await Http.request(
      "/invite/inviteIncomeList",
      method: "POST",
      data: req.toJson(),
    );
    return InviteIncomeListResp.fromJson(response.data);
  }
}
