import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_decorations.dart';
import '../../models/repair_log.dart';
import '../../services/storage_service.dart';
import '../../services/repair_log_service.dart';
import '../../config/routes.dart';
import '../../utils/formatters.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 修复日志页面 - 深色霓虹风格
class RepairLogScreen extends StatefulWidget {
  final String projectId;

  const RepairLogScreen({super.key, required this.projectId});

  @override
  State<RepairLogScreen> createState() => _RepairLogScreenState();
}

class _RepairLogScreenState extends State<RepairLogScreen> {
  late RepairLogService _logService;
  List<RepairLogEntry> _logs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs);
    _logService = RepairLogService(storageService: storageService);
    await _loadLogs();
  }

  Future<void> _loadLogs() async {
    final logs = await _logService.getLogsForProject(widget.projectId);
    if (mounted) {
      setState(() {
        _logs = logs;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteLog(String logId) async {
    await _logService.deleteLog(logId);
    await _loadLogs();
  }

  void _navigateToAddLog() {
    Navigator.of(context)
        .pushNamed(AppRoutes.addRepairLog, arguments: widget.projectId)
        .then((_) => _loadLogs());
  }

  void _navigateToEditLog(RepairLogEntry log) {
    Navigator.of(context)
        .pushNamed(
          AppRoutes.addRepairLog,
          arguments: {'projectId': widget.projectId, 'log': log},
        )
        .then((_) => _loadLogs());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          '修复日志',
          style: AppTextStyles.headline3.copyWith(
            fontSize: isSmallScreen ? 16 : 18,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _logs.isEmpty
          ? _buildEmptyState(isSmallScreen)
          : _buildLogList(isSmallScreen),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddLog,
        backgroundColor: AppColors.primary,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: isSmallScreen ? 22 : 24,
        ),
      ),
    );
  }

  Widget _buildEmptyState(bool isSmallScreen) {
    final iconSize = isSmallScreen ? 88.0 : 100.0;
    final iconInnerSize = isSmallScreen ? 36.0 : 40.0;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: iconSize,
            height: iconSize,
            decoration: BoxDecoration(
              gradient: AppColors.pinkGradient,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.pinkStart.withAlpha(128),
                  blurRadius: isSmallScreen ? 16 : 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Icons.history,
              color: Colors.white,
              size: iconInnerSize,
            ),
          ),
          SizedBox(height: isSmallScreen ? 20 : 24),
          Text(
            '暂无修复记录',
            style: AppTextStyles.headline3.copyWith(
              color: AppColors.textSecondary,
              fontSize: isSmallScreen ? 16 : 18,
            ),
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            '点击右下角按钮添加第一条修复日志',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textLight,
              fontSize: isSmallScreen ? 13 : 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogList(bool isSmallScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : 20.0;

    return ListView.builder(
      padding: EdgeInsets.all(horizontalPadding),
      itemCount: _logs.length,
      itemBuilder: (context, index) {
        final log = _logs[index];
        final isFirst = index == 0;
        final isLast = index == _logs.length - 1;
        return _buildLogCard(log, isFirst, isLast, index, isSmallScreen);
      },
    );
  }

  Widget _buildLogCard(
    RepairLogEntry log,
    bool isFirst,
    bool isLast,
    int index,
    bool isSmallScreen,
  ) {
    final timelineSize = isSmallScreen ? 10.0 : 12.0;
    final cardPadding = isSmallScreen ? 14.0 : 16.0;
    final cardRadius = isSmallScreen ? 14.0 : 16.0;
    final photoSize = isSmallScreen ? 52.0 : 60.0;
    final sectionSpacing = isSmallScreen ? 10.0 : 12.0;

    return GestureDetector(
      onTap: () => _navigateToEditLog(log),
      child: Container(
        margin: EdgeInsets.only(bottom: isSmallScreen ? 14 : 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 时间线
            Column(
              children: [
                Container(
                  width: timelineSize,
                  height: timelineSize,
                  decoration: BoxDecoration(
                    gradient: AppColors.getGradientByIndex(index),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withAlpha(128),
                        blurRadius: isSmallScreen ? 6 : 8,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: isSmallScreen ? 90 : 100,
                    margin: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 6 : 8,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          AppColors.primary.withAlpha(128),
                          AppColors.primary.withAlpha(26),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: isSmallScreen ? 12 : 16),
            // 内容卡片
            Expanded(
              child: Container(
                padding: EdgeInsets.all(cardPadding),
                decoration: AppDecorations.card(
                  color: AppColors.surface,
                  radius: cardRadius,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 日期和删除按钮
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppFormatters.formatDate(log.date),
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.primary,
                            fontSize: isSmallScreen ? 11 : 12,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showDeleteDialog(log),
                          child: Icon(
                            Icons.delete_outline,
                            color: AppColors.textLight,
                            size: isSmallScreen ? 18 : 20,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isSmallScreen ? 6 : 8),
                    // 标题
                    Text(
                      log.title,
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: isSmallScreen ? 15 : 16,
                      ),
                    ),
                    // 描述
                    if (log.description.isNotEmpty) ...[
                      SizedBox(height: isSmallScreen ? 6 : 8),
                      Text(
                        log.description,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: isSmallScreen ? 11 : 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    // 照片缩略图
                    if (log.photoPaths.isNotEmpty) ...[
                      SizedBox(height: sectionSpacing),
                      SizedBox(
                        height: photoSize,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: log.photoPaths.length,
                          separatorBuilder: (_, __) =>
                              SizedBox(width: isSmallScreen ? 6 : 8),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(
                                isSmallScreen ? 6 : 8,
                              ),
                              child: Image.file(
                                File(log.photoPaths[index]),
                                width: photoSize,
                                height: photoSize,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: photoSize,
                                    height: photoSize,
                                    color: AppColors.surfaceLight,
                                    child: Icon(
                                      Icons.image_not_supported,
                                      color: AppColors.textLight,
                                      size: isSmallScreen ? 22 : 24,
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                    // 材料和工具标签
                    if (log.materials.isNotEmpty || log.tools.isNotEmpty) ...[
                      SizedBox(height: sectionSpacing),
                      Wrap(
                        spacing: isSmallScreen ? 6 : 8,
                        runSpacing: isSmallScreen ? 6 : 8,
                        children: [
                          ...log.materials.map(
                            (material) => _buildTag(
                              material,
                              AppColors.cyanGradient,
                              isSmallScreen,
                            ),
                          ),
                          ...log.tools.map(
                            (tool) => _buildTag(
                              tool,
                              AppColors.purpleGradient,
                              isSmallScreen,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String text, LinearGradient gradient, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 8 : 10,
        vertical: isSmallScreen ? 3 : 4,
      ),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(isSmallScreen ? 8 : 10),
      ),
      child: Text(
        text,
        style: AppTextStyles.labelSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: isSmallScreen ? 10 : 11,
        ),
      ),
    );
  }

  void _showDeleteDialog(RepairLogEntry log) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('删除日志？', style: AppTextStyles.headline3),
        content: Text(
          '确定要删除"${log.title}"这条日志吗？此操作无法撤销。',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              '取消',
              style: AppTextStyles.labelLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteLog(log.id);
            },
            child: Text(
              '删除',
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
