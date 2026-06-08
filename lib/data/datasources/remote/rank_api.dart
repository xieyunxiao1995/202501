import 'package:dio/dio.dart';

/// 排行榜相关 API
///
/// 提供各类排行榜查询接口。
abstract class RankApi {
  final Dio _dio;

  RankApi(this._dio);

  /// 获取战力排行榜
  ///
  /// 返回全服战力排行列表。
  Future<Map<String, dynamic>> getPowerRank(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取等级排行榜
  ///
  /// 返回全服等级排行列表。
  Future<Map<String, dynamic>> getLevelRank(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取国战积分排行榜
  ///
  /// 返回当前赛季国战个人积分排行。
  Future<Map<String, dynamic>> getKingdomWarRank(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取竞技场排行榜
  ///
  /// 返回竞技场段位排行列表。
  Future<Map<String, dynamic>> getPvpRank(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }
}
