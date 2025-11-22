import 'package:zhenyu_flutter/models/videos_api_model.dart';
import 'package:zhenyu_flutter/utils/http.dart';

class VideosApi {
  /// 获取推荐视频列表
  static Future<VideoRecommendResp> getRecommendVideos(
    VideoRecommendReq req,
  ) async {
    final response = await Http.request(
      "/userVideos/recommend",
      method: "post",
      data: req.toJson(),
    );
    return VideoRecommendResp.fromJson(response.data);
  }
}
