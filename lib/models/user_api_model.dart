import 'package:zhenyu_flutter/models/index_api_model.dart';

// --- Enums ---

enum SmsScene { login, forgetPassword, resetPassword, bindMobile }

extension SmsSceneExtension on SmsScene {
  String toJsonValue() {
    switch (this) {
      case SmsScene.login:
        return 'LOGIN';
      case SmsScene.forgetPassword:
        return 'FORGET_PASSWORD';
      case SmsScene.resetPassword:
        return 'RESET_PASSWORD';
      case SmsScene.bindMobile:
        return 'BIND_MOBILE';
    }
  }
}

enum LoginType { oneKey, pwd, verCode, wx, wxMp }

extension LoginTypeExtension on LoginType {
  String toJsonValue() {
    switch (this) {
      case LoginType.oneKey:
        return 'ONE_KEY';
      case LoginType.pwd:
        return 'PWD';
      case LoginType.verCode:
        return 'VER_CODE';
      case LoginType.wx:
        return 'WX';
      case LoginType.wxMp:
        return 'WX_MP';
    }
  }
}

// --- Get User Profile Models ---

class UserProfileItem {
  final List<String>? defaultLabels;
  final String? description;
  final int? limit;
  final String? name;
  final List<String>? useLabels;

  UserProfileItem({
    this.defaultLabels,
    this.description,
    this.limit,
    this.name,
    this.useLabels,
  });

  factory UserProfileItem.fromJson(Map<String, dynamic> json) {
    return UserProfileItem(
      defaultLabels: json['defaultLabels'] != null
          ? List<String>.from(json['defaultLabels'])
          : null,
      description: json['description'],
      limit: json['limit'],
      name: json['name'],
      useLabels: json['useLabels'] != null
          ? List<String>.from(json['useLabels'])
          : null,
    );
  }
}

class GetUserProfileData {
  final List<UserProfileItem>? userProfile;

  GetUserProfileData({this.userProfile});

  factory GetUserProfileData.fromJson(Map<String, dynamic> json) {
    return GetUserProfileData(
      userProfile: json['userProfile'] != null
          ? (json['userProfile'] as List)
                .map((i) => UserProfileItem.fromJson(i))
                .toList()
          : null,
    );
  }
}

class GetUserProfileResp {
  final int code;
  final GetUserProfileData? data;
  final String? message;

  GetUserProfileResp({required this.code, this.data, this.message});

  factory GetUserProfileResp.fromJson(Map<String, dynamic> json) {
    return GetUserProfileResp(
      code: json['code'],
      data: json['data'] != null
          ? GetUserProfileData.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }
}

class RandomNameReq {
  final int sex;

  RandomNameReq({required this.sex});

  Map<String, dynamic> toJson() => {'sex': sex};
}

class RandomNameResp {
  final int code;
  final String? data;
  final String? message;

  RandomNameResp({required this.code, this.data, this.message});

  factory RandomNameResp.fromJson(Map<String, dynamic> json) {
    return RandomNameResp(
      code: json['code'],
      data: json['data'],
      message: json['message'],
    );
  }
}

class RandomAvatarReq {
  final int sex;

  RandomAvatarReq({required this.sex});

  Map<String, dynamic> toJson() => {'sex': sex};
}

class RandomAvatarResp {
  final int code;
  final String? data;
  final String? message;

  RandomAvatarResp({required this.code, this.data, this.message});

  factory RandomAvatarResp.fromJson(Map<String, dynamic> json) {
    return RandomAvatarResp(
      code: json['code'],
      data: json['data'],
      message: json['message'],
    );
  }
}

class ChatHeadInfoReq {
  final int toUid;

  ChatHeadInfoReq({required this.toUid});

  Map<String, dynamic> toJson() => {'toUid': toUid};
}

class ChatHeadInfoResp {
  final int code;
  final ChatHeadInfoData? data;
  final String? message;

  ChatHeadInfoResp({required this.code, this.data, this.message});

  factory ChatHeadInfoResp.fromJson(Map<String, dynamic> json) =>
      ChatHeadInfoResp(
        code: json['code'] as int? ?? -1,
        data: json['data'] != null
            ? ChatHeadInfoData.fromJson(json['data'] as Map<String, dynamic>)
            : null,
        message: json['message'] as String?,
      );
}

class ChatHeadInfoData {
  final String? accountType;
  final String? avatar;
  final int blackStatus;
  final int realType;
  final int unlockRemainingDay;
  final int unlockRemainingSecond;
  final int unlockStatus;
  final String? userName;
  final String? userNumber;
  final int vip;
  final String? wxAccount;

  ChatHeadInfoData({
    this.accountType,
    this.avatar,
    required this.blackStatus,
    required this.realType,
    required this.unlockRemainingDay,
    required this.unlockRemainingSecond,
    required this.unlockStatus,
    this.userName,
    this.userNumber,
    required this.vip,
    this.wxAccount,
  });

