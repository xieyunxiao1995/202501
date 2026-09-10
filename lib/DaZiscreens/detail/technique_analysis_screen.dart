import 'package:flutter/material.dart';
import '../../DaZitheme/app_colors.dart';
import '../../DaZitheme/app_text_styles.dart';
import '../../DaZiservices/storage_service.dart';
import '../../DaZiservices/project_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TechniqueAnalysisScreen extends StatefulWidget {
  const TechniqueAnalysisScreen({super.key});

  @override
  State<TechniqueAnalysisScreen> createState() =>
      _TechniqueAnalysisScreenState();
}

class _TechniqueAnalysisScreenState extends State<TechniqueAnalysisScreen> {
  late ProjectService _projectService;
  bool _isLoading = true;
  String? _recommendation;
  String? _projectId;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initServices();
  }

  Future<void> _initServices() async {
    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs);
    _projectService = ProjectService(storageService: storageService);

    if (!mounted) return;
    _projectId = ModalRoute.of(context)?.settings.arguments as String?;
    if (_projectId != null) {
      await _loadRecommendation();
    } else {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = '未指定项目';
        });
      }
    }
  }

  Future<void> _loadRecommendation() async {
    final project = await _projectService.getProjectById(_projectId!);
    if (project == null) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _error = '项目未找到';
        });
      }
      return;
    }

    // If we already have recommendations, show the last one
    if (project.aiRecommendations.isNotEmpty) {
      if (mounted) {
        setState(() {
          _recommendation = project.aiRecommendations.last;
          _isLoading = false;
        });
      }
      return;
    }

    // Otherwise, generate a new one
    try {
      final recommendation = await _projectService.getTechniqueRecommendation(
        project,
      );
      if (mounted) {
        setState(() {
          _recommendation = recommendation;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = '生成建议失败: $e';
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('技术分析', style: AppTextStyles.headline3),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: AppColors.accentGold),
            const SizedBox(height: 24),
            Text(
              '正在分析您的修复...',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: AppColors.error, size: 48),
              const SizedBox(height: 16),
              Text(
                _error!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white.withAlpha(51),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.auto_awesome, color: Colors.white),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '金绪分析',
                        style: AppTextStyles.headline3.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '为您修复的技术建议',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white.withAlpha(204),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Recommendation content
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.accentGold.withAlpha(51),
              ),
            ),
            child: Text(
              _recommendation ?? '暂无建议',
              style: AppTextStyles.bodyMedium.copyWith(height: 1.6),
            ),
          ),
          const SizedBox(height: 24),

          // Tips
          Text('请记住', style: AppTextStyles.labelLarge),
          const SizedBox(height: 12),
          _buildTipCard(
            icon: Icons.timer_outlined,
            title: '耐心细致',
            description: '金缮是一种冥想过程，急于求成容易出错。',
          ),
          const SizedBox(height: 12),
          _buildTipCard(
            icon: Icons.psychology,
            title: '接受不完美',
            description: '金缮之美在于赞美修复。',
          ),
          const SizedBox(height: 12),
          _buildTipCard(
            icon: Icons.eco,
            title: '安全操作',
            description: '使用漆料时请确保通风良好。',
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withAlpha(51),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.labelLarge),
                Text(description, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
