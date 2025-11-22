// --- City List Models ---

class CityInfo {
  final String? code;
  final String? name;
  final List<CityInfo>? list;

  CityInfo({this.code, this.name, this.list});

  factory CityInfo.fromJson(Map<String, dynamic> json) {
    return CityInfo(
      code: json['code'],
      name: json['name'],
      list: json['list'] != null
          ? (json['list'] as List).map((i) => CityInfo.fromJson(i)).toList()
          : null,
    );
  }
}

class GetCityListResp {
  final int code;
  final List<CityInfo>? data;
  final String? message;

  GetCityListResp({required this.code, this.data, this.message});

  factory GetCityListResp.fromJson(Map<String, dynamic> json) {
    return GetCityListResp(
      code: json['code'],
      data: json['data'] != null
          ? (json['data'] as List).map((i) => CityInfo.fromJson(i)).toList()
          : null,
      message: json['message'],
    );
  }
}

class LocationCityInfo {
  final String? cityCode;
  final String? cityName;
  // The 'list' field is recursive and complex, defining it simply for now.
  // In a real scenario, this would need a more detailed class structure if used.
  final List<dynamic>? list;

  LocationCityInfo({this.cityCode, this.cityName, this.list});

  factory LocationCityInfo.fromJson(Map<String, dynamic> json) {
    return LocationCityInfo(
      cityCode: json['cityCode'],
      cityName: json['cityName'],
      list: json['list'],
    );
  }
}

class LocationCityResp {
  final int code;
  final LocationCityInfo? data;
  final String? message;

  LocationCityResp({required this.code, this.data, this.message});

  factory LocationCityResp.fromJson(Map<String, dynamic> json) {
    return LocationCityResp(
      code: json['code'],
      data: json['data'] != null
          ? LocationCityInfo.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }
}

// --- Tab All ---

class BannerInfo {
  /// 广告Banner图URL
  final String? bannerUrl;

  /// 广告ID
  final int? id;

  /// 广告跳转URL
  final String? redirectUrl;

  /// 标题
  final String? title;

  BannerInfo({this.bannerUrl, this.id, this.redirectUrl, this.title});

  factory BannerInfo.fromJson(Map<String, dynamic> json) {
    return BannerInfo(
      bannerUrl: json['bannerUrl'],
      id: json['id'],
      redirectUrl: json['redirectUrl'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'bannerUrl': bannerUrl,
      'id': id,
      'redirectUrl': redirectUrl,
      'title': title,
    };
  }
}

class AdBanner {
  /// 广告Banner轮播配置
  final List<BannerInfo>? bannerList;

  AdBanner({this.bannerList});

  factory AdBanner.fromJson(Map<String, dynamic> json) {
    return AdBanner(
      bannerList: json['bannerList'] != null
          ? (json['bannerList'] as List)
                .map((i) => BannerInfo.fromJson(i))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'bannerList': bannerList?.map((v) => v.toJson()).toList()};
  }
}

class TabInfo {
  /// tab名称
  final String? name;

  /// tab类型 1附近 2活跃 3新人
  final int? type;

  TabInfo({this.name, this.type});

  factory TabInfo.fromJson(Map<String, dynamic> json) {
    return TabInfo(name: json['name'], type: json['type']);
  }
}

class TabAllData {
  /// 广告Banner信息
  final AdBanner? adBanner;

  /// 个性标签，用于筛选器选择
  final List<String>? character;

  /// 默认iosTab 1首页 2宠友
  final int? defaultIosTab;

  /// 默认tab
  final int? defaultTab;

  /// 不让太近的人看到我，默认false
  final bool? hideFromNearby;

  /// ios 是否隐藏服务Tab 1隐藏 0显示
  final int? hideServiceTab;

  /// tab集合
  final List<TabInfo>? tabList;

  TabAllData({
    this.adBanner,
    this.character,
    this.defaultIosTab,
    this.defaultTab,
    this.hideFromNearby,
    this.hideServiceTab,
    this.tabList,
  });

