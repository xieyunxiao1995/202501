import '../../core/network/api_result.dart';

/// 配置仓库接口
///
/// 提供游戏配置加载相关操作，用于获取服务端下发的游戏配置数据。
abstract class IConfigRepository {
  /// 加载所有配置
  ///
  /// 从服务端加载全部游戏配置数据，包括武将、技能、道具等配置表。
  Future<ApiResult<Map<String, dynamic>>> loadConfigs();

  /// 获取指定配置
  ///
  /// 根据配置键 [key] 获取对应类型的配置数据。
  /// 泛型 [T] 指定返回数据的类型。
  Future<ApiResult<T>> getConfig<T>(String key);
}
