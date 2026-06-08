import 'package:dio/dio.dart';

/// 主城相关 API
///
/// 提供主城、建筑、资源和升级相关接口。
abstract class CityApi {
  final Dio _dio;

  CityApi(this._dio);

  /// 获取主城信息
  ///
  /// 返回当前用户的主城完整数据。
  Future<Map<String, dynamic>> getCity() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取建筑列表
  ///
  /// 返回主城中所有建筑的信息。
  Future<Map<String, dynamic>> getBuildings() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取建筑详情
  ///
  /// 返回指定建筑的详细信息。
  Future<Map<String, dynamic>> getBuilding(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 升级建筑
  ///
  /// 开始升级指定建筑。
  Future<Map<String, dynamic>> upgradeBuilding(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 加速升级
  ///
  /// 消耗元宝加速建筑升级进程。
  Future<Map<String, dynamic>> speedUpUpgrade(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 领取建筑产出
  ///
  /// 收取指定建筑的资源产出。
  Future<Map<String, dynamic>> collectResources(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取升级需求
  ///
  /// 返回指定建筑升级到目标等级所需的资源。
  Future<Map<String, dynamic>> getUpgradeRequirements(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }
}
