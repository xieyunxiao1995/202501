import 'package:zhenyu_flutter/models/chat_api_model.dart';
import 'package:zhenyu_flutter/utils/http.dart';

class ChatApi {
  static Future<UnlockChatListResp> getUnlockChatList(
    UnlockChatListReq req,
  ) async {
    final response = await Http.request(
      '/unlockChat/list',
      method: 'post',
      data: req.toJson(),
    );
    return UnlockChatListResp.fromJson(response.data);
  }

  static Future<CheckUnlockResp> checkUnlock(CheckUnlockReq req) async {
    final response = await Http.request(
      '/unlockChat/checkUnlock',
      method: 'post',
      data: req.toJson(),
    );
    return CheckUnlockResp.fromJson(response.data as Map<String, dynamic>);
  }

  static Future<RechargeUnlockResp> rechargeUnlock(
    RechargeUnlockReq req,
  ) async {
    final response = await Http.request(
      '/unlockChat/rechargeUnlock',
      method: 'post',
      data: req.toJson(),
    );
    return RechargeUnlockResp.fromJson(response.data as Map<String, dynamic>);
  }

  static Future<NearbySearchResp> getNearbySearch(NearbySearchReq req) async {
    final response = await Http.request(
      '/location/nearby',
      method: 'post',
      data: req.toJson(),
    );
    return NearbySearchResp.fromJson(response.data as Map<String, dynamic>);
  }

  static Future<NearbySearchResp> searchPlaces(PlaceSearchReq req) async {
    final response = await Http.request(
      '/location/search',
      method: 'post',
      data: req.toJson(),
    );
    return NearbySearchResp.fromJson(response.data as Map<String, dynamic>);
  }

  // 获取微信号
  static Future<GetWxAccountResp> getWxAccount(GetWxAccountReq req) async {
    final response = await Http.request(
      '/unlockChat/getWxAccount',
      method: 'post',
      data: req.toJson(),
    );
    return GetWxAccountResp.fromJson(response.data as Map<String, dynamic>);
  }
}
