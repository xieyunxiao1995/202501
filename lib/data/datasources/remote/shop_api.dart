import 'package:dio/dio.dart';

/// 商店相关 API
///
/// 提供商店查询、购买和订单管理接口。
abstract class ShopApi {
  final Dio _dio;

  ShopApi(this._dio);

  /// 获取商店列表
  ///
  /// 返回所有可用的商店。
  Future<Map<String, dynamic>> getShops() async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取商店详情
  ///
  /// 返回指定商店的详细信息及商品列表。
  Future<Map<String, dynamic>> getShopDetail(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 获取商品列表
  ///
  /// 返回指定商店的商品列表。
  Future<Map<String, dynamic>> getShopItems(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 购买商品
  ///
  /// 在指定商店购买商品。
  Future<Map<String, dynamic>> buyItem(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 刷新商店
  ///
  /// 手动刷新商店商品列表。
  Future<Map<String, dynamic>> refreshShop(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 创建订单
  ///
  /// 创建充值订单。
  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> body) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }

  /// 查询订单状态
  ///
  /// 查询指定订单的支付状态。
  Future<Map<String, dynamic>> getOrderStatus(Map<String, dynamic> params) async {
    // TODO: 实现 API 调用
    throw UnimplementedError();
  }
}
