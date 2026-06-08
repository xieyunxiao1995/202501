import 'package:dio/dio.dart';

/// 竞技场（PVP）相关 API
///
/// 提供竞技场匹配、战斗和排名接口。
abstract class PvpApi {
  final Dio _dio;

  PvpApi(this._dio);

  /// 获取竞技场信息
  ///
  /// 返回当前用户的竞技场段位和排名信息。
  Future<Map<String, dynamic>> getPvpInfo() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取对手列表
  ///
  /// 返回可挑战的对手列表。
  Future<Map<String, dynamic>> getOpponents() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 发起挑战
  ///
  /// 向指定对手发起竞技场挑战。
  Future<Map<String, dynamic>> challenge(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取战斗记录
  ///
  /// 返回最近的竞技场战斗记录。
  Future<Map<String, dynamic>> getBattleHistory(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取防守阵容
  ///
  /// 返回当前设置的竞技场防守阵容。
  Future<Map<String, dynamic>> getDefenseLineup() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 设置防守阵容
  ///
  /// 更新竞技场防守阵容配置。
  Future<Map<String, dynamic>> setDefenseLineup(Map<String, dynamic> body) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }
}
