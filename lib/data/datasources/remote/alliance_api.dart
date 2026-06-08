import 'package:dio/dio.dart';

/// 联盟相关 API
///
/// 提供联盟创建、查询、成员管理等接口。
abstract class AllianceApi {
  final Dio _dio;

  AllianceApi(this._dio);

  /// 获取联盟详情
  ///
  /// 返回指定联盟的详细信息。
  Future<Map<String, dynamic>> getAlliance(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 搜索联盟
  ///
  /// 根据名称搜索联盟列表。
  Future<Map<String, dynamic>> searchAlliances(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 创建联盟
  ///
  /// 创建新的联盟。
  Future<Map<String, dynamic>> createAlliance(Map<String, dynamic> body) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 加入联盟
  ///
  /// 申请加入指定联盟。
  Future<Map<String, dynamic>> joinAlliance(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 退出联盟
  ///
  /// 退出当前所在的联盟。
  Future<Map<String, dynamic>> leaveAlliance(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取联盟成员列表
  ///
  /// 返回指定联盟的所有成员信息。
  Future<Map<String, dynamic>> getMembers(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 踢出成员
  ///
  /// 将指定成员从联盟中移除（需要权限）。
  Future<Map<String, dynamic>> kickMember(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 修改联盟公告
  ///
  /// 更新联盟公告内容。
  Future<Map<String, dynamic>> updateAnnouncement(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }
}
