import '../../domain/entities/user.dart' as entity;
import '../../shared/enums/title.dart';
import '../models/user/user_model.dart';

/// 用户数据转换器
///
/// 负责在用户数据模型（DTO）和领域实体之间进行双向转换。
/// Model 面向 API 契约使用字符串标识枚举，Entity 使用强类型枚举。
class UserMapper {
  /// 将用户数据模型转换为领域实体
  ///
  /// [model] 用户数据传输对象
  /// 返回对应的用户领域实体
  entity.User toEntity(UserModel model) {
    return entity.User(
      id: model.id,
      name: model.name,
      level: model.level,
      vipLevel: model.vipLevel,
      title: Title.fromJson(model.title),
      avatar: model.avatar,
      exp: model.exp,
      power: model.power,
    );
  }

  /// 将用户领域实体转换为数据模型
  ///
  /// [user] 用户领域实体
  /// 返回对应的数据传输对象
  UserModel toModel(entity.User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      level: user.level,
      vipLevel: user.vipLevel,
      title: user.title.toJson(),
      avatar: user.avatar,
      exp: user.exp,
      power: user.power,
    );
  }
}
