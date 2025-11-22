class BannerReq {
  final String pageType;

  BannerReq({required this.pageType});

  Map<String, dynamic> toJson() => {'pageType': pageType};
}

class BannerItem {
  final String? bannerUrl;
  final int? id;
  final String? redirectUrl;
  final String? title;

  BannerItem({this.bannerUrl, this.id, this.redirectUrl, this.title});

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      bannerUrl: json['bannerUrl'],
      id: json['id'],
      redirectUrl: json['redirectUrl'],
      title: json['title'],
    );
  }
}

class BannerData {
  final List<BannerItem>? bannerList;

  BannerData({this.bannerList});

  factory BannerData.fromJson(Map<String, dynamic> json) {
    return BannerData(
      bannerList: json['bannerList'] != null
          ? (json['bannerList'] as List)
              .map((item) => BannerItem.fromJson(item))
              .toList()
          : null,
    );
  }
}

class BannerResp {
  final int code;
  final BannerData? data;
  final String? message;

  BannerResp({required this.code, this.data, this.message});

  factory BannerResp.fromJson(Map<String, dynamic> json) {
    return BannerResp(
      code: json['code'],
      data: json['data'] != null ? BannerData.fromJson(json['data']) : null,
      message: json['message'],
    );
  }
}
