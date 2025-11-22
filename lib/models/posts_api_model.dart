// --- 请求模型 ---

class PostsListReq {
  final String? cityCode;
  final int pageNum;
  final int pageSize;
  final int type;

  PostsListReq({
    this.cityCode,
    required this.pageNum,
    required this.pageSize,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'type': type,
    };
    if (cityCode != null) {
      data['cityCode'] = cityCode;
    }
    return data;
  }
}

class PostsLikeReq {
  final bool isLike;
  final int targetId;
  final int targetType;

  PostsLikeReq({
    required this.isLike,
    required this.targetId,
    required this.targetType,
  });

  Map<String, dynamic> toJson() {
    return {'isLike': isLike, 'targetId': targetId, 'targetType': targetType};
  }
}

class PostsDetailReq {
  final int postId;

  PostsDetailReq({required this.postId});

  Map<String, dynamic> toJson() {
    return {'postId': postId};
  }
}

class PostsCommentListReq {
  /// 页码
  final int pageNum;

  /// 条数
  final int pageSize;

  /// 动态ID
  final int postId;

  /// 一级评论ID（查二级评论时必传，不传只查一级评论）
  final int? rootId;

  PostsCommentListReq({
    required this.pageNum,
    required this.pageSize,
    required this.postId,
    this.rootId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'pageNum': pageNum,
      'pageSize': pageSize,
      'postId': postId,
    };
    if (rootId != null) {
      data['rootId'] = rootId;
    }
    return data;
  }
}

class PostsDeleteReq {
  /// 动态ID
  final int postId;

  PostsDeleteReq({required this.postId});

  Map<String, dynamic> toJson() {
    return {'postId': postId};
  }
}

class PostsCommentsAddReq {
  /// 评论内容
  final String content;

  /// 纬度
  final double latitude;

  /// 经度
  final double longitude;

  /// 父评论ID（回复评论时传）
  final int? parentId;

  /// 动态ID
  final int postId;

  PostsCommentsAddReq({
    required this.content,
    required this.latitude,
    required this.longitude,
    this.parentId,
    required this.postId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'content': content,
      'latitude': latitude,
      'longitude': longitude,
      'postId': postId,
    };
    if (parentId != null) {
      data['parentId'] = parentId;
    }
    return data;
  }
}

class PostsMyListReq {
  /// 页码
  final int pageNum;

  /// 条数
  final int pageSize;

  /// 用户id
  final int? uid;

  PostsMyListReq({required this.pageNum, required this.pageSize, this.uid});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'pageNum': pageNum,
      'pageSize': pageSize,
    };
    if (uid != null) {
      data['uid'] = uid;
    }
    return data;
  }
}

class PostsCreateReq {
  /// 动态内容
  final String content;

  /// 动态图片
  final List<String> imageList;

  // /// 纬度
  // final double latitude;

  // /// 经度
  // final double longitude;

  PostsCreateReq({
    required this.content,
    required this.imageList,
    // required this.latitude,
    // required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'imageList': imageList,
      // 'latitude': latitude,
      // 'longitude': longitude,
    };
  }
}

class MsgListReq {
  final int pageNum;
  final int pageSize;

  MsgListReq({required this.pageNum, required this.pageSize});

  Map<String, dynamic> toJson() {
    return {'pageNum': pageNum, 'pageSize': pageSize};
  }
}

// --- 响应模型 ---

class NotificationItem {
  final String? commentContent;
  final int? commentId;
  final String? content;
  final String? contentPreview;
  final String? createTime;
  final int? id;
  final int? notificationType;
  final int? parentCommentId;
  final String? photoPreview;
  final int? postId;
  final String? triggerAvatar;
  final String? triggerName;
  final int? triggerUid;

  NotificationItem({
    this.commentContent,
    this.commentId,
    this.content,
    this.contentPreview,
    this.createTime,
    this.id,
    this.notificationType,
    this.parentCommentId,
    this.photoPreview,
    this.postId,
    this.triggerAvatar,
    this.triggerName,
    this.triggerUid,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      commentContent: json['commentContent'],
      commentId: json['commentId'],
      content: json['content'],
      contentPreview: json['contentPreview'],
      createTime: json['createTime'],
      id: json['id'],
      notificationType: json['notificationType'],
      parentCommentId: json['parentCommentId'],
      photoPreview: json['photoPreview'],
      postId: json['postId'],
      triggerAvatar: json['triggerAvatar'],
      triggerName: json['triggerName'],
      triggerUid: json['triggerUid'],
    );
  }
}

class MsgListRespData {
  final bool? hasNext;
  final List<NotificationItem>? list;

  MsgListRespData({this.hasNext, this.list});

  factory MsgListRespData.fromJson(Map<String, dynamic> json) {
    return MsgListRespData(
      hasNext: json['hasNext'],
      list: json['list'] != null
          ? (json['list'] as List)
                .map((i) => NotificationItem.fromJson(i))
                .toList()
          : null,
    );
  }
}

class MsgListResp {
  final int code;
  final MsgListRespData? data;
  final String? message;

  MsgListResp({required this.code, this.data, this.message});

  factory MsgListResp.fromJson(Map<String, dynamic> json) {
    return MsgListResp(
      code: json['code'],
      data: json['data'] != null
          ? MsgListRespData.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }
}

class PostInfo {
  final int? age;
  final String? avatar;
  final bool? canDelete;
  final String? city;
  final int? commentCount;
  final String? content;
  final String? createTime;
  final int? id;
  final List<String>? imageList;
  final bool? isLiked;
  final int? likeCount;
  final int? realType;
  final int? sex;
  final int? uid;
  final String? userName;
  final int? vip;

