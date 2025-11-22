import 'package:zhenyu_flutter/models/report_api_model.dart';
import 'package:zhenyu_flutter/utils/http.dart';

class ReportApi {
  /// 举报用户
  static Future reportUser(ReportUserReq req) {
    return Http.request(
      "/report/reportUser",
      method: "post",
      data: req.toJson(),
    );
  }
}
