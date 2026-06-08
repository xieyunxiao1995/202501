import 'package:dio/dio.dart';

/// 关卡相关 API
///
/// 提供章节、关卡、副本、经典战役和试炼之塔接口。
abstract class StageApi {
  final Dio _dio;

  StageApi(this._dio);

  /// 获取章节列表
  ///
  /// 返回所有章节及其解锁状态。
  Future<Map<String, dynamic>> getChapters() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取章节详情
  ///
  /// 返回指定章节的详细信息及包含的关卡列表。
  Future<Map<String, dynamic>> getChapterDetail(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取关卡详情
  ///
  /// 返回指定关卡的详细信息。
  Future<Map<String, dynamic>> getStage(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 进入关卡
  ///
  /// 开始挑战指定关卡。
  Future<Map<String, dynamic>> enterStage(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取副本列表
  ///
  /// 返回所有可用的副本。
  Future<Map<String, dynamic>> getDungeons() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 进入副本
  ///
  /// 开始挑战指定副本的当前层。
  Future<Map<String, dynamic>> enterDungeon(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取经典战役列表
  ///
  /// 返回所有经典战役关卡。
  Future<Map<String, dynamic>> getClassicBattles() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取试炼之塔数据
  ///
  /// 返回试炼之塔各层数据。
  Future<Map<String, dynamic>> getTowerFloors() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }
}
