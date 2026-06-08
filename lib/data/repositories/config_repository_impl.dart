import 'package:injectable/injectable.dart';
import '../../core/network/api_result.dart';
import '../../domain/repositories/i_config_repository.dart';
import '../datasources/local/config_local_data_source.dart';

/// 配置仓库实现
///
/// 实现游戏配置加载相关业务逻辑，协调本地数据源，
/// 从 assets 目录加载 JSON 配置文件并提供缓存能力。
@LazySingleton(as: IConfigRepository)
class ConfigRepositoryImpl implements IConfigRepository {
  final ConfigLocalDataSource _configLocalDataSource;

  ConfigRepositoryImpl(this._configLocalDataSource);

  @override
  Future<ApiResult<Map<String, dynamic>>> loadConfigs() async {
    // TODO: 加载所有核心配置文件，合并返回完整配置数据
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<T>> getConfig<T>(String key) async {
    // TODO: 根据键名加载指定配置文件并转换为泛型 T
    throw UnimplementedError();
  }
}