  factory TabAllData.fromJson(Map<String, dynamic> json) {
    return TabAllData(
      adBanner: json['adBanner'] != null
          ? AdBanner.fromJson(json['adBanner'])
          : null,
      character: json['character'] != null
          ? List<String>.from(json['character'])
          : null,
      defaultIosTab: json['defaultIosTab'],
      defaultTab: json['defaultTab'],
      hideFromNearby: json['hideFromNearby'],
      hideServiceTab: json['hideServiceTab'],
      tabList: json['tabList'] != null
          ? (json['tabList'] as List).map((i) => TabInfo.fromJson(i)).toList()
          : null,
    );
  }
}

// --- Index User List ---

class IndexUserListReq {
  /// 城市编码 - 查询附近用户时必填
  final String? cityCode;

  /// 过滤状态，筛选请求时填写 true，否则筛选条件不生效
  final bool? filterStatus;

  /// 不让太近的人看到我，默认 false
  final bool? hideFromNearby;

  /// 纬度（必填）
  final double latitude;

  /// 经度（必填）
  final double longitude;

  /// 最大年龄，最高限制 40，空值则不限
  final int? maxAge;

  /// 最小年龄，默认 18
  final int? minAge;

  /// 选择其他城市时使用的城市编码
  final String? modifiedCityCode;

  /// 只看认证用户，默认 false
  final bool? onlyCertified;

  /// 页码（必填）
  final int pageNum;

  /// 每页条数（必填）
  final int pageSize;

  /// 优先查看距离近的用户，默认 false
  final bool? priorityDistance;

  /// 优先查看在线用户，默认 false
  final bool? priorityOnline;

  /// 包含指定标签
  final String? selectedTag;

  /// tab 类型：1 附近，2 活跃，3 新人（必填）
  final int type;

  IndexUserListReq({
    this.cityCode,
    this.filterStatus,
    this.hideFromNearby,
    required this.latitude,
    required this.longitude,
    this.maxAge,
    this.minAge,
    this.modifiedCityCode,
    this.onlyCertified,
    required this.pageNum,
    required this.pageSize,
    this.priorityDistance,
    this.priorityOnline,
    this.selectedTag,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'latitude': latitude,
      'longitude': longitude,
      'pageNum': pageNum,
      'pageSize': pageSize,
      'type': type,
    };
    if (cityCode != null) data['cityCode'] = cityCode;
    if (filterStatus != null) data['filterStatus'] = filterStatus;
    if (hideFromNearby != null) data['hideFromNearby'] = hideFromNearby;
    if (maxAge != null) data['maxAge'] = maxAge;
    if (minAge != null) data['minAge'] = minAge;
    if (modifiedCityCode != null) data['modifiedCityCode'] = modifiedCityCode;
    if (onlyCertified != null) data['onlyCertified'] = onlyCertified;
    if (priorityDistance != null) data['priorityDistance'] = priorityDistance;
    if (priorityOnline != null) data['priorityOnline'] = priorityOnline;
    if (selectedTag != null) data['selectedTag'] = selectedTag;
    return data;
  }
}

class UserAlbum {
  final String? albumUrl;
  final String? createTime;
  final int? id;
  final int? similarity;
  final int? uid;
  final String? updateTime;

  UserAlbum({
    this.albumUrl,
    this.createTime,
    this.id,
    this.similarity,
    this.uid,
    this.updateTime,
  });

  factory UserAlbum.fromJson(Map<String, dynamic> json) {
    return UserAlbum(
      albumUrl: json['albumUrl'],
      createTime: json['createTime'],
      id: json['id'],
      similarity: json['similarity'],
      uid: json['uid'],
      updateTime: json['updateTime'],
    );
  }
}

class IndexUserInfo {
  final int? age;
  final String? avatar;
  final int? avatarSimilarity;
  final String? cityName;
  final int? distance;
  final String? figure;
  final int? height;
  final bool? isLike;
  final String? label;
  final String? lastOnlineTime;
  final String? occupation;
  final int? online;
  final String? onlineTxt;
  final String? petType;
  final int? realType;
  final int? uid;
  final List<UserAlbum>? userAlbums;
  final String? userName;
  final int? vip;

  IndexUserInfo({
    this.age,
    this.avatar,
    this.avatarSimilarity,
    this.cityName,
    this.distance,
    this.figure,
    this.height,
    this.isLike,
    this.label,
    this.lastOnlineTime,
    this.occupation,
    this.online,
    this.onlineTxt,
    this.petType,
    this.realType,
    this.uid,
    this.userAlbums,
    this.userName,
    this.vip,
  });

