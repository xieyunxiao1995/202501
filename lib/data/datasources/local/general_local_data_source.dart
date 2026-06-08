import '../../models/general/general_model.dart';

/// 武将本地数据源
///
/// 提供武将数据的本地持久化存储能力，包括武将列表缓存和单个武将数据读写。
class GeneralLocalDataSource {
  /// 保存武将列表到本地
  ///
  /// [generals] 要保存的武将数据列表
  Future<void> saveGenerals(List<GeneralModel> generals) async {
    // TODO: 实现 Hive Box 批量写入武将列表
    throw UnimplementedError();
  }

  /// 从本地读取武将列表
  ///
  /// 返回缓存的武将数据列表，若不存在返回空列表
  Future<List<GeneralModel>> getGenerals() async {
    // TODO: 实现 Hive Box 批量读取武将列表
    throw UnimplementedError();
  }

  /// 保存单个武将数据
  ///
  /// [general] 要保存的武将数据模型
  Future<void> saveGeneral(GeneralModel general) async {
    // TODO: 实现 Hive Box 单条写入武将数据
    throw UnimplementedError();
  }

  /// 读取单个武将数据
  ///
  /// [id] 武将唯一标识
  /// 返回对应的武将数据模型，若不存在返回 null
  Future<GeneralModel?> getGeneral(String id) async {
    // TODO: 实现 Hive Box 按 ID 读取武将数据
    throw UnimplementedError();
  }

  /// 删除武将缓存数据
  ///
  /// [id] 要删除的武将唯一标识
  Future<void> deleteGeneral(String id) async {
    // TODO: 实现 Hive Box 按 ID 删除武将数据
    throw UnimplementedError();
  }

  /// 清除所有武将缓存
  Future<void> clearAll() async {
    // TODO: 清除 Hive Box 中的所有武将数据
    throw UnimplementedError();
  }
}
