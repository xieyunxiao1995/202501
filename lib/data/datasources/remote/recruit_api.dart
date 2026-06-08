import 'package:dio/dio.dart';

/// 招募相关 API
///
/// 提供招募卡池查询、抽卡、保底和历史记录接口。
abstract class RecruitApi {
  final Dio _dio;

  RecruitApi(this._dio);

  /// 获取卡池列表
  ///
  /// 返回当前所有可用的招募卡池。
  Future<Map<String, dynamic>> getPools() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取卡池详情
  ///
  /// 返回指定卡池的详细信息。
  Future<Map<String, dynamic>> getPoolDetail(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 单抽
  ///
  /// 在指定卡池中进行一次招募。
  Future<Map<String, dynamic>> pull(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 十连抽
  ///
  /// 在指定卡池中进行十连招募。
  Future<Map<String, dynamic>> pullTen(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取保底进度
  ///
  /// 返回当前用户在指定卡池的保底计数。
  Future<Map<String, dynamic>> getPity(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取招募历史
  ///
  /// 返回指定卡池的招募历史记录。
  Future<Map<String, dynamic>> getHistory(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }
}
