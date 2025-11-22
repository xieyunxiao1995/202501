import 'package:zhenyu_flutter/utils/http.dart';

class SecurityApi {
  /// 忘记密码
  static Future forgetPwd(Map<String, dynamic> data) {
    return Http.request("/security/forgetPwd", method: "post", data: data);
  }

  /// 申请注销信息
  static Future cancelInfo(Map<String, dynamic> data) {
    return Http.request("/security/cancelInfo", method: "post", data: data);
  }

  /// 申请注销
  static Future cancelApply(Map<String, dynamic> data) {
    return Http.request("/security/cancelApply", method: "post", data: data);
  }

  /// 取消申请
  static Future cancelApplyCancel(Map<String, dynamic> data) {
    return Http.request(
      "/security/cancelApply/cancel",
      method: "post",
      data: data,
    );
  }

  /// 安全信息
  static Future securityInfo(Map<String, dynamic> data) {
    return Http.request("/security/info", method: "post", data: data);
  }

  /// 修改密码
  static Future resetPwd(Map<String, dynamic> data) {
    return Http.request("/security/resetPwd", method: "post", data: data);
  }
}
