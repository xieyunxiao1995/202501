import 'package:zhenyu_flutter/utils/http.dart';
import 'package:zhenyu_flutter/models/index_api_model.dart';

class IndexApi {
  /// 所有开放城市
  static Future<GetCityListResp> getCityList() async {
    final response = await Http.request("/index/cityList", method: "post");
    return GetCityListResp.fromJson(response.data);
  }

  /// tab列表
  static Future<GetTabAllResp> getTabAll() async {
    final response = await Http.request("/index/tabAll", method: "post");
    return GetTabAllResp.fromJson(response.data);
  }

  /// 根据经纬度定位城市
  static Future<LocationCityResp> getLocationCity(
    double longitude,
    double latitude,
  ) async {
    final response = await Http.request(
      "/index/locationCity",
      method: "post",
      data: {'longitude': longitude, 'latitude': latitude},
    );
    return LocationCityResp.fromJson(response.data);
  }

  /// 首页用户列表
  static Future<IndexUserListResp> indexUserList(IndexUserListReq req) async {
    final response = await Http.request(
      "/index/indexUserList",
      method: "post",
      data: req.toJson(),
    );
    return IndexUserListResp.fromJson(response.data);
  }

  /// 搜索用户
  static Future<SearchUserResp> searchUser(SearchUserReq req) async {
    final response = await Http.request(
      "/index/searchUser",
      method: "post",
      data: req.toJson(),
    );
    return SearchUserResp.fromJson(response.data);
  }

  /// 高德搜索周边
  static Future nearbySearch(Map<String, dynamic> data) {
    return Http.request("/index/nearbysearch", method: "post", data: data);
  }

  /// 高德poi搜索
  static Future placeSearch(Map<String, dynamic> data) {
    return Http.request("/index/placesearch", method: "post", data: data);
  }
}
