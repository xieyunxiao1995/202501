import 'package:zhenyu_flutter/models/real_api_model.dart';
import 'package:zhenyu_flutter/utils/http.dart';

class RealApi {
  /// 获取认证状态
  static Future<RealStatusResp> getRealStatus() async {
    final response = await Http.request("/real/getRealStatus", method: "post");
    return RealStatusResp.fromJson(response.data);
  }

  /// 真人认证提交
  static Future<RealNameResp> realName(RealNameReq req) async {
    final response = await Http.request(
      "/real/realName",
      method: "post",
      data: req.toJson(),
    );
    return RealNameResp.fromJson(response.data);
  }
}
