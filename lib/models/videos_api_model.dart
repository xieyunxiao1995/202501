class VideoRecommendReq {
  /// 对方用户视频id，在空间点击视频时传
  final int? id;

  /// 页码
  final int pageNum;

  /// 条数
  final int pageSize;

  /// 对方用户id，在空间点击视频时传，只返回当前用户的视频
  final int? toUid;

  VideoRecommendReq({
    this.id,
    required this.pageNum,
    required this.pageSize,
    this.toUid,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'pageNum': pageNum,
      'pageSize': pageSize,
    };
    if (id != null) data['id'] = id;
    if (toUid != null) data['toUid'] = toUid;
    return data;
  }
}

class VideoInfo {
  /// 用户头像
  final String? avatar;

  /// 封面图路径
  final String? coverUrl;

  /// 创建时间
  final String? createTime;

  /// 作品描述(最多100字)
  final String? description;

  /// id
  final int? id;

  /// 是否喜欢-作者
  final bool? isLikeUser;

  /// 是否点赞-视频
  final bool? isLikeVideo;

  /// 喜欢数-作者
  final int? likeCountUser;

  /// 点赞数-视频
  final int? likeCountVideo;

  /// 用户id
  final int? uid;

  /// 用户昵称
  final String? userName;

  /// 视频存储路径
  final String? videoUrl;

  VideoInfo({
    this.avatar,
    this.coverUrl,
    this.createTime,
    this.description,
    this.id,
    this.isLikeUser,
    this.isLikeVideo,
    this.likeCountUser,
    this.likeCountVideo,
    this.uid,
    this.userName,
    this.videoUrl,
  });

  factory VideoInfo.fromJson(Map<String, dynamic> json) {
    return VideoInfo(
      avatar: json['avatar'],
      coverUrl: json['coverUrl'],
      createTime: json['createTime'],
      description: json['description'],
      id: json['id'],
      isLikeUser: json['isLikeUser'],
      isLikeVideo: json['isLikeVideo'],
      likeCountUser: json['likeCountUser'],
      likeCountVideo: json['likeCountVideo'],
      uid: json['uid'],
      userName: json['userName'],
      videoUrl: json['videoUrl'],
    );
  }
}

class VideoRecommendRespData {
  final bool? hasNext;
  final List<VideoInfo>? list;

  VideoRecommendRespData({this.hasNext, this.list});

  factory VideoRecommendRespData.fromJson(Map<String, dynamic> json) {
    return VideoRecommendRespData(
      hasNext: json['hasNext'],
      list: json['list'] != null
          ? (json['list'] as List).map((i) => VideoInfo.fromJson(i)).toList()
          : null,
    );
  }
}

class VideoRecommendResp {
  final int code;
  final VideoRecommendRespData? data;
  final String? message;

  VideoRecommendResp({required this.code, this.data, this.message});

  factory VideoRecommendResp.fromJson(Map<String, dynamic> json) {
    return VideoRecommendResp(
      code: json['code'],
      data: json['data'] != null
          ? VideoRecommendRespData.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }
}