  factory ChatHeadInfoData.fromJson(Map<String, dynamic> json) =>
      ChatHeadInfoData(
        accountType: json['accountType'] as String?,
        avatar: json['avatar'] as String?,
        blackStatus: json['blackStatus'] as int? ?? 0,
        realType: json['realType'] as int? ?? 0,
        unlockRemainingDay: json['unlockRemainingDay'] as int? ?? 0,
        unlockRemainingSecond: json['unlockRemainingSecond'] as int? ?? 0,
        unlockStatus: json['unlockStatus'] as int? ?? 0,
        userName: json['userName'] as String?,
        userNumber: json['userNumber'] as String?,
        vip: json['vip'] as int? ?? 0,
        wxAccount: json['wxAccount'] as String?,
      );
}

// --- Login and User Models ---

class GetSmsData {
  final String phone;
  final SmsScene scene;

  GetSmsData({required this.phone, required this.scene});

  Map<String, dynamic> toJson() {
    return {'phone': phone, 'scene': scene.toJsonValue()};
  }
}

class LoginData {
  final LoginType loginType;
  final String? mobile;
  final String? code;
  final String? password;
  final String? token;
  final String? unionid;
  final String? wxCode;
  final String? carrier;

  LoginData({
    required this.loginType,
    this.mobile,
    this.code,
    this.password,
    this.token,
    this.unionid,
    this.wxCode,
    this.carrier,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'loginType': loginType.toJsonValue()};
    if (mobile != null) data['mobile'] = mobile;
    if (code != null) data['code'] = code;
    if (password != null) data['password'] = password;
    if (token != null) data['token'] = token;
    if (unionid != null) data['unionid'] = unionid;
    if (wxCode != null) data['wxCode'] = wxCode;
    if (carrier != null) data['carrier'] = carrier;
    return data;
  }
}

class LoginRespData {
  final String? avatar;
  final int? businessCode;
  final String? extraParam;
  final int? hasBindMobile;
  final int? id;
  final String? mobile;
  final String? reviewMessage;
  final String? reviewParam;
  final int? reviewStatus;
  final int? reviewType;
  final int? sex;
  final String? unionId;
  final String? userName;
  final String? userNumber;
  final String? userSig;
  final String? userToken;

  LoginRespData({
    this.avatar,
    this.businessCode,
    this.extraParam,
    this.hasBindMobile,
    this.id,
    this.mobile,
    this.reviewMessage,
    this.reviewParam,
    this.reviewStatus,
    this.reviewType,
    this.sex,
    this.unionId,
    this.userName,
    this.userNumber,
    this.userSig,
    this.userToken,
  });

  factory LoginRespData.fromJson(Map<String, dynamic> json) {
    return LoginRespData(
      avatar: json['avatar'],
      businessCode: json['businessCode'],
      extraParam: json['extraParam'],
      hasBindMobile: json['hasBindMobile'],
      id: json['id'],
      mobile: json['mobile'],
      reviewMessage: json['reviewMessage'],
      reviewParam: json['reviewParam'],
      reviewStatus: json['reviewStatus'],
      reviewType: json['reviewType'],
      sex: json['sex'],
      unionId: json['unionId'],
      userName: json['userName'],
      userNumber: json['userNumber'],
      userSig: json['userSig'],
      userToken: json['userToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'businessCode': businessCode,
      'extraParam': extraParam,
      'hasBindMobile': hasBindMobile,
      'id': id,
      'mobile': mobile,
      'reviewMessage': reviewMessage,
      'reviewParam': reviewParam,
      'reviewStatus': reviewStatus,
      'reviewType': reviewType,
      'sex': sex,
      'unionId': unionId,
      'userName': userName,
      'userNumber': userNumber,
      'userSig': userSig,
      'userToken': userToken,
    };
  }
}

class LoginResp {
  final int code;
  final LoginRespData? data;
  final String? message;

  LoginResp({required this.code, this.data, this.message});

