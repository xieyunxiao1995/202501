class AppInitConfig {
  /// 数美 Android端 公钥KEY
  final String? androidPublicKey;

  /// 数美 H5端 AppId
  final String? appId;

  /// Cos Bucket
  final String? cosBucket;

  /// Cos Region
  final String? cosRegion;

  /// COS SecretId
  final String? cosSecretId;

  /// Cos SecretKey
  final String? cosSecretKey;

  /// Cos 上传Url
  final String? cosUrl;

  /// 进入APP默认页面(当showPartyPage=0时返回0) 1:组局，0:推荐
  final int? defaultIndexPage;

  /// 开发环境 访问域名(无论所处哪个环境，initConfig接口都请求生产地址)
  final String? domainUrl;

  /// 下载数量(单位：万)
  final num? downloadNum;

  /// 开发环境 0 本地默认 1 开发，2 测试，3 生产
  final int? envType;

  /// IM APPID
  final int? imAppId;

  /// 我的邀请展示开关 1:展示 0:不展示
  final int? inviteSwitch;

  /// 数美 IOS端 APP KEY
  final String? iosAppId;

  /// 数美 IOS端 organizationKey
  final String? iosOrganizationKey;

  /// 数美 IOS端 APP KEY
  final String? iosPublicKey;

  /// 地图开关 1:开启 0:关闭
  final int? mapSwitch;

  /// 数美 organizationKey
  final String? organizationKey;

  /// 审核环境状态 0:正常，1:匹配审核
  final int? reviewEnvStatus;

  /// 是否展示组局页面 0:不展示，1:展示
  final int? showPartyPage;

  /// 是否展示动态页面 0:不展示，1:展示
  final int? showPostPage;

  /// 是否展示推荐页面 0:不展示，1:展示
  final int? showRecommendPage;

  /// 数美 H5端 APP KEY
  final String? webPublicKey;

  /// 微信 AppId
  final String? wxAppid;

  /// 微信 Secret
  final String? wxSecret;

  AppInitConfig({
    this.androidPublicKey,
    this.appId,
    this.cosBucket,
    this.cosRegion,
    this.cosSecretId,
    this.cosSecretKey,
    this.cosUrl,
    this.defaultIndexPage,
    this.domainUrl,
    this.downloadNum,
    this.envType,
    this.imAppId,
    this.inviteSwitch,
    this.iosAppId,
    this.iosOrganizationKey,
    this.iosPublicKey,
    this.mapSwitch,
    this.organizationKey,
    this.reviewEnvStatus,
    this.showPartyPage,
    this.showPostPage,
    this.showRecommendPage,
    this.webPublicKey,
    this.wxAppid,
    this.wxSecret,
  });

  factory AppInitConfig.fromJson(Map<String, dynamic> json) {
    return AppInitConfig(
      androidPublicKey: json['androidPublicKey'],
      appId: json['appId'],
      cosBucket: json['cosBucket'],
      cosRegion: json['cosRegion'],
      cosSecretId: json['cosSecretId'],
      cosSecretKey: json['cosSecretKey'],
      cosUrl: json['cosUrl'],
      defaultIndexPage: json['defaultIndexPage'],
      domainUrl: json['domainUrl'],
      downloadNum: json['downloadNum'],
      envType: json['envType'],
      imAppId: json['imAppId'],
      inviteSwitch: json['inviteSwitch'],
      iosAppId: json['iosAppId'],
      iosOrganizationKey: json['iosOrganizationKey'],
      iosPublicKey: json['iosPublicKey'],
      mapSwitch: json['mapSwitch'],
      organizationKey: json['organizationKey'],
      reviewEnvStatus: json['reviewEnvStatus'],
      showPartyPage: json['showPartyPage'],
      showPostPage: json['showPostPage'],
      showRecommendPage: json['showRecommendPage'],
      webPublicKey: json['webPublicKey'],
      wxAppid: json['wxAppid'],
      wxSecret: json['wxSecret'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'androidPublicKey': androidPublicKey,
      'appId': appId,
      'cosBucket': cosBucket,
      'cosRegion': cosRegion,
      'cosSecretId': cosSecretId,
      'cosSecretKey': cosSecretKey,
      'cosUrl': cosUrl,
      'defaultIndexPage': defaultIndexPage,
      'domainUrl': domainUrl,
      'downloadNum': downloadNum,
      'envType': envType,
      'imAppId': imAppId,
      'inviteSwitch': inviteSwitch,
      'iosAppId': iosAppId,
      'iosOrganizationKey': iosOrganizationKey,
      'iosPublicKey': iosPublicKey,
      'mapSwitch': mapSwitch,
      'organizationKey': organizationKey,
      'reviewEnvStatus': reviewEnvStatus,
      'showPartyPage': showPartyPage,
      'showPostPage': showPostPage,
      'showRecommendPage': showRecommendPage,
      'webPublicKey': webPublicKey,
      'wxAppid': wxAppid,
      'wxSecret': wxSecret,
    };
  }
}

class AppInitConfigResp {
  final int code;
  final AppInitConfig? data;
  final String? message;

  AppInitConfigResp({required this.code, this.data, this.message});

  factory AppInitConfigResp.fromJson(Map<String, dynamic> json) {
    return AppInitConfigResp(
      code: json['code'],
      data: json['data'] != null ? AppInitConfig.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}

/// 客服服务配置数据
class CustomerServiceData {
  /// 企业微信客服地址
  final String? weChatWorkKfUrl;

  CustomerServiceData({this.weChatWorkKfUrl});

  factory CustomerServiceData.fromJson(Map<String, dynamic> json) {
    return CustomerServiceData(
      weChatWorkKfUrl: json['weChatWorkKfUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'weChatWorkKfUrl': weChatWorkKfUrl,
    };
  }
}

/// 客服服务配置响应
class CustomerServiceResp {
  final int code;
  final CustomerServiceData? data;
  final String? message;

  CustomerServiceResp({required this.code, this.data, this.message});

  factory CustomerServiceResp.fromJson(Map<String, dynamic> json) {
    return CustomerServiceResp(
      code: json['code'],
      data: json['data'] != null ? CustomerServiceData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}
