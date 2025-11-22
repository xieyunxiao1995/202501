import 'package:zhenyu_flutter/models/attention_api_model.dart';
import 'package:zhenyu_flutter/utils/http.dart';

class AttentionApi {
  /// 谁看过我列表
  static Future<LookMeListResp> lookMeList(LookMeListReq req) async {
    final response = await Http.request(
      "/attention/look/list",
      method: "POST",
      data: req.toJson(),
    );
    return LookMeListResp.fromJson(response.data as Map<String, dynamic>);
  }

  /// 喜欢列表
  static Future<LikeListResp> likeList(LikeListReq req) async {
    final response = await Http.request(
      "/attention/list",
      method: "post",
      data: req.toJson(),
    );
    return LikeListResp.fromJson(response.data as Map<String, dynamic>);
  }

  /// 添加关注
  static Future addAttention(String toUid) {
    return Http.request(
      "/attention/add",
      method: "post",
      data: {'toUid': toUid},
    );
  }

  /// 取消关注
  static Future delAttention(String toUid) {
    return Http.request(
      "/attention/del",
      method: "post",
      data: {'toUid': toUid},
    );
  }
}
