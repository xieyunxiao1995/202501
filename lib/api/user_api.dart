import 'package:dio/dio.dart';
import 'package:zhenyu_flutter/models/user_api_model.dart';
import 'package:zhenyu_flutter/models/user_session_model.dart';
import 'package:zhenyu_flutter/utils/http.dart';

class UserApi {
  /// 登录
  static Future<LoginResp> login(LoginData data) async {
    final response = await Http.request(
      "/user/login",
      method: "post",
      data: data.toJson(),
    );
    return LoginResp.fromJson(response.data);
  }

  /// 发送短信
  static Future getSms(GetSmsData data) {
    return Http.request("/user/send/sms", method: "post", data: data.toJson());
  }

  /// 随机名称
  static Future<RandomNameResp> getUserName(RandomNameReq req) async {
    final response = await Http.request(
      "/user/randomName",
      method: "post",
      data: req.toJson(),
    );
    return RandomNameResp.fromJson(response.data);
  }

  /// 随机头像
  static Future<RandomAvatarResp> randomAvatar(RandomAvatarReq req) async {
    final response = await Http.request(
      "/user/randomAvatar",
      method: "post",
      data: req.toJson(),
    );
    return RandomAvatarResp.fromJson(response.data);
  }

  /// 注册并登录
  static Future<LoginResp> userRegister(UserRegisterData data) async {
    final response = await Http.request(
      "/user/register",
      method: "post",
      data: data.toJson(),
    );
    return LoginResp.fromJson(response.data);
  }

  /// 退出登录
  static Future loginOut(Map<String, dynamic> data) {
    return Http.request("/user/loginOut", method: "post", data: data);
  }

  /// 检查是否需要绑定id
  static Future checkBindWxMp(Map<String, dynamic> data) {
    return Http.request("/user/checkBindWxMp", method: "post", data: data);
  }

  /// 公众号-获取静默授权链接
  static Future getAuthorizationUrl(Map<String, dynamic> data) {
    return Http.request(
      "/user/getAuthorizationUrl",
      method: "post",
      data: data,
    );
  }

  /// 绑定code
  static Future bindWxMp(Map<String, dynamic> data) {
    return Http.request("/user/bindWxMp", method: "post", data: data);
  }

  /// 申请邀请码
  static Future applyForInviteCode(Map<String, dynamic> data) {
    return Http.request("/user/applyForInviteCode", method: "post", data: data);
  }

  /// 审核填写邀请码
  static Future<LoginResp> reviewInviteCode(ReviewInviteCodeData data) async {
    final response = await Http.request(
      "/user/reviewInviteCode",
      method: "post",
      data: data.toJson(),
    );
    return LoginResp.fromJson(response.data);
  }

  /// 获取城市列表
  static Future<GetCitiesResp> getCities() async {
    final response = await Http.request(
      "/userInfo/data/getCities",
      method: "post",
    );
    return GetCitiesResp.fromJson(response.data);
  }

  /// 获取修改资料信息
  static Future<GetUpdateInfoResp> getUpdateInfo() async {
    final response = await Http.request(
      "/userInfo/data/update/getInfo",
      method: "post",
    );
    return GetUpdateInfoResp.fromJson(response.data);
  }

  /// 校验邀请码
  static Future<CheckInviteCodeResp> checkInviteCode(
    CheckInviteCodeReq data,
  ) async {
    final response = await Http.request(
      "/invite/checkInviteCode",
      method: "post",
      data: data.toJson(),
    );
    return CheckInviteCodeResp.fromJson(response.data);
  }

  /// 获取身材与职业选项
  static Future<FigureAndOccupationResp> getFigureAndOccupation() async {
    final response = await Http.request(
      "/userInfo/data/figureAndOccupation",
      method: "post",
    );
    return FigureAndOccupationResp.fromJson(response.data);
  }

  /// 正常女用户注册并登录
  static Future<LoginResp> femaleRegister(FemaleRegisterData data) async {
    final response = await Http.request(
      "/user/femaleRegister",
      method: "post",
      data: data.toJson(),
    );
    return LoginResp.fromJson(response.data);
  }

  /// 修改个人资料
  static Future<Response> updateUserProfile(UpdateUserProfileReq req) {
    return Http.request(
      "/userInfo/data/update",
      method: "post",
      data: req.toJson(),
    );
  }

  /// 检查短信验证码
  static Future checkSms(Map<String, dynamic> data) {
    return Http.request("/user/check/sms", method: "post", data: data);
  }

