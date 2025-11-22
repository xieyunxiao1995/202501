import 'package:zhenyu_flutter/models/config_api_model.dart';
import 'package:zhenyu_flutter/utils/http.dart';

class ConfigApi {
  /// app启动配置参数
  static Future<AppInitConfigResp> getAppInitConfig() async {
    final response = await Http.request("/config/initConfig", method: "post");
    return AppInitConfigResp.fromJson(response.data);
  }

  /// 获取客服信息
  static Future<CustomerServiceResp> getCustomerService() async {
    final response = await Http.request(
      "/config/getCustomerService",
      method: "post",
    );
    return CustomerServiceResp.fromJson(response.data);
  }
}
