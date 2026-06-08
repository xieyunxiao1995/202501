import 'package:dio/dio.dart';

/// 传记相关 API
///
/// 提供武将传记查询和解锁接口。
abstract class BiographyApi {
  final Dio _dio;

  BiographyApi(this._dio);

  /// 获取武将传记
  ///
  /// 返回指定武将的传记内容。
  Future<Map<String, dynamic>> getBiography(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 解锁传记章节
  ///
  /// 解锁指定武将的传记章节。
  Future<Map<String, dynamic>> unlockChapter(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取所有已解锁传记
  ///
  /// 返回当前用户已解锁的所有传记列表。
  Future<Map<String, dynamic>> getUnlockedBiographies() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }
}
