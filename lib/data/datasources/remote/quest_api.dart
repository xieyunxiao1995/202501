import 'package:dio/dio.dart';

/// 任务相关 API
///
/// 提供任务、日常、成就和通行证相关接口。
abstract class QuestApi {
  final Dio _dio;

  QuestApi(this._dio);

  /// 获取任务列表
  ///
  /// 返回当前用户的任务列表。
  Future<Map<String, dynamic>> getQuests() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 领取任务奖励
  ///
  /// 领取已完成任务的奖励。
  Future<Map<String, dynamic>> claimQuestReward(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取日常任务列表
  ///
  /// 返回今日日常任务及活跃度进度。
  Future<Map<String, dynamic>> getDailyQuests() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 领取日常任务奖励
  ///
  /// 领取已完成日常任务的奖励。
  Future<Map<String, dynamic>> claimDailyReward(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 领取活跃度宝箱
  ///
  /// 根据活跃度进度领取对应宝箱奖励。
  Future<Map<String, dynamic>> claimActivityBox(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取成就列表
  ///
  /// 返回所有成就及完成进度。
  Future<Map<String, dynamic>> getAchievements() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 领取成就奖励
  ///
  /// 领取已完成成就的奖励。
  Future<Map<String, dynamic>> claimAchievementReward(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取通行证信息
  ///
  /// 返回当前赛季通行证的详细信息。
  Future<Map<String, dynamic>> getBattlePass() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 领取通行证奖励
  ///
  /// 领取指定等级的通行证奖励。
  Future<Map<String, dynamic>> claimBattlePassReward(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }
}
