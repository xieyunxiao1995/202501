import 'package:zhenyu_flutter/models/ad_api_model.dart';
import 'package:zhenyu_flutter/utils/http.dart';

class AdApi {
  /// 广告Banner
  static Future<BannerResp> getBanner(BannerReq req) async {
    final response = await Http.request(
      "/ad/banner",
      method: "post",
      data: req.toJson(),
    );
    return BannerResp.fromJson(response.data);
  }
}
