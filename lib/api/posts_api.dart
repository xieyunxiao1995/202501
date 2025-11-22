import 'package:zhenyu_flutter/models/posts_api_model.dart';
import 'package:zhenyu_flutter/utils/http.dart';

class PostsApi {
  /// 分页查询动态列表
  static Future<PostsListResp> postsList(PostsListReq req) async {
    final response = await Http.request(
      "/posts/list",
      method: "post",
      data: req.toJson(),
    );
    return PostsListResp.fromJson(response.data);
  }

  /// 分页查询消息列表
  static Future<MsgListResp> msglist(MsgListReq req) async {
    final response = await Http.request(
      "/posts/notifications/list",
      method: "post",
      data: req.toJson(),
    );
    return MsgListResp.fromJson(response.data);
  }

  /// 点赞或取消点赞
  static Future postsLike(PostsLikeReq req) {
    return Http.request("/posts/like", method: "post", data: req.toJson());
  }

  /// 创建动态
  static Future<PostsCreateResp> createPost(PostsCreateReq req) async {
    final response = await Http.request(
      "/posts/createPost",
      method: "post",
      data: req.toJson(),
    );
    return PostsCreateResp.fromJson(response.data);
  }

  /// 动态详情
  static Future<PostsDetailResp> postsDetail(PostsDetailReq req) async {
    final response = await Http.request(
      "/posts/detail",
      method: "post",
      data: req.toJson(),
    );
    return PostsDetailResp.fromJson(response.data);
  }

  /// 获取动态评论列表
  static Future<PostsCommentListResp> postsCommentList(
    PostsCommentListReq req,
  ) async {
    final response = await Http.request(
      "/posts/commentList",
      method: "post",
      data: req.toJson(),
    );
    return PostsCommentListResp.fromJson(response.data);
  }

  /// 发表评论
  static Future<PostsCommentsAddResp> postsCommentsAdd(
    PostsCommentsAddReq req,
  ) async {
    final response = await Http.request(
      "/posts/comments",
      method: "post",
      data: req.toJson(),
    );
    return PostsCommentsAddResp.fromJson(response.data);
  }

  /// 动态获取未读消息数
  static Future<UnreadCountResp> getUnreadCount(
    Map<String, dynamic> data,
  ) async {
    final response = await Http.request(
      "/posts/notifications/unreadCount",
      method: "post",
      data: data,
    );
    return UnreadCountResp.fromJson(response.data);
  }

  /// 我的动态列表
  static Future<PostsListResp> postsMyList(PostsMyListReq req) async {
    final response = await Http.request(
      "/posts/myList",
      method: "post",
      data: req.toJson(),
    );
    return PostsListResp.fromJson(response.data);
  }

  /// 删除评论
  static Future postsCommentsDelete(Map<String, dynamic> data) {
    return Http.request("/posts/comments/delete", method: "post", data: data);
  }

  /// 删除动态
  static Future postsDelete(PostsDeleteReq req) {
    return Http.request("/posts/delete", method: "post", data: req.toJson());
  }
}
