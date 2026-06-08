import 'package:dio/dio.dart';

/// 武将相关 API
///
/// 提供武将查询、技能、计谋等接口。
abstract class GeneralApi {
  final Dio _dio;

  GeneralApi(this._dio);

  /// 获取武将列表
  ///
  /// 返回当前用户拥有的所有武将。
  Future<Map<String, dynamic>> getGenerals() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取武将详情
  ///
  /// 返回指定武将的完整详情信息，包含装备、兵器、战马等。
  Future<Map<String, dynamic>> getGeneralDetail(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 升级武将
  ///
  /// 消耗经验书提升武将等级。
  Future<Map<String, dynamic>> levelUp(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 觉醒武将
  ///
  /// 消耗觉醒石觉醒指定武将。
  Future<Map<String, dynamic>> awaken(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 升星
  ///
  /// 消耗碎片提升武将星级。
  Future<Map<String, dynamic>> starUp(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取技能详情
  ///
  /// 返回指定技能的详细信息。
  Future<Map<String, dynamic>> getSkill(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取计谋详情
  ///
  /// 返回指定计谋的详细信息。
  Future<Map<String, dynamic>> getTactic(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 装配计谋
  ///
  /// 为指定武将装配计谋。
  Future<Map<String, dynamic>> equipTactic(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }
}
