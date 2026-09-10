import 'dart:io';
import 'package:flutter/material.dart';
import '../../DaZitheme/app_colors.dart';
import '../../DaZitheme/app_text_styles.dart';
import '../../DaZitheme/app_decorations.dart';
import '../../DaZimodels/repair_project.dart';
import '../../DaZiservices/storage_service.dart';
import '../../DaZiservices/project_service.dart';
import '../../DaZiutils/constants.dart';
import '../../DaZiutils/formatters.dart';
import '../../DaZiconfig/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 画廊页面 - 深色霓虹风格
class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  GalleryScreenState createState() => GalleryScreenState();
}

class GalleryScreenState extends State<GalleryScreen>
    with WidgetsBindingObserver {
  late ProjectService _projectService;
  List<RepairProject> _projects = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initServices();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _loadProjects();
    }
  }

  Future<void> _initServices() async {
    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs);
    _projectService = ProjectService(storageService: storageService);
    await _loadProjects();
  }

  Future<void> refresh() async {
    await _loadProjects();
  }

  Future<void> _loadProjects() async {
    final projects = await _projectService.getActiveProjects();
    if (mounted) {
      setState(() {
        _projects = projects;
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteProject(String projectId) async {
    await _projectService.deleteProject(projectId);
    await _loadProjects();
  }

  void _navigateToDetail(RepairProject project) {
    Navigator.of(context)
        .pushNamed(AppRoutes.repairDetail, arguments: project.id)
        .then((_) => _loadProjects());
  }

  /// 获取卡片渐变
  LinearGradient _getCardGradient(int index) {
    return AppColors.getGradientByIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _projects.isEmpty
            ? _buildEmptyState()
            : _buildProjectGrid(),
      ),
    );
  }

  /// 空状态 - 霓虹风格
  Widget _buildEmptyState() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallScreen = screenWidth < 375;
        final iconSize = isSmallScreen ? 100.0 : 140.0;
        final iconInnerSize = isSmallScreen ? 48.0 : 60.0;

        return Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isSmallScreen ? 24 : 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 发光图标容器
                Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    gradient: AppColors.pinkGradient,
                    borderRadius: BorderRadius.circular(iconSize / 2),
                    boxShadow: [
                      // 发光效果
                      BoxShadow(
                        color: AppColors.pinkStart.withAlpha(128),
                        blurRadius: isSmallScreen ? 24 : 30,
                        offset: const Offset(0, 8),
                        spreadRadius: -5,
                      ),
                      BoxShadow(
                        color: AppColors.pinkEnd.withAlpha(77),
                        blurRadius: isSmallScreen ? 32 : 40,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.auto_fix_high,
                    size: iconInnerSize,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 24 : 32),
                Text(
                  '暂无修复项目',
                  style: AppTextStyles.headline2.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: isSmallScreen ? 20 : 22,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 10 : 12),
                Text(
                  '开始您的金缮之旅，创建第一个修复项目。',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: isSmallScreen ? 13 : 14,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// 项目网格 - 深色卡片风格
  Widget _buildProjectGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = MediaQuery.of(context).size.width;
        final isSmallScreen = screenWidth < 375;
        final isVerySmallScreen = screenWidth < 340;
        final horizontalPadding = isSmallScreen ? 16.0 : 20.0;
        final gridPadding = isSmallScreen ? 12.0 : 16.0;
        final crossAxisSpacing = isSmallScreen ? 12.0 : 16.0;
        final mainAxisSpacing = isSmallScreen ? 12.0 : 16.0;
        final childAspectRatio = isVerySmallScreen
            ? 0.62
            : (isSmallScreen ? 0.65 : 0.68);

        return RefreshIndicator(
          color: AppColors.primary,
          backgroundColor: AppColors.surface,
          onRefresh: _loadProjects,
          child: CustomScrollView(
            slivers: [
              // 头部
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    isSmallScreen ? 16 : 20,
                    horizontalPadding,
                    isSmallScreen ? 12 : 16,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '我的画廊',
                            style: AppTextStyles.headline1.copyWith(
                              fontSize: isSmallScreen ? 24 : 28,
                            ),
                          ),
                          SizedBox(height: isSmallScreen ? 4 : 6),
                          Text(
                            '${_projects.length} 个修复项目',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontSize: isSmallScreen ? 13 : 14,
                            ),
                          ),
                        ],
                      ),
                      // 统计按钮 - 霓虹风格
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(AppRoutes.statistics);
                        },
                        child: Container(
                          width: isSmallScreen ? 48 : 52,
                          height: isSmallScreen ? 48 : 52,
                          decoration: BoxDecoration(
                            gradient: AppColors.purpleGradient,
                            borderRadius: BorderRadius.circular(
                              isSmallScreen ? 16 : 18,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.purpleStart.withAlpha(128),
                                blurRadius: isSmallScreen ? 12 : 16,
                                offset: const Offset(0, 6),
                                spreadRadius: -4,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.bar_chart_rounded,
                            color: Colors.white,
                            size: isSmallScreen ? 24 : 26,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 网格
              SliverPadding(
                padding: EdgeInsets.all(gridPadding),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: childAspectRatio,
                    crossAxisSpacing: crossAxisSpacing,
                    mainAxisSpacing: mainAxisSpacing,
                  ),
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final project = _projects[index];
                    return _buildProjectCard(project, index, isSmallScreen);
                  }, childCount: _projects.length),
                ),
              ),
              // 底部间距
              SliverToBoxAdapter(
                child: SizedBox(height: isSmallScreen ? 16 : 20),
              ),
            ],
          ),
        );
      },
    );
  }

  /// 项目卡片 - 深色悬浮卡片
  Widget _buildProjectCard(
    RepairProject project,
    int index,
    bool isSmallScreen,
  ) {
    final gradient = _getCardGradient(index);
    final cardRadius = isSmallScreen ? 20.0 : 24.0;
    final contentPadding = isSmallScreen
        ? const EdgeInsets.fromLTRB(10, 10, 10, 6)
        : const EdgeInsets.fromLTRB(12, 12, 12, 8);

    return GestureDetector(
      onTap: () => _navigateToDetail(project),
      onLongPress: () => _showDeleteDialog(project),
      child: Container(
        decoration: AppDecorations.card(
          color: AppColors.surface,
          radius: cardRadius,
          hasGlow: true,
          glowColor: gradient.colors.first,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 图片区域 - 渐变叠加
            Expanded(
              flex: 3,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(cardRadius),
                    topRight: Radius.circular(cardRadius),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.colors.first.withAlpha(77),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: project.photoPaths.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(cardRadius),
                          topRight: Radius.circular(cardRadius),
                        ),
                        child: Image.file(
                          File(project.photoPaths.first),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image_not_supported_outlined,
                              color: Colors.white54,
                              size: isSmallScreen ? 32 : 40,
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.image_outlined,
                          color: Colors.white54,
                          size: isSmallScreen ? 32 : 40,
                        ),
                      ),
              ),
            ),
            // 内容区域
            Expanded(
              flex: 2,
              child: ClipRect(
                child: Padding(
                  padding: contentPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        project.title,
                        style: AppTextStyles.labelLarge.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: isSmallScreen ? 14 : 16,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: isSmallScreen ? 2 : 4),
                      // 标签 - 渐变背景
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 6 : 8,
                          vertical: isSmallScreen ? 1 : 2,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              gradient.colors.first.withAlpha(51),
                              gradient.colors.last.withAlpha(51),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(
                            isSmallScreen ? 6 : 8,
                          ),
                        ),
                        child: Text(
                          AppConstants.getDamageTypeLabel(project.damageType),
                          style: AppTextStyles.labelSmall.copyWith(
                            color: gradient.colors.first,
                            fontWeight: FontWeight.w600,
                            fontSize: isSmallScreen ? 9 : 11,
                          ),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 2 : 3),
                      // 进度条
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: project.techniqueProgress / 100,
                                backgroundColor: AppColors.surfaceLight,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  gradient.colors.first,
                                ),
                                minHeight: isSmallScreen ? 4 : 6,
                              ),
                            ),
                          ),
                          SizedBox(width: isSmallScreen ? 6 : 8),
                          Text(
                            '${project.techniqueProgress}%',
                            style: AppTextStyles.labelSmall.copyWith(
                              fontWeight: FontWeight.w600,
                              color: gradient.colors.first,
                              fontSize: isSmallScreen ? 9 : 11,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: isSmallScreen ? 2 : 3),
                      Text(
                        AppFormatters.formatRelativeTime(project.updatedAt),
                        style: AppTextStyles.captionMuted.copyWith(
                          fontSize: isSmallScreen ? 9 : 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 删除对话框 - 深色风格
  void _showDeleteDialog(RepairProject project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('删除项目？', style: AppTextStyles.headline3),
        content: Text(
          '确定要删除"${project.title}"吗？此操作无法撤销。',
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
              _deleteProject(project.id);
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
