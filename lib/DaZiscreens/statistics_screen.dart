import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../services/storage_service.dart';
import '../../services/project_service.dart';
import '../../utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  late ProjectService _projectService;
  Map<String, dynamic> _statistics = {};
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
    await _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    final stats = await _projectService.getStatistics();
    if (mounted) {
      setState(() {
        _statistics = stats;
        _isLoading = false;
      });
    }
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
          '统计',
          style: AppTextStyles.headline3.copyWith(
            fontSize: isSmallScreen ? 16 : 18,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildContent(isSmallScreen),
    );
  }

  Widget _buildContent(bool isSmallScreen) {
    final totalProjects = _statistics['totalProjects'] as int? ?? 0;
    final completedProjects = _statistics['completedProjects'] as int? ?? 0;
    final inProgressProjects = _statistics['inProgressProjects'] as int? ?? 0;
    final averageProgress = _statistics['averageProgress'] as double? ?? 0.0;
    final damageTypes =
        _statistics['damageTypeDistribution'] as Map<String, int>? ?? {};

    final horizontalPadding = isSmallScreen ? 16.0 : 20.0;
    final sectionSpacing = isSmallScreen ? 20.0 : 24.0;
    final mainCardPadding = isSmallScreen ? 20.0 : 24.0;
    final progressRingSize = isSmallScreen ? 100.0 : 120.0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(horizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main stats card
          Container(
            padding: EdgeInsets.all(mainCardPadding),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(isSmallScreen ? 18 : 20),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildMainStat(
                      value: totalProjects.toString(),
                      label: '项目总数',
                      isSmallScreen: isSmallScreen,
                    ),
                    Container(
                      width: 1,
                      height: isSmallScreen ? 36 : 40,
                      color: Colors.white.withAlpha(77),
                    ),
                    _buildMainStat(
                      value: completedProjects.toString(),
                      label: '已完成',
                      isSmallScreen: isSmallScreen,
                    ),
                    Container(
                      width: 1,
                      height: isSmallScreen ? 36 : 40,
                      color: Colors.white.withAlpha(77),
                    ),
                    _buildMainStat(
                      value: inProgressProjects.toString(),
                      label: '进行中',
                      isSmallScreen: isSmallScreen,
                    ),
                  ],
                ),
                SizedBox(height: isSmallScreen ? 20 : 24),
                // Progress ring
                SizedBox(
                  width: progressRingSize,
                  height: progressRingSize,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: progressRingSize,
                        height: progressRingSize,
                        child: CircularProgressIndicator(
                          value: averageProgress / 100,
                          strokeWidth: isSmallScreen ? 7 : 8,
                          backgroundColor: Colors.white.withAlpha(51),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '${averageProgress.toStringAsFixed(0)}%',
                            style: AppTextStyles.headline2.copyWith(
                              color: Colors.white,
                              fontSize: isSmallScreen ? 20 : 22,
                            ),
                          ),
                          Text(
                            '平均进度',
                            style: AppTextStyles.caption.copyWith(
                              color: Colors.white.withAlpha(204),
                              fontSize: isSmallScreen ? 11 : 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: sectionSpacing),

          // Damage type distribution
          if (damageTypes.isNotEmpty) ...[
            Text(
              '损坏类型分布',
              style: AppTextStyles.labelLarge.copyWith(
                fontSize: isSmallScreen ? 15 : 16,
              ),
            ),
            SizedBox(height: isSmallScreen ? 10 : 12),
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
              ),
              child: Column(
                children: damageTypes.entries.map((entry) {
                  final percentage = totalProjects > 0
                      ? (entry.value / totalProjects * 100).toStringAsFixed(0)
                      : '0';
                  return Padding(
                    padding: EdgeInsets.only(bottom: isSmallScreen ? 10 : 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppConstants.getDamageTypeLabel(entry.key),
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontSize: isSmallScreen ? 13 : 14,
                                    ),
                                  ),
                                  Text(
                                    '$percentage%',
                                    style: AppTextStyles.labelMedium.copyWith(
                                      color: AppColors.primary,
                                      fontSize: isSmallScreen ? 12 : 13,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: isSmallScreen ? 6 : 8),
                              LinearProgressIndicator(
                                value: double.parse(percentage) / 100,
                                backgroundColor: AppColors.surfaceLight,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                                minHeight: isSmallScreen ? 5 : 6,
                                borderRadius: BorderRadius.circular(3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            SizedBox(height: sectionSpacing),
          ],

          // Quick stats
          Text(
            '快速统计',
            style: AppTextStyles.labelLarge.copyWith(
              fontSize: isSmallScreen ? 15 : 16,
            ),
          ),
          SizedBox(height: isSmallScreen ? 10 : 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickStatCard(
                  icon: Icons.check_circle_outline,
                  value: _statistics['totalCompleted']?.toString() ?? '0',
                  label: '总完成数',
                  color: AppColors.success,
                  isSmallScreen: isSmallScreen,
                ),
              ),
              SizedBox(width: isSmallScreen ? 10 : 12),
              Expanded(
                child: _buildQuickStatCard(
                  icon: Icons.archive_outlined,
                  value: _statistics['archivedProjects']?.toString() ?? '0',
                  label: '已归档',
                  color: AppColors.textSecondary,
                  isSmallScreen: isSmallScreen,
                ),
              ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 24 : 40),

          // Empty state message if no projects
          if (totalProjects == 0)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 32 : 40,
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.bar_chart_rounded,
                      size: isSmallScreen ? 56 : 64,
                      color: AppColors.textLight,
                    ),
                    SizedBox(height: isSmallScreen ? 14 : 16),
                    Text(
                      '暂无项目',
                      style: AppTextStyles.headline3.copyWith(
                        color: AppColors.textSecondary,
                        fontSize: isSmallScreen ? 16 : 18,
                      ),
                    ),
                    Text(
                      '创建您的第一个修复项目以查看统计',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: isSmallScreen ? 11 : 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMainStat({
    required String value,
    required String label,
    required bool isSmallScreen,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.headline2.copyWith(
            color: Colors.white,
            fontSize: isSmallScreen ? 20 : 22,
          ),
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: Colors.white.withAlpha(204),
            fontSize: isSmallScreen ? 11 : 12,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required bool isSmallScreen,
  }) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: isSmallScreen ? 24 : 28),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            value,
            style: AppTextStyles.headline3.copyWith(
              color: color,
              fontSize: isSmallScreen ? 16 : 18,
            ),
          ),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: isSmallScreen ? 11 : 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
