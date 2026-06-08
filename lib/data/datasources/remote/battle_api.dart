import 'package:dio/dio.dart';

/// 战斗相关 API
///
/// 提供战斗创建、执行、结算及阵容管理接口。
abstract class BattleApi {
  final Dio _dio;

  BattleApi(this._dio);

  /// 创建战斗
  ///
  /// 根据阵容和敌方阵容创建一场新的战斗。
  Future<Map<String, dynamic>> createBattle(Map<String, dynamic> body) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取战斗详情
  ///
  /// 返回指定战斗的当前状态。
  Future<Map<String, dynamic>> getBattle(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 执行战斗行动
  ///
  /// 提交当前回合的战斗行动。
  Future<Map<String, dynamic>> executeAction(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取战斗状态
  ///
  /// 返回当前回合的战斗状态快照。
  Future<Map<String, dynamic>> getBattleState(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 结算战斗
  ///
  /// 结束战斗并返回结算结果。
  Future<Map<String, dynamic>> settleBattle(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取阵容列表
  ///
  /// 返回当前用户的所有阵容配置。
  Future<Map<String, dynamic>> getLineups() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 保存阵容
  ///
  /// 创建或更新阵容配置。
  Future<Map<String, dynamic>> saveLineup(Map<String, dynamic> body) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取阵法列表
  ///
  /// 返回所有可用的阵法配置。
  Future<Map<String, dynamic>> getFormations() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取羁绊列表
  ///
  /// 返回指定武将组合可激活的羁绊效果。
  Future<Map<String, dynamic>> getBonds(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }
}
