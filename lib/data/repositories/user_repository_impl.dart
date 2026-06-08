import 'package:injectable/injectable.dart';
import '../../core/network/api_result.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/i_user_repository.dart';
import '../datasources/local/user_local_data_source.dart';
import '../datasources/remote/user_api.dart';
import '../mappers/user_mapper.dart';

/// 用户仓库实现
///
/// 实现用户信息管理相关业务逻辑，协调远程 API 和本地数据源，
/// 处理用户资料查询、更新头像和修改昵称等操作。
@LazySingleton(as: IUserRepository)
class UserRepositoryImpl implements IUserRepository {
  final UserApi _userApi;
  final UserLocalDataSource _userLocalDataSource;
  final UserMapper _userMapper;

  UserRepositoryImpl(this._userApi, this._userLocalDataSource, this._userMapper);

  @override
  Future<ApiResult<User>> getProfile() async {
    // TODO: 调用 _userApi.getCurrentUser，通过 _userMapper 转换为 User 实体，缓存到本地
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<User>> updateProfile(Map<String, dynamic> data) async {
    // TODO: 调用 _userApi.updateUser，通过 _userMapper 转换为 User 实体，更新本地缓存
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<User>> updateAvatar(String avatarPath) async {
    // TODO: 调用 _userApi.updateAvatar，更新用户头像
    throw UnimplementedError();
  }

  @override
  Future<ApiResult<User>> changeNickname(String newNickname) async {
    // TODO: 调用 _userApi.updateUser 修改昵称，更新本地缓存
    throw UnimplementedError();
  }
}
