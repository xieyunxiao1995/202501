import '../../core/network/api_result.dart';
import '../entities/biography.dart';

/// 传记仓库接口
///
/// 提供武将传记相关操作，包括查询传记和解锁章节。
abstract class IBiographyRepository {
  /// 获取武将传记
  ///
  /// 获取指定 [generalId] 武将的传记信息，
  /// 包括正史、演义文本和解锁状态。
  Future<ApiResult<Biography>> getBiography(String generalId);

  /// 解锁传记章节
  ///
  /// 解锁指定 [generalId] 武将传记的 [chapterId] 章节，
  /// 需满足前置条件（如碎片收集、任务完成等）。
  Future<ApiResult<Biography>> unlockChapter(
    String generalId,
    String chapterId,
  );
}