  factory IndexUserInfo.fromJson(Map<String, dynamic> json) {
    return IndexUserInfo(
      age: json['age'],
      avatar: json['avatar'],
      avatarSimilarity: json['avatarSimilarity'],
      cityName: json['cityName'],
      distance: json['distance'],
      figure: json['figure'],
      height: json['height'],
      isLike: json['isLike'],
      label: json['label'],
      lastOnlineTime: json['lastOnlineTime'],
      occupation: json['occupation'],
      online: json['online'],
      onlineTxt: json['onlineTxt'],
      petType: json['petType'],
      realType: json['realType'],
      uid: json['uid'],
      userAlbums: json['userAlbums'] != null
          ? (json['userAlbums'] as List)
                .map((i) => UserAlbum.fromJson(i))
                .toList()
          : null,
      userName: json['userName'],
      vip: json['vip'],
    );
  }
}

class IndexUserListPage {
  final bool? hasNext;
  final List<IndexUserInfo>? list;

  IndexUserListPage({this.hasNext, this.list});

  factory IndexUserListPage.fromJson(Map<String, dynamic> json) {
    return IndexUserListPage(
      hasNext: json['hasNext'],
      list: json['list'] != null
          ? (json['list'] as List)
                .map((i) => IndexUserInfo.fromJson(i))
                .toList()
          : null,
    );
  }
}

class IndexUserListData {
  final IndexUserListPage? page;
  final int? vip;

  IndexUserListData({this.page, this.vip});

  factory IndexUserListData.fromJson(Map<String, dynamic> json) {
    return IndexUserListData(
      page: json['page'] != null
          ? IndexUserListPage.fromJson(json['page'])
          : null,
      vip: json['vip'],
    );
  }
}

class IndexUserListResp {
  final int code;
  final IndexUserListData? data;
  final String? message;

  IndexUserListResp({required this.code, this.data, this.message});

  factory IndexUserListResp.fromJson(Map<String, dynamic> json) {
    return IndexUserListResp(
      code: json['code'],
      data: json['data'] != null
          ? IndexUserListData.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }
}

class GetTabAllResp {
  final int code;
  final TabAllData? data;
  final String? message;

  GetTabAllResp({required this.code, this.data, this.message});

  factory GetTabAllResp.fromJson(Map<String, dynamic> json) {
    return GetTabAllResp(
      code: json['code'],
      data: json['data'] != null ? TabAllData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

// --- Search User ---

class SearchUserReq {
  final String keyword;
  final double latitude;
  final double longitude;
  final int pageNum;
  final int pageSize;

  SearchUserReq({
    required this.keyword,
    required this.latitude,
    required this.longitude,
    required this.pageNum,
    required this.pageSize,
  });

  Map<String, dynamic> toJson() {
    return {
      'keyword': keyword,
      'latitude': latitude,
      'longitude': longitude,
      'pageNum': pageNum,
      'pageSize': pageSize,
    };
  }
}

class SearchUserPage {
  final bool? hasNext;
  final List<IndexUserInfo>? list;

  SearchUserPage({this.hasNext, this.list});

  factory SearchUserPage.fromJson(Map<String, dynamic> json) {
    return SearchUserPage(
      hasNext: json['hasNext'],
      list: json['list'] != null
          ? (json['list'] as List)
                .map((i) => IndexUserInfo.fromJson(i))
                .toList()
          : null,
    );
  }
}

class SearchUserData {
  final SearchUserPage? page;
  final int? vip;

  SearchUserData({this.page, this.vip});

  factory SearchUserData.fromJson(Map<String, dynamic> json) {
    return SearchUserData(
      page: json['page'] != null ? SearchUserPage.fromJson(json['page']) : null,
      vip: json['vip'],
    );
  }
}

class SearchUserResp {
  final int code;
  final SearchUserData? data;
  final String? message;

  SearchUserResp({required this.code, this.data, this.message});

  factory SearchUserResp.fromJson(Map<String, dynamic> json) {
    return SearchUserResp(
      code: json['code'],
      data: json['data'] != null ? SearchUserData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}
