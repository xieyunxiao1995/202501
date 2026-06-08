import 'package:dio/dio.dart';

/// 活动相关 API
///
/// 提供活动列表查询、参与和奖励领取接口。
abstract class ActivityApi {
  final Dio _dio;

  ActivityApi(this._dio);

  /// 获取活动列表
  ///
  /// 返回当前所有进行中的活动。
  Future<Map<String, dynamic>> getActivities() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取活动详情
  ///
  /// 返回指定活动的详细信息。
  Future<Map<String, dynamic>> getActivityDetail(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 参与活动
  ///
  /// 报名或参与指定活动。
  Future<Map<String, dynamic>> participate(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 领取活动奖励
  ///
  /// 领取指定活动的阶段奖励。
  Future<Map<String, dynamic>> claimReward(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取签到信息
  ///
  /// 返回当前签到活动的状态和累计天数。
  Future<Map<String, dynamic>> getSignInInfo() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 签到
  ///
  /// 执行每日签到。
  Future<Map<String, dynamic>> signIn() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }
}
