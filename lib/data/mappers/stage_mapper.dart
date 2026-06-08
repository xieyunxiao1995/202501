import '../../domain/entities/stage.dart' as entity;
import '../models/stage/stage_model.dart';

/// 关卡数据转换器
///
/// 负责在关卡数据模型（DTO）和领域实体之间进行双向转换。
/// Model 和 Entity 字段映射较为直接，主要差异在于命名风格。
class StageMapper {
  /// 将关卡数据模型转换为领域实体
  ///
  /// [model] 关卡数据传输对象
  /// 返回对应的关卡领域实体
  entity.Stage toEntity(StageModel model) {
    return entity.Stage(
      id: model.id,
      chapterId: model.chapterId,
      name: model.name,
      difficulty: model.difficulty,
      enemyLineup: model.enemyGeneralIds,
      rewards: model.rewards,
      isCleared: model.cleared,
      starCount: model.threeStarred ? 3 : (model.cleared ? 1 : 0),
    );
  }

  /// 将关卡领域实体转换为数据模型
  ///
  /// [stage] 关卡领域实体
  /// 返回对应的数据传输对象
  StageModel toModel(entity.Stage stage) {
    return StageModel(
      id: stage.id,
      chapterId: stage.chapterId,
      name: stage.name,
      difficulty: stage.difficulty,
      enemyGeneralIds: stage.enemyLineup,
      rewards: stage.rewards,
      cleared: stage.isCleared,
      threeStarred: stage.starCount >= 3,
    );
  }

  /// 批量将关卡数据模型转换为领域实体
  ///
  /// [models] 关卡数据传输对象列表
  /// 返回对应的关卡领域实体列表
  List<entity.Stage> toEntityList(List<StageModel> models) {
    return models.map(toEntity).toList();
  }

  /// 批量将关卡领域实体转换为数据模型
  ///
  /// [stages] 关卡领域实体列表
  /// 返回对应的数据传输对象列表
  List<StageModel> toModelList(List<entity.Stage> stages) {
    return stages.map(toModel).toList();
  }
}
