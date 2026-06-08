import '../../domain/entities/general.dart' as entity;
import '../../shared/enums/kingdom.dart';
import '../../shared/enums/profession.dart';
import '../../shared/enums/rarity.dart';
import '../models/general/general_model.dart';

/// 武将数据转换器
///
/// 负责在武将数据模型（DTO）和领域实体之间进行双向转换。
/// Model 面向 API 契约使用字符串标识枚举，Entity 使用强类型枚举。
class GeneralMapper {
  /// 将武将数据模型转换为领域实体
  ///
  /// [model] 武将数据传输对象
  /// 返回对应的武将领域实体
  entity.General toEntity(GeneralModel model) {
    return entity.General(
      id: model.id,
      name: model.name,
      kingdom: Kingdom.fromJson(model.kingdom),
      profession: Profession.fromJson(model.profession),
      rarity: Rarity.fromJson(model.rarity),
      star: model.star,
      level: model.level,
      atk: model.atk,
      def: model.def,
      hp: model.hp,
      spd: model.spd,
      skillIds: model.skillIds,
      tacticId: model.tacticId,
      isAwakened: model.isAwakened,
      power: model.power,
    );
  }

  /// 将武将领域实体转换为数据模型
  ///
  /// [general] 武将领域实体
  /// 返回对应的数据传输对象
  GeneralModel toModel(entity.General general) {
    return GeneralModel(
      id: general.id,
      name: general.name,
      kingdom: general.kingdom.toJson(),
      profession: general.profession.toJson(),
      rarity: general.rarity.toJson(),
      star: general.star,
      level: general.level,
      atk: general.atk,
      def: general.def,
      hp: general.hp,
      spd: general.spd,
      skillIds: general.skillIds,
      tacticId: general.tacticId,
      isAwakened: general.isAwakened,
      power: general.power,
    );
  }

  /// 批量将武将数据模型转换为领域实体
  ///
  /// [models] 武将数据传输对象列表
  /// 返回对应的武将领域实体列表
  List<entity.General> toEntityList(List<GeneralModel> models) {
    return models.map(toEntity).toList();
  }

  /// 批量将武将领域实体转换为数据模型
  ///
  /// [generals] 武将领域实体列表
  /// 返回对应的数据传输对象列表
  List<GeneralModel> toModelList(List<entity.General> generals) {
    return generals.map(toModel).toList();
  }
}