  factory LoginResp.fromJson(Map<String, dynamic> json) {
    return LoginResp(
      code: json['code'],
      data: json['data'] != null ? LoginRespData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

// --- 注册 ---
class UserRegisterData {
  final String? avatar;
  final String? birthday;
  final int? customName;
  final String? extraParam;
  final String? inviteCode;
  final String? mobile;
  final int? sex;
  final String? smsCode;
  final String? userName;

  UserRegisterData({
    this.avatar,
    this.birthday,
    this.customName,
    this.extraParam,
    this.inviteCode,
    this.mobile,
    this.sex,
    this.smsCode,
    this.userName,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (avatar != null) data['avatar'] = avatar;
    if (birthday != null) data['birthday'] = birthday;
    if (customName != null) data['customName'] = customName;
    if (extraParam != null) data['extraParam'] = extraParam;
    if (inviteCode != null) data['inviteCode'] = inviteCode;
    if (mobile != null) data['mobile'] = mobile;
    if (sex != null) data['sex'] = sex;
    if (smsCode != null) data['smsCode'] = smsCode;
    if (userName != null) data['userName'] = userName;
    return data;
  }
}

// --- 审核邀请码 ---
class ReviewInviteCodeData {
  /// 审核参数
  final String reviewParam;

  /// 邀请码
  final String inviteCode;

  ReviewInviteCodeData({required this.reviewParam, required this.inviteCode});

  Map<String, dynamic> toJson() {
    return {'reviewParam': reviewParam, 'inviteCode': inviteCode};
  }
}

/// 省市信息
class ProvinceCityInfo {
  final String? name;
  final List<String>? cities;

  ProvinceCityInfo({this.name, this.cities});

  factory ProvinceCityInfo.fromJson(Map<String, dynamic> json) {
    return ProvinceCityInfo(
      name: json['name'],
      cities: json['cities'] != null ? List<String>.from(json['cities']) : null,
    );
  }
}

/// 获取城市列表响应
class GetCitiesResp {
  final int code;
  final List<ProvinceCityInfo>? provinces;
  final String? message;

  GetCitiesResp({required this.code, this.provinces, this.message});

  factory GetCitiesResp.fromJson(Map<String, dynamic> json) {
    return GetCitiesResp(
      code: json['code'],
      provinces: json['data'] != null && json['data']['provinces'] != null
          ? (json['data']['provinces'] as List)
                .map((i) => ProvinceCityInfo.fromJson(i))
                .toList()
          : null,
      message: json['message'],
    );
  }
}

/// 活跃城市条目
class ActiveCityInfo {
  final String? code;
  final String? name;

  ActiveCityInfo({this.code, this.name});

  factory ActiveCityInfo.fromJson(Map<String, dynamic> json) {
    return ActiveCityInfo(code: json['code'], name: json['name']);
  }
}

/// 获取修改资料页面数据
class GetUpdateInfoResp {
  final int code;
  final UpdateInfoData? data;
  final String? message;

  GetUpdateInfoResp({required this.code, this.data, this.message});

  factory GetUpdateInfoResp.fromJson(Map<String, dynamic> json) {
    return GetUpdateInfoResp(
      code: json['code'],
      data: json['data'] != null ? UpdateInfoData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class UpdateInfoData {
  final List<ActiveCityInfo>? activeCityList;
  final String? albums;
  final String? albumsReview;
  final String? avatar;
  final String? birthday;
  final String? city;
  final String? defaultFigure;
  final String? defaultOccupation;
  final String? figure;
  final int? height;
  final String? occupation;
  final String? petType;
  final String? signature;
  final String? userName;
  final String? videos;
  final int? videosReviewStatus;
  final int? weight;

  UpdateInfoData({
    this.activeCityList,
    this.albums,
    this.albumsReview,
    this.avatar,
    this.birthday,
    this.city,
    this.defaultFigure,
    this.defaultOccupation,
    this.figure,
    this.height,
    this.occupation,
    this.petType,
    this.signature,
    this.userName,
    this.videos,
    this.videosReviewStatus,
    this.weight,
  });

  factory UpdateInfoData.fromJson(Map<String, dynamic> json) {
    return UpdateInfoData(
      activeCityList: json['activeCityList'] != null
          ? (json['activeCityList'] as List)
                .map((e) => ActiveCityInfo.fromJson(e))
                .toList()
          : null,
      albums: json['albums'],
      albumsReview: json['albumsReview'],
      avatar: json['avatar'],
      birthday: json['birthday'],
      city: json['city'],
      defaultFigure: json['defaultFigure'],
      defaultOccupation: json['defaultOccupation'],
      figure: json['figure'],
      height: json['height'],
      occupation: json['occupation'],
      petType: json['petType'],
      signature: json['signature'],
      userName: json['userName'],
      videos: json['videos'],
      videosReviewStatus: json['videosReviewStatus'],
      weight: json['weight'],
    );
  }

  UpdateInfoData copyWith({
    List<ActiveCityInfo>? activeCityList,
    String? albums,
    String? albumsReview,
    String? avatar,
    String? birthday,
    String? city,
    String? defaultFigure,
    String? defaultOccupation,
    String? figure,
    int? height,
    String? occupation,
    String? petType,
    String? signature,
    String? userName,
    String? videos,
    int? videosReviewStatus,
    int? weight,
  }) {
    return UpdateInfoData(
      activeCityList: activeCityList ?? this.activeCityList,
      albums: albums ?? this.albums,
      albumsReview: albumsReview ?? this.albumsReview,
      avatar: avatar ?? this.avatar,
      birthday: birthday ?? this.birthday,
      city: city ?? this.city,
      defaultFigure: defaultFigure ?? this.defaultFigure,
      defaultOccupation: defaultOccupation ?? this.defaultOccupation,
      figure: figure ?? this.figure,
      height: height ?? this.height,
      occupation: occupation ?? this.occupation,
      petType: petType ?? this.petType,
      signature: signature ?? this.signature,
      userName: userName ?? this.userName,
      videos: videos ?? this.videos,
      videosReviewStatus: videosReviewStatus ?? this.videosReviewStatus,
      weight: weight ?? this.weight,
    );
  }
}

class CheckInviteCodeReq {
  final String inviteCode;

  CheckInviteCodeReq({required this.inviteCode});

  Map<String, dynamic> toJson() {
    return {'inviteCode': inviteCode};
  }
}

class CheckInviteCodeResp {
  final int code;
  final Map<String, dynamic>? data;
  final String? message;

  CheckInviteCodeResp({required this.code, this.data, this.message});

  factory CheckInviteCodeResp.fromJson(Map<String, dynamic> json) {
    return CheckInviteCodeResp(
      code: json['code'],
      data: json['data'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['data'])
          : null,
      message: json['message'],
    );
  }
}

class FigureAndOccupationData {
  final String? defaultFigure;
  final String? defaultOccupation;

  FigureAndOccupationData({this.defaultFigure, this.defaultOccupation});

  factory FigureAndOccupationData.fromJson(Map<String, dynamic> json) {
    return FigureAndOccupationData(
      defaultFigure: json['defaultFigure'],
      defaultOccupation: json['defaultOccupation'],
    );
  }
}

class FigureAndOccupationResp {
  final int code;
  final FigureAndOccupationData? data;
  final String? message;

  FigureAndOccupationResp({required this.code, this.data, this.message});

  factory FigureAndOccupationResp.fromJson(Map<String, dynamic> json) {
    return FigureAndOccupationResp(
      code: json['code'],
      data: json['data'] != null
          ? FigureAndOccupationData.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }
}

class FemaleRegisterData {
  final String? avatar;
  final String? birthday;
  final int? customName;
  final String? extraParam;
  final String? figure;
  final int? height;
  final String? inviteCode;
  final String? mobile;
  final String? occupation;
  final int? sex;
  final String? smsCode;
  final String? userName;
  final int? weight;

  FemaleRegisterData({
    this.avatar,
    this.birthday,
    this.customName,
    this.extraParam,
    this.figure,
    this.height,
    this.inviteCode,
    this.mobile,
    this.occupation,
    this.sex,
    this.smsCode,
    this.userName,
    this.weight,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (avatar != null) data['avatar'] = avatar;
    if (birthday != null) data['birthday'] = birthday;
    if (customName != null) data['customName'] = customName;
    if (extraParam != null) data['extraParam'] = extraParam;
    if (figure != null) data['figure'] = figure;
    if (height != null) data['height'] = height;
    if (inviteCode != null) data['inviteCode'] = inviteCode;
    if (mobile != null) data['mobile'] = mobile;
    if (occupation != null) data['occupation'] = occupation;
    if (sex != null) data['sex'] = sex;
    if (smsCode != null) data['smsCode'] = smsCode;
    if (userName != null) data['userName'] = userName;
    if (weight != null) data['weight'] = weight;
    return data;
  }
}

/// 修改个人资料请求体
class UpdateUserProfileReq {
  /// 联系方式类型(QQ,WX)
  final String? accountType;

  /// 活跃城市列表(010_北京市,020_广州市)
  final String? activeCity;

  /// 用户相册(多个,逗号隔开)
  final String? albums;

  /// 用户头像
  final String? avatar;

  /// 生日
  final String? birthday;

  /// 身材
  final String? figure;

  /// 用户相册是否删除(仅支持单个删除)
  final bool? hasDel;

  /// 用户视频是否删除
  final bool? hasDelVideos;

  /// 身高
  final int? height;

  /// 标签(多个,分隔)
  final String? interestLabel;

  /// 标签类型
  final String? interestLabelType;

  /// 职业
  final String? occupation;

  /// 宠物类型
  final String? petType;

  /// 个人介绍(签名)
  final String? signature;

  /// 修改项
  final String updateDateType;

  /// 用户名称
  final String? userName;

  /// 用户视频
  final String? videos;

  /// 体重
  final int? weight;

  /// 微信号
  final String? wxAccount;

  UpdateUserProfileReq({
    required this.updateDateType,
    this.accountType,
    this.activeCity,
    this.albums,
    this.avatar,
    this.birthday,
    this.figure,
    this.hasDel,
    this.hasDelVideos,
    this.height,
    this.interestLabel,
    this.interestLabelType,
    this.occupation,
    this.petType,
    this.signature,
    this.userName,
    this.videos,
    this.weight,
    this.wxAccount,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{'updateDateType': updateDateType};
    if (accountType != null) data['accountType'] = accountType;
    if (activeCity != null) data['activeCity'] = activeCity;
    if (albums != null) data['albums'] = albums;
    if (avatar != null) data['avatar'] = avatar;
    if (birthday != null) data['birthday'] = birthday;
    if (figure != null) data['figure'] = figure;
    if (hasDel != null) data['hasDel'] = hasDel;
    if (hasDelVideos != null) data['hasDelVideos'] = hasDelVideos;
    if (height != null) data['height'] = height;
    if (interestLabel != null) data['interestLabel'] = interestLabel;
    if (interestLabelType != null) {
      data['interestLabelType'] = interestLabelType;
    }
    if (occupation != null) data['occupation'] = occupation;
    if (petType != null) data['petType'] = petType;
    if (signature != null) data['signature'] = signature;
    if (userName != null) data['userName'] = userName;
    if (videos != null) data['videos'] = videos;
    if (weight != null) data['weight'] = weight;
    if (wxAccount != null) data['wxAccount'] = wxAccount;
    return data;
  }
}

// --- 获取他人资料卡 ---

class GetOtherUserInfoReq {
  final int toUid;

  GetOtherUserInfoReq({required this.toUid});

  Map<String, dynamic> toJson() {
    return {'toUid': toUid};
  }
}

class ActiveCityItem {
  /// 城市编码
  final String? code;

  /// 城市名称
  final String? name;

  ActiveCityItem({this.code, this.name});

  factory ActiveCityItem.fromJson(Map<String, dynamic> json) {
    return ActiveCityItem(code: json['code'], name: json['name']);
  }
}

class AlbumsVo {
  /// 相册URL
  final String? albumsUrl;

  /// 相似度
  final int? similarity;

  AlbumsVo({this.albumsUrl, this.similarity});

  factory AlbumsVo.fromJson(Map<String, dynamic> json) {
    return AlbumsVo(
      albumsUrl: json['albumsUrl'],
      similarity: json['similarity'],
    );
  }
}

class ImpLabelItem {
  /// 名称
  final String? labelsName;

  /// 数量
  final int? markCount;

  ImpLabelItem({this.labelsName, this.markCount});

  factory ImpLabelItem.fromJson(Map<String, dynamic> json) {
    return ImpLabelItem(
      labelsName: json['labelsName'],
      markCount: json['markCount'],
    );
  }
}

class ImpLabels {
  /// 印象标签列表
  final List<ImpLabelItem>? list;

  ImpLabels({this.list});

  factory ImpLabels.fromJson(Map<String, dynamic> json) {
    return ImpLabels(
      list: json['list'] != null
          ? (json['list'] as List).map((i) => ImpLabelItem.fromJson(i)).toList()
          : null,
    );
  }
}

class VideoVo {
  /// 视频封面URL
  final String? coverUrl;

  /// 视频id
  final int? id;

  VideoVo({this.coverUrl, this.id});

  factory VideoVo.fromJson(Map<String, dynamic> json) {
    return VideoVo(coverUrl: json['coverUrl'], id: json['id']);
  }
}

class OtherUserInfo {
  /// 活跃城市列表
  final List<ActiveCityItem>? activeCityList;

  /// 年龄
  final int? age;

  /// 用户相册(多个,分隔)
  final String? albums;

  /// 用户相册列表
  final List<AlbumsVo>? albumsList;

  /// 用户头像
  final String? avatar;

  /// 业务code码 0正常返回资料信息 -1免费次数即将用完，提示充值VIP(可跳过) -2免费次数已用完,必须充值VIP(不可跳过)
  final int? businessCode;

  /// 标签(多个逗号隔开)
  final String? characterLabel;

  /// 是否允许点评印象(0不允许 1允许)
  final int? checkAllowEvaluate;

  /// 星座
  final String? constellation;

  /// 印象标签(默认可选，逗号隔开)
  final String? defaultImpLabels;

  /// 距离(单位米)
  final int? distance;

  /// 身材
  final String? figure;

  /// 身高
  final int? height;

  /// 印象标签
  final ImpLabels? impLabels;

  /// 兴趣标签(多个逗号隔开)
  final String? interestLabel;

  /// 喜欢数量
  final int? likeCount;

  /// 喜欢状态(0未添加喜欢 1已添加喜欢)
  final int? likeStatus;

  /// 当前所在城市
  final String? locationCity;

  /// 职业
  final String? occupation;

  /// 在线状态 0不在线 1在线
  final int? online;

  /// 在线状态中文 显示xx小时前在线
  final String? onlineValue;

  /// 认证类型 0未认证 1真人
  final int? realType;

  /// 性别 0女 1男
  final int? sex;

  /// 个人介绍(签名)
  final String? signature;

  /// businessCode=-1,-2返回，平台限制每日访问总次数(默认10)
  final int? todayVisitsLimit;

  /// 用户名称
  final String? userName;

  /// 用户显示ID
  final String? userNumber;

  /// businessCode=-1,-2返回 用户剩余访问次数
  final int? userVisitsCount;

  /// 用户短视频列表
  final List<VideoVo>? videoList;

  /// 用户相册视频
  final String? videos;

  /// 是否VIP 0否 1是
  final int? vip;

  /// 体重
  final int? weight;

  OtherUserInfo({
    this.activeCityList,
    this.age,
    this.albums,
    this.albumsList,
    this.avatar,
    this.businessCode,
    this.characterLabel,
    this.checkAllowEvaluate,
    this.constellation,
    this.defaultImpLabels,
    this.distance,
    this.figure,
    this.height,
    this.impLabels,
    this.interestLabel,
    this.likeCount,
    this.likeStatus,
    this.locationCity,
    this.occupation,
    this.online,
    this.onlineValue,
    this.realType,
    this.sex,
    this.signature,
    this.todayVisitsLimit,
    this.userName,
    this.userNumber,
    this.userVisitsCount,
    this.videoList,
    this.videos,
    this.vip,
    this.weight,
  });

  factory OtherUserInfo.fromJson(Map<String, dynamic> json) {
    return OtherUserInfo(
      activeCityList: json['activeCityList'] != null
          ? (json['activeCityList'] as List)
                .map((i) => ActiveCityItem.fromJson(i))
                .toList()
          : null,
      age: json['age'],
      albums: json['albums'],
      albumsList: json['albumsList'] != null
          ? (json['albumsList'] as List)
                .map((i) => AlbumsVo.fromJson(i))
                .toList()
          : null,
      avatar: json['avatar'],
      businessCode: json['businessCode'],
      characterLabel: json['characterLabel'],
      checkAllowEvaluate: json['checkAllowEvaluate'],
      constellation: json['constellation'],
      defaultImpLabels: json['defaultImpLabels'],
      distance: json['distance'],
      figure: json['figure'],
      height: json['height'],
      impLabels: json['impLabels'] != null
          ? ImpLabels.fromJson(json['impLabels'])
          : null,
      interestLabel: json['interestLabel'],
      likeCount: json['likeCount'],
      likeStatus: json['likeStatus'],
      locationCity: json['locationCity'],
      occupation: json['occupation'],
      online: json['online'],
      onlineValue: json['onlineValue'],
      realType: json['realType'],
      sex: json['sex'],
      signature: json['signature'],
      todayVisitsLimit: json['todayVisitsLimit'],
      userName: json['userName'],
      userNumber: json['userNumber'],
      userVisitsCount: json['userVisitsCount'],
      videoList: json['videoList'] != null
          ? (json['videoList'] as List).map((i) => VideoVo.fromJson(i)).toList()
          : null,
      videos: json['videos'],
      vip: json['vip'],
      weight: json['weight'],
    );
  }
}

class GetOtherUserInfoResp {
  /// 状态码
  final int code;

  /// 数据
  final OtherUserInfo? data;

  /// 错误信息
  final String? message;

  GetOtherUserInfoResp({required this.code, this.data, this.message});

  factory GetOtherUserInfoResp.fromJson(Map<String, dynamic> json) {
    return GetOtherUserInfoResp(
      code: json['code'],
      data: json['data'] != null ? OtherUserInfo.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

// --- 我的页面 ---

class LikeVo {
  /// 喜欢我
  final int? likeMeCount;

  /// 喜欢我(未读)
  final int? likeMeUnreadCount;

  /// 看过我
  final int? lookMeCount;

  /// 看过我(未读)
  final int? lookMeUnreadCount;

  /// 我喜欢
  final int? meLikeCount;

  LikeVo({
    this.likeMeCount,
    this.likeMeUnreadCount,
    this.lookMeCount,
    this.lookMeUnreadCount,
    this.meLikeCount,
  });

  factory LikeVo.fromJson(Map<String, dynamic> json) {
    return LikeVo(
      likeMeCount: json['likeMeCount'],
      likeMeUnreadCount: json['likeMeUnreadCount'],
      lookMeCount: json['lookMeCount'],
      lookMeUnreadCount: json['lookMeUnreadCount'],
      meLikeCount: json['meLikeCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'likeMeCount': likeMeCount,
      'likeMeUnreadCount': likeMeUnreadCount,
      'lookMeCount': lookMeCount,
      'lookMeUnreadCount': lookMeUnreadCount,
      'meLikeCount': meLikeCount,
    };
  }
}

class PartnerTeam {
  /// 合伙人等级(CITY:城市合伙人,SENIOR:高级合伙人,PRIMARY:初级合伙人,null:表示非合伙人_不展示我的页面团队入口)
  final String? partnerLevel;

  /// 合伙人状态 0:被取消合伙人 1:正常_取partnerLevel
  final int? status;

  PartnerTeam({this.partnerLevel, this.status});

  factory PartnerTeam.fromJson(Map<String, dynamic> json) {
    return PartnerTeam(
      partnerLevel: json['partnerLevel'],
      status: json['status'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'partnerLevel': partnerLevel, 'status': status};
  }
}

class UserInfoMeData {
  /// 联系方式类型,可用值:QQ,WX
  final String? accountType;

  /// 广告Banner信息
  final AdBanner? adBanner;

  /// 用户头像
  final String? avatar;

  /// 所在城市
  final String? city;

  // 	微信公众号二维码链接
  final String? wxMpQrCode;

  /// 金币余额
  final int? coin;

  /// 喜欢和谁看过我信息
  final LikeVo? likeVo;

  /// 合伙人信息
  final PartnerTeam? partnerTeam;

  /// 认证状态(0:未认证 1:真人认证)
  final int? realType;

  /// 性别 0:女 1:男
  final int? sex;

  /// 展示绑定邀请入口 0不展示 1展示
  final int? showBindInvite;

  /// 个人介绍(签名)
  final String? signature;

  /// 用户昵称
  final String? userName;

  /// 用户显示ID
  final String? userNumber;

  /// VIP 0否 1是
  final int? vip;

  /// 联系方式(QQ,WX)
  final String? wxAccount;

  UserInfoMeData({
    this.accountType,
    this.adBanner,
    this.avatar,
    this.wxMpQrCode,
    this.city,
    this.coin,
    this.likeVo,
    this.partnerTeam,
    this.realType,
    this.sex,
    this.showBindInvite,
    this.signature,
    this.userName,
    this.userNumber,
    this.vip,
    this.wxAccount,
  });

  factory UserInfoMeData.fromJson(Map<String, dynamic> json) {
    return UserInfoMeData(
      accountType: json['accountType'],
      adBanner: json['adBanner'] != null
          ? AdBanner.fromJson(json['adBanner'])
          : null,
      avatar: json['avatar'],
      wxMpQrCode: json['wxMpQrCode'],
      city: json['city'],
      coin: json['coin'],
      likeVo: json['likeVo'] != null ? LikeVo.fromJson(json['likeVo']) : null,
      partnerTeam: json['partnerTeam'] != null
          ? PartnerTeam.fromJson(json['partnerTeam'])
          : null,
      realType: json['realType'],
      sex: json['sex'],
      showBindInvite: json['showBindInvite'],
      signature: json['signature'],
      userName: json['userName'],
      userNumber: json['userNumber'],
      vip: json['vip'],
      wxAccount: json['wxAccount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accountType': accountType,
      'adBanner': adBanner?.toJson(),
      'avatar': avatar,
      'city': city,
      'coin': coin,
      'likeVo': likeVo?.toJson(),
      'partnerTeam': partnerTeam?.toJson(),
      'realType': realType,
      'sex': sex,
      'showBindInvite': showBindInvite,
      'signature': signature,
      'userName': userName,
      'userNumber': userNumber,
      'vip': vip,
      'wxAccount': wxAccount,
    };
  }
}

class UserInfoMeResp {
  /// 状态码
  final int code;

  /// 数据
  final UserInfoMeData? data;

  /// 错误信息
  final String? message;

  UserInfoMeResp({required this.code, this.data, this.message});

  factory UserInfoMeResp.fromJson(Map<String, dynamic> json) {
    return UserInfoMeResp(
      code: json['code'],
      data: json['data'] != null ? UserInfoMeData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

// --- 黑名单 ---

class BlacklistRequest {
  final int pageNum;
  final int pageSize;

  BlacklistRequest({required this.pageNum, required this.pageSize});

  Map<String, dynamic> toJson() {
    return {'pageNum': pageNum, 'pageSize': pageSize};
  }
}

class BlacklistUserInfo {
  final String? avatar;
  final String? createTime;
  final int? sex;
  final int? uid;
  final String? userName;

  BlacklistUserInfo({
    this.avatar,
    this.createTime,
    this.sex,
    this.uid,
    this.userName,
  });

  factory BlacklistUserInfo.fromJson(Map<String, dynamic> json) {
    return BlacklistUserInfo(
      avatar: json['avatar'],
      createTime: json['createTime'],
      sex: json['sex'],
      uid: json['uid'],
      userName: json['userName'],
    );
  }
}

class BlacklistPageData {
  final bool? hasNext;
  final List<BlacklistUserInfo>? list;

  BlacklistPageData({this.hasNext, this.list});

  factory BlacklistPageData.fromJson(Map<String, dynamic> json) {
    return BlacklistPageData(
      hasNext: json['hasNext'],
      list: json['list'] != null
          ? (json['list'] as List)
                .map((item) => BlacklistUserInfo.fromJson(item))
                .toList()
          : null,
    );
  }
}

class BlacklistResp {
  final int code;
  final BlacklistPageData? data;
  final String? message;

  BlacklistResp({required this.code, this.data, this.message});

  factory BlacklistResp.fromJson(Map<String, dynamic> json) {
    return BlacklistResp(
      code: json['code'],
      data: json['data'] != null
          ? BlacklistPageData.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }
}

class BlacklistModifyRequest {
  final int toUid;

  BlacklistModifyRequest({required this.toUid});

  Map<String, dynamic> toJson() {
    return {'toUid': toUid};
  }
}

class BlacklistActionResp {
  final int code;
  final Map<String, dynamic>? data;
  final String? message;

  BlacklistActionResp({required this.code, this.data, this.message});

  factory BlacklistActionResp.fromJson(Map<String, dynamic> json) {
    return BlacklistActionResp(
      code: json['code'],
      data: json['data'] != null
          ? Map<String, dynamic>.from(json['data'])
          : null,
      message: json['message'],
    );
  }
}

// --- 账号安全 ---

class SecurityInfoData {
  final String? mobile;

  SecurityInfoData({this.mobile});

  factory SecurityInfoData.fromJson(Map<String, dynamic> json) {
    return SecurityInfoData(mobile: json['mobile']);
  }
}

class SecurityInfoResp {
  final int code;
  final SecurityInfoData? data;
  final String? message;

  SecurityInfoResp({required this.code, this.data, this.message});

  factory SecurityInfoResp.fromJson(Map<String, dynamic> json) {
    return SecurityInfoResp(
      code: json['code'],
      data: json['data'] != null
          ? SecurityInfoData.fromJson(json['data'])
          : null,
      message: json['message'],
    );
  }
}

class ResetPasswordRequest {
  final String password;
  final String? code;

  ResetPasswordRequest({required this.password, this.code});

  Map<String, dynamic> toJson() {
    return {'password': password, if (code != null) 'code': code};
  }
}

class SecurityActionResp {
  final int code;
  final Map<String, dynamic>? data;
  final String? message;

  SecurityActionResp({required this.code, this.data, this.message});

  factory SecurityActionResp.fromJson(Map<String, dynamic> json) {
    return SecurityActionResp(
      code: json['code'],
      data: json['data'] != null
          ? Map<String, dynamic>.from(json['data'])
          : null,
      message: json['message'],
    );
  }
}

class CancelInfoData {
  final int? cancelStatus;

  CancelInfoData({this.cancelStatus});

  factory CancelInfoData.fromJson(Map<String, dynamic> json) {
    return CancelInfoData(cancelStatus: json['cancelStatus']);
  }
}

class CancelInfoResp {
  final int code;
  final CancelInfoData? data;
  final String? message;

  CancelInfoResp({required this.code, this.data, this.message});

  factory CancelInfoResp.fromJson(Map<String, dynamic> json) {
    return CancelInfoResp(
      code: json['code'],
      data: json['data'] != null ? CancelInfoData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class GetAccountData {
  final String? accountType;
  final String? wxAccount;

  GetAccountData({this.accountType, this.wxAccount});

  factory GetAccountData.fromJson(Map<String, dynamic> json) {
    return GetAccountData(
      accountType: json['accountType'],
      wxAccount: json['wxAccount'],
    );
  }
}

class GetAccountResp {
  final int code;
  final GetAccountData? data;
  final String? message;

  GetAccountResp({required this.code, this.data, this.message});

  factory GetAccountResp.fromJson(Map<String, dynamic> json) {
    return GetAccountResp(
      code: json['code'],
      data: json['data'] != null ? GetAccountData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

class AddLabelsReq {
  final String labels;
  final int toUid;

  AddLabelsReq({required this.labels, required this.toUid});

  Map<String, dynamic> toJson() {
    return {'labels': labels, 'toUid': toUid};
  }
}

// --- Bind Invite Models ---

/// 绑定邀请码请求
class BindInviteReq {
  final String inviteCode;

  BindInviteReq({required this.inviteCode});

  Map<String, dynamic> toJson() {
    return {'inviteCode': inviteCode};
  }
}

/// 绑定邀请码响应
class BindInviteResp {
  final int code;
  final Map<String, dynamic>? data;
  final String? message;

  BindInviteResp({required this.code, this.data, this.message});

  factory BindInviteResp.fromJson(Map<String, dynamic> json) {
    return BindInviteResp(
      code: json['code'],
      data: json['data'],
      message: json['message'],
    );
  }
}
