import 'dart:io';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../models/repair_project.dart';
import '../../services/storage_service.dart';
import '../../services/project_service.dart';
import '../../utils/constants.dart';
import '../../utils/formatters.dart';
import '../../config/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepairDetailScreen extends StatefulWidget {
  const RepairDetailScreen({super.key});

  @override
  State<RepairDetailScreen> createState() => _RepairDetailScreenState();
}

class _RepairDetailScreenState extends State<RepairDetailScreen> {
  late ProjectService _projectService;
  RepairProject? _project;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs);
    _projectService = ProjectService(storageService: storageService);

    // Get project ID from route arguments
    if (!mounted) return;
    final projectId = ModalRoute.of(context)?.settings.arguments as String?;
    if (projectId != null) {
      final project = await _projectService.getProjectById(projectId);
      if (mounted) {
        setState(() {
          _project = project;
          _isLoading = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateProgress(int newProgress) async {
    if (_project != null) {
      await _projectService.updateProgress(_project!.id, newProgress);
      final updated = await _projectService.getProjectById(_project!.id);
      if (mounted) {
        setState(() {
          _project = updated;
        });
      }
    }
  }

  Future<void> _deleteProject() async {
    if (_project != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('删除项目？', style: AppTextStyles.headline3),
          content: Text('此操作无法撤销。', style: AppTextStyles.bodyMedium),
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
              onPressed: () async {
                Navigator.pop(context);
                await _projectService.deleteProject(_project!.id);
                if (mounted) {
                  Navigator.of(this.context).pop();
                }
              },
              child: Text(
                '删除',
                style: AppTextStyles.labelLarge.copyWith(
                  color: AppColors.error,
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(_project?.title ?? '修复详情', style: AppTextStyles.headline3),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: AppColors.error,
            onPressed: _deleteProject,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _project == null
          ? _buildNotFound()
          : _buildContent(),
    );
  }

  Widget _buildNotFound() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: AppColors.textLight),
          const SizedBox(height: 16),
          Text('项目未找到', style: AppTextStyles.headline3),
        ],
      ),
    );
  }

  Widget _buildContent() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;
    final horizontalPadding = isSmallScreen ? 16.0 : 20.0;
    final sectionSpacing = isSmallScreen ? 16.0 : 20.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main photo
          if (_project!.photoPaths.isNotEmpty)
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.photoFullscreen,
                  arguments: _project!.photoPaths.first,
                );
              },
              child: Container(
                height: isSmallScreen ? 180 : 220,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
                  color: AppColors.surface,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
                  child: Image.file(
                    File(_project!.photoPaths.first),
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.textLight,
                        size: isSmallScreen ? 40 : 48,
                      );
                    },
                  ),
                ),
              ),
            ),
          SizedBox(height: isSmallScreen ? 20 : 24),

          // Progress
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '进度',
                      style: AppTextStyles.labelLarge.copyWith(
                        fontSize: isSmallScreen ? 15 : 16,
                      ),
                    ),
                    Text(
                      '${_project!.techniqueProgress}%',
                      style: AppTextStyles.labelLarge.copyWith(
                        color: AppColors.accentGold,
                        fontSize: isSmallScreen ? 15 : 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 10 : 12),
                LinearProgressIndicator(
                  value: _project!.techniqueProgress / 100,
                  backgroundColor: AppColors.surfaceLight,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.accentGold,
                  ),
                  minHeight: isSmallScreen ? 7 : 8,
                  borderRadius: BorderRadius.circular(4),
                ),
                SizedBox(height: isSmallScreen ? 14 : 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [0, 25, 50, 75, 100].map((value) {
                    return GestureDetector(
                      onTap: () => _updateProgress(value),
                      child: Container(
                        width: isSmallScreen ? 42 : 48,
                        height: isSmallScreen ? 28 : 32,
                        decoration: BoxDecoration(
                          color: _project!.techniqueProgress >= value
                              ? AppColors.accentGold.withAlpha(51)
                              : AppColors.background,
                          borderRadius: BorderRadius.circular(
                            isSmallScreen ? 7 : 8,
                          ),
                          border: Border.all(
                            color: _project!.techniqueProgress >= value
                                ? AppColors.accentGold
                                : AppColors.surfaceLight,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            '$value%',
                            style: AppTextStyles.caption.copyWith(
                              color: _project!.techniqueProgress >= value
                                  ? AppColors.accentGold
                                  : AppColors.textSecondary,
                              fontSize: isSmallScreen ? 11 : 12,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          SizedBox(height: sectionSpacing),

          // 修复日志入口
          GestureDetector(
            onTap: () {
              Navigator.of(
                context,
              ).pushNamed(AppRoutes.repairLog, arguments: _project!.id);
            },
            child: Container(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              decoration: BoxDecoration(
                gradient: AppColors.pinkGradient,
                borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.pinkStart.withAlpha(128),
                    blurRadius: isSmallScreen ? 12 : 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: isSmallScreen ? 44 : 48,
                    height: isSmallScreen ? 44 : 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(51),
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 10 : 12,
                      ),
                    ),
                    child: Icon(
                      Icons.history,
                      color: Colors.white,
                      size: isSmallScreen ? 22 : 24,
                    ),
                  ),
                  SizedBox(width: isSmallScreen ? 12 : 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '日志',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: isSmallScreen ? 15 : 16,
                          ),
                        ),
                        SizedBox(height: isSmallScreen ? 3 : 4),
                        Text(
                          '记录修复进度、材料和心得',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: Colors.white.withAlpha(204),
                            fontSize: isSmallScreen ? 11 : 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                    size: isSmallScreen ? 22 : 24,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: sectionSpacing),

          // Details
          Container(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
            ),
            child: Column(
              children: [
                _buildDetailRow(
                  '损坏类型',
                  AppConstants.getDamageTypeLabel(_project!.damageType),
                  isSmallScreen,
                ),
                Divider(height: isSmallScreen ? 20 : 24),
                _buildDetailRow(
                  '材质',
                  AppConstants.getMaterialLabel(_project!.material),
                  isSmallScreen,
                ),
                Divider(height: isSmallScreen ? 20 : 24),
                _buildDetailRow(
                  '美学风格',
                  AppConstants.getAestheticLabel(_project!.aesthetic),
                  isSmallScreen,
                ),
                Divider(height: isSmallScreen ? 20 : 24),
                _buildDetailRow(
                  '创建时间',
                  AppFormatters.formatDate(_project!.createdAt),
                  isSmallScreen,
                ),
                Divider(height: isSmallScreen ? 20 : 24),
                _buildDetailRow(
                  '更新时间',
                  AppFormatters.formatRelativeTime(_project!.updatedAt),
                  isSmallScreen,
                ),
              ],
            ),
          ),
          SizedBox(height: sectionSpacing),

          // Description
          if (_project!.description.isNotEmpty) ...[
            Text(
              '描述',
              style: AppTextStyles.labelLarge.copyWith(
                fontSize: isSmallScreen ? 15 : 16,
              ),
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
              ),
              child: Text(
                _project!.description,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontSize: isSmallScreen ? 13 : 14,
                ),
              ),
            ),
            SizedBox(height: sectionSpacing),
          ],

          // Crack Narrative
          if (_project!.crackNarrative.isNotEmpty) ...[
            Text(
              '裂痕叙事',
              style: AppTextStyles.labelLarge.copyWith(
                fontSize: isSmallScreen ? 15 : 16,
              ),
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                border: Border.all(color: AppColors.accentGold.withAlpha(77)),
              ),
              child: Text(
                _project!.crackNarrative,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontStyle: FontStyle.italic,
                  fontSize: isSmallScreen ? 13 : 14,
                ),
              ),
            ),
            SizedBox(height: sectionSpacing),
          ],

          // AI Recommendations
          if (_project!.aiRecommendations.isNotEmpty) ...[
            Text(
              'AI 建议',
              style: AppTextStyles.labelLarge.copyWith(
                fontSize: isSmallScreen ? 15 : 16,
              ),
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            ...(_project!.aiRecommendations.map(
              (rec) => Container(
                margin: EdgeInsets.only(bottom: isSmallScreen ? 10 : 12),
                padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                ),
                child: Text(
                  rec,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: isSmallScreen ? 13 : 14,
                  ),
                ),
              ),
            )),
          ],

          SizedBox(height: isSmallScreen ? 24 : 40),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isSmallScreen) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            fontSize: isSmallScreen ? 13 : 14,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.labelMedium.copyWith(
            fontSize: isSmallScreen ? 12 : 13,
          ),
        ),
      ],
    );
  }
}
