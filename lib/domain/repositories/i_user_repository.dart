import '../../core/network/api_result.dart';
import '../entities/user.dart';

/// 用户仓库接口
///
/// 提供用户信息管理相关操作，包括获取和更新用户资料。
abstract class IUserRepository {
  /// 获取用户资料
  ///
  /// 获取当前登录用户的完整信息，包括等级、爵位、战力等。
  Future<ApiResult<User>> getProfile();

  /// 更新用户资料
  ///
  /// 更新用户的资料信息，[data] 为需要更新的字段映射。
  Future<ApiResult<User>> updateProfile(Map<String, dynamic> data);

  /// 更新用户头像
  ///
  /// 上传并更新用户头像，[avatarPath] 为本地头像文件路径。
  Future<ApiResult<User>> updateAvatar(String avatarPath);

  /// 修改用户昵称
  ///
  /// 修改当前用户的昵称为 [newNickname]。
  /// 可能受次数限制或消耗道具。
  Future<ApiResult<User>> changeNickname(String newNickname);
}