  PostInfo({
    this.age,
    this.avatar,
    this.canDelete,
    this.city,
    this.commentCount,
    this.content,
    this.createTime,
    this.id,
    this.imageList,
    this.isLiked,
    this.likeCount,
    this.realType,
    this.sex,
    this.uid,
    this.userName,
    this.vip,
  });

  factory PostInfo.fromJson(Map<String, dynamic> json) {
    return PostInfo(
      age: json['age'],
      avatar: json['avatar'],
      canDelete: json['canDelete'],
      city: json['city'],
      commentCount: json['commentCount'],
      content: json['content'],
      createTime: json['createTime'],
      id: json['id'],
      imageList: json['imageList'] != null
          ? List<String>.from(json['imageList'])
          : null,
      isLiked: json['isLiked'],
      likeCount: json['likeCount'],
      realType: json['realType'],
      sex: json['sex'],
      uid: json['uid'],
      userName: json['userName'],
      vip: json['vip'],
    );
  }
}

class PostsListRespData {
  final bool? hasNext;
  final List<PostInfo>? list;

  PostsListRespData({this.hasNext, this.list});

  factory PostsListRespData.fromJson(Map<String, dynamic> json) {
    return PostsListRespData(
      hasNext: json['hasNext'],
      list: json['list'] != null
          ? (json['list'] as List).map((i) => PostInfo.fromJson(i)).toList()
          : null,
    );
  }
}

class CommentInfo {
  /// 头像
  final String? avatar;

  /// 城市
  final String? city;

  /// 子评论数
  final int? commentCount;

  /// 评论ID
  final int? commentId;

  /// 评论内容
  final String? content;

  /// 创建时间
  final String? createTime;

  /// 创建时间-文本
  final String? createTimeTxt;

  /// 评论深度
  final int? depth;

  /// 是否已点赞
  final bool? isLiked;

  /// 点赞数
  final int? likeCount;

  /// 父评论ID
  final int? parentId;

  /// 回复列表
  final List<CommentInfo>? replies;

  /// 根评论ID
  final int? rootId;

  /// 回复的目标用户昵称
  final String? targetNickname;

  /// 用户ID
  final int? uid;

  /// 用户名
  final String? userName;

  CommentInfo({
    this.avatar,
    this.city,
    this.commentCount,
    this.commentId,
    this.content,
    this.createTime,
    this.createTimeTxt,
    this.depth,
    this.isLiked,
    this.likeCount,
    this.parentId,
    this.replies,
    this.rootId,
    this.targetNickname,
    this.uid,
    this.userName,
  });

  factory CommentInfo.fromJson(Map<String, dynamic> json) {
    return CommentInfo(
      avatar: json['avatar'],
      city: json['city'],
      commentCount: json['commentCount'],
      commentId: json['commentId'],
      content: json['content'],
      createTime: json['createTime'],
      createTimeTxt: json['createTimeTxt'],
      depth: json['depth'],
      isLiked: json['isLiked'],
      likeCount: json['likeCount'],
      parentId: json['parentId'],
      replies: json['replies'] != null
          ? (json['replies'] as List)
                .map((i) => CommentInfo.fromJson(i))
                .toList()
          : null,
      rootId: json['rootId'],
      targetNickname: json['targetNickname'],
      uid: json['uid'],
      userName: json['userName'],
    );
  }
}

class PostsCommentListRespData {
  final bool? hasNext;
  final List<CommentInfo>? list;

  PostsCommentListRespData({this.hasNext, this.list});

  factory PostsCommentListRespData.fromJson(Map<String, dynamic> json) {
    return PostsCommentListRespData(
      hasNext: json['hasNext'],
      list: json['list'] != null
          ? (json['list'] as List).map((i) => CommentInfo.fromJson(i)).toList()
          : null,
    );
  }
}

class PostsCommentListResp {
  final int code;
  final PostsCommentListRespData? data;
  final String? message;

  PostsCommentListResp({required this.code, this.data, this.message});

  factory PostsCommentListResp.fromJson(Map<String, dynamic> json) {
    return PostsCommentListResp(
      code: json['code'],
      data: json['data'] != null
          ? PostsCommentListRespData.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }
}

class PostsCommentsAddResp {
  final int code;
  final CommentInfo? data;
  final String? message;

  PostsCommentsAddResp({required this.code, this.data, this.message});

  factory PostsCommentsAddResp.fromJson(Map<String, dynamic> json) {
    return PostsCommentsAddResp(
      code: json['code'],
      data: json['data'] != null ? CommentInfo.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class PostsListResp {
  final int code;
  final PostsListRespData? data;
  final String? message;

  PostsListResp({required this.code, this.data, this.message});

  factory PostsListResp.fromJson(Map<String, dynamic> json) {
    return PostsListResp(
      code: json['code'],
      data: json['data'] != null
          ? PostsListRespData.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }
}

class PostsCreateResp {
  final int code;
  final String? message;

  PostsCreateResp({required this.code, this.message});

  factory PostsCreateResp.fromJson(Map<String, dynamic> json) {
    return PostsCreateResp(code: json['code'], message: json['message']);
  }
}

class PostsDetailResp {
  final int code;
  final PostInfo? data;
  final String? message;

  PostsDetailResp({required this.code, this.data, this.message});

  factory PostsDetailResp.fromJson(Map<String, dynamic> json) {
    return PostsDetailResp(
      code: json['code'],
      data: json['data'] != null ? PostInfo.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class UnreadCountResp {
  final int code;
  final int? data;
  final String? message;

  UnreadCountResp({required this.code, this.data, this.message});

  factory UnreadCountResp.fromJson(Map<String, dynamic> json) {
    return UnreadCountResp(
      code: json['code'],
      data: json['data'],
      message: json['message'],
    );
  }
}
