import '../DaZimodels/repair_log.dart';
import 'storage_service.dart';

/// 修复日志服务
class RepairLogService {
  final StorageService _storageService;

  RepairLogService({required StorageService storageService})
    : _storageService = storageService;

  /// 获取项目的所有日志
  Future<List<RepairLogEntry>> getLogsForProject(String projectId) async {
    final logs = await _storageService.getRepairLogs(projectId);
    // 按日期倒序排列
    logs.sort((a, b) => b.date.compareTo(a.date));
    return logs;
  }

  /// 添加日志条目
  Future<void> addLog(RepairLogEntry log) async {
    await _storageService.saveRepairLog(log);
  }

  /// 更新日志
  Future<void> updateLog(RepairLogEntry log) async {
    await _storageService.saveRepairLog(log);
  }

  /// 删除日志
  Future<void> deleteLog(String logId) async {
    await _storageService.deleteRepairLog(logId);
  }

  /// 获取时间线数据（按日期分组）
  Future<Map<String, List<RepairLogEntry>>> getTimeline(
    String projectId,
  ) async {
    final logs = await getLogsForProject(projectId);
    final timeline = <String, List<RepairLogEntry>>{};

    for (final log in logs) {
      final dateKey =
          '${log.date.year}-${log.date.month.toString().padLeft(2, '0')}-${log.date.day.toString().padLeft(2, '0')}';
      if (!timeline.containsKey(dateKey)) {
        timeline[dateKey] = [];
      }
      timeline[dateKey]!.add(log);
    }

    return timeline;
  }

  /// 获取项目的日志数量
  Future<int> getLogCount(String projectId) async {
    final logs = await getLogsForProject(projectId);
    return logs.length;
  }

  /// 获取项目的最新日志
  Future<RepairLogEntry?> getLatestLog(String projectId) async {
    final logs = await getLogsForProject(projectId);
    return logs.isNotEmpty ? logs.first : null;
  }
}
