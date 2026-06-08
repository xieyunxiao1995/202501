import 'package:dio/dio.dart';

/// 国战相关 API
///
/// 提供国战赛季、地图、城池攻防和排名接口。
abstract class KingdomWarApi {
  final Dio _dio;

  KingdomWarApi(this._dio);

  /// 获取当前国战信息
  ///
  /// 返回当前赛季的国战状态。
  Future<Map<String, dynamic>> getCurrentWar() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取国战地图
  ///
  /// 返回当前赛季的国战地图数据。
  Future<Map<String, dynamic>> getWarMap() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取城池详情
  ///
  /// 返回指定城池节点的详细信息。
  Future<Map<String, dynamic>> getCityNode(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 攻打城池
  ///
  /// 向指定城池发起进攻。
  Future<Map<String, dynamic>> attackCity(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 防守城池
  ///
  /// 部署武将防守指定城池。
  Future<Map<String, dynamic>> defendCity(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取国战任务
  ///
  /// 返回当前赛季的国战任务列表。
  Future<Map<String, dynamic>> getWarTasks() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 领取国战任务奖励
  ///
  /// 领取已完成任务的奖励。
  Future<Map<String, dynamic>> claimWarTaskReward(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取国战排名
  ///
  /// 返回当前赛季的阵营排名。
  Future<Map<String, dynamic>> getRankings() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }
}