  /// 获取他人资料卡
  static Future<GetOtherUserInfoResp> getOtherUserInfo(
    GetOtherUserInfoReq req,
  ) async {
    final response = await Http.request(
      "/userInfo/data/other",
      method: "post",
      data: req.toJson(),
    );
    return GetOtherUserInfoResp.fromJson(response.data);
  }

  /// 获取聊天页头部信息
  static Future<ChatHeadInfoResp> getChatHeadInfo(ChatHeadInfoReq req) async {
    final response = await Http.request(
      "/userInfo/chat/getHeadInfo",
      method: "post",
      data: req.toJson(),
    );
    return ChatHeadInfoResp.fromJson(response.data as Map<String, dynamic>);
  }

  /// 获取用户配置
  static Future<GetUserProfileResp> getUserProfile() async {
    final response = await Http.request(
      "/userInfo/data/getUserProfile",
      method: "post",
    );
    return GetUserProfileResp.fromJson(response.data);
  }

  /// 获取用户信息
  static Future<UserInfoMeResp> getUserInfoMe() async {
    final response = await Http.request("/userInfo/me", method: "post");
    return UserInfoMeResp.fromJson(response.data);
  }

  /// 获取用户黑名单
  static Future<BlacklistResp> getBlacklist(BlacklistRequest req) async {
    final response = await Http.request(
      "/black",
      method: "post",
      data: req.toJson(),
    );
    return BlacklistResp.fromJson(response.data);
  }

  /// 获取账号安全信息
  static Future<SecurityInfoResp> getSecurityInfo() async {
    final response = await Http.request("/security/info", method: "post");
    return SecurityInfoResp.fromJson(response.data);
  }

  /// 获取账号注销信息
  static Future<CancelInfoResp> getCancelInfo() async {
    final response = await Http.request("/security/cancelInfo", method: "post");
    return CancelInfoResp.fromJson(response.data);
  }

  /// 修改账号密码
  static Future<SecurityActionResp> resetPassword(
    ResetPasswordRequest req,
  ) async {
    final response = await Http.request(
      "/security/resetPwd",
      method: "post",
      data: req.toJson(),
    );
    return SecurityActionResp.fromJson(response.data);
  }

  /// 申请账号注销
  static Future<SecurityActionResp> applyAccountCancel() async {
    final response = await Http.request(
      "/security/cancelApply",
      method: "post",
    );
    return SecurityActionResp.fromJson(response.data);
  }

  /// 取消账号注销申请
  static Future<SecurityActionResp> revokeAccountCancel() async {
    final response = await Http.request(
      "/security/cancelApply/cancel",
      method: "post",
    );
    return SecurityActionResp.fromJson(response.data);
  }

  /// 添加黑名单用户
  static Future<BlacklistActionResp> addBlacklistUser(
    BlacklistModifyRequest req,
  ) async {
    final response = await Http.request(
      "/black/addUser",
      method: "post",
      data: req.toJson(),
    );
    return BlacklistActionResp.fromJson(response.data);
  }

  /// 移除黑名单用户
  static Future<BlacklistActionResp> removeBlacklistUser(
    BlacklistModifyRequest req,
  ) async {
    final response = await Http.request(
      "/black/delUser",
      method: "post",
      data: req.toJson(),
    );
    return BlacklistActionResp.fromJson(response.data);
  }

  /// 批量获取用户会话基础信息
  static Future<UserSessionBatchResp> getBatchSessionsInfo(
    UserSessionBatchReq req,
  ) async {
    final response = await Http.request(
      "/userInfo/batchSessionsInfo",
      method: "post",
      data: req.toJson(),
    );
    return UserSessionBatchResp.fromJson(response.data);
  }

  /// 添加用户标签
  static Future<SecurityActionResp> addLabels(AddLabelsReq req) async {
    final response = await Http.request(
      "/userInfo/data/other/addLabels",
      method: "post",
      data: req.toJson(),
    );
    return SecurityActionResp.fromJson(response.data);
  }

  /// 获取我的联系方式
  static Future<GetAccountResp> getSocialAccount() async {
    final response = await Http.request("/userInfo/getAccount", method: "post");
    return GetAccountResp.fromJson(response.data);
  }

  /// 绑定邀请码
  static Future<BindInviteResp> bindInvite(BindInviteReq req) async {
    final response = await Http.request(
      "/invite/bindInvite",
      method: "post",
      data: req.toJson(),
    );
    return BindInviteResp.fromJson(response.data);
  }
}
