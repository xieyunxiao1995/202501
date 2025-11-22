import 'package:zhenyu_flutter/models/invite_api_model.dart';
import 'package:zhenyu_flutter/utils/http.dart';

class InviteApi {
  /// 邀请页面信息
  static Future<InvitePageResp> getInvitePage() async {
    final response = await Http.request("/invite/me", method: "post");
    return InvitePageResp.fromJson(response.data);
  }

  /// 邀请列表
  static Future<InviteListResp> getInviteList(InviteListReq req) async {
    final response = await Http.request(
      "/invite/inviteList",
      method: "post",
      data: req.toJson(),
    );
    return InviteListResp.fromJson(response.data);
  }

  /// 邀请收益榜单
  static Future<InviteIncomeTopResp> getInviteIncomeTop() async {
    final response = await Http.request(
      "/invite/inviteIncomeTop",
      method: "post",
    );
    return InviteIncomeTopResp.fromJson(response.data);
  }

  /// 绑定邀请关系
  static Future<InviteBindUserResp> inviteBindUser(
    InviteBindUserReq req,
  ) async {
    final response = await Http.post(
      "/invite/inviteBindUser",
      data: req.toJson(),
    );
    return InviteBindUserResp.fromJson(response.data);
  }

  // ==================== 会员赠送相关接口 ====================

  /// 会员赠送权益配置
  static Future<VipGiftBenefitConfigResp> getVipGiftBenefitConfig() async {
    final response = await Http.post("/vipGiftBenefit/config");
    return VipGiftBenefitConfigResp.fromJson(response.data);
  }

  /// 会员赠送
  static Future<VipGiftBenefitGiveResp> vipGiftBenefitGive(
    VipGiftBenefitGiveReq req,
  ) async {
    final response = await Http.post(
      "/vipGiftBenefit/give",
      data: req.toJson(),
    );
    return VipGiftBenefitGiveResp.fromJson(response.data);
  }

  /// 会员赠送获取对方用户信息
  static Future<VipGiftBenefitGetToUserInfoResp> vipGiftBenefitGetToUserInfo(
    VipGiftBenefitGetToUserInfoReq req,
  ) async {
    final response = await Http.post(
      "/vipGiftBenefit/getToUserInfo",
      data: req.toJson(),
    );
    return VipGiftBenefitGetToUserInfoResp.fromJson(response.data);
  }

  /// 会员赠送记录
  static Future<VipGiftBenefitRecordsResp> getVipGiftBenefitRecords(
    VipGiftBenefitRecordsReq req,
  ) async {
    final response = await Http.post(
      "/vipGiftBenefit/records",
      data: req.toJson(),
    );
    return VipGiftBenefitRecordsResp.fromJson(response.data);
  }
}
