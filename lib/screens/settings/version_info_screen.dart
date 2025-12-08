import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class VersionInfoScreen extends StatelessWidget {
  const VersionInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.6, 1.0],
            colors: [
              Color(0xFFF8FAFF),
              Color(0xFFEDF4FF),
              Color(0xFFE8F2FF),
              Color(0xFFF0F8FF),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(context),
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(AppConstants.spacing20),
                  children: [
                    _buildCurrentVersionCard(),
                    const SizedBox(height: AppConstants.spacing20),
                    _buildVersionCard(
                      version: '版本 1.0.0',
                      date: '2025年11月26日',
                      isLatest: true,
                      features: [
                        '悦伴 应用首次发布',
                        '发现功能，用于查找露营地点',
                        '露营日志追踪和记录',
                        '带有 AI 助手的社区功能',
                        '用户资料和社交互动',
                        '离线模式支持',
                        '多语言支持',
                      ],
                      improvements: ['优化应用性能', '增强 UI/UX 设计', '改进搜索功能'],
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    _buildRoadmapCard(),
                    const SizedBox(height: AppConstants.spacing16),
                    _buildUpdateInfoCard(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacing16,
        vertical: AppConstants.spacing12,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppConstants.primaryColor,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          const Text(
            '版本信息',
            style: TextStyle(
              fontSize: AppConstants.fontSizeHeading3,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentVersionCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppConstants.primaryColor,
            AppConstants.primaryColor.withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
            child: const Icon(
              Icons.system_update,
              size: 40,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppConstants.spacing20),
          const Text(
            '当前版本',
            style: TextStyle(
              fontSize: AppConstants.fontSizeLarge,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: AppConstants.spacing8),
          const Text(
            '1.0.0',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppConstants.spacing16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacing20,
              vertical: AppConstants.spacing8,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppConstants.radiusRound),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  '已是最新',
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionCard({
    required String version,
    required String date,
    required bool isLatest,
    required List<String> features,
    List<String>? improvements,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      version,
                      style: const TextStyle(
                        fontSize: AppConstants.fontSizeHeading2,
                        fontWeight: FontWeight.bold,
                        color: AppConstants.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeSmall,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (isLatest)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacing12,
                    vertical: AppConstants.spacing8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF66BB6A).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(
                      AppConstants.radiusRound,
                    ),
                  ),
                  child: const Text(
                    '最新',
                    style: TextStyle(
                      fontSize: AppConstants.fontSizeSmall,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF66BB6A),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing24),
          _buildSectionTitle(
            '新功能',
            Icons.auto_awesome,
            const Color(0xFF4A90E2),
          ),
          const SizedBox(height: AppConstants.spacing12),
          ...features.map(
            (feature) => _buildFeatureItem(feature, const Color(0xFF66BB6A)),
          ),
          if (improvements != null && improvements.isNotEmpty) ...[
            const SizedBox(height: AppConstants.spacing20),
            _buildSectionTitle(
              '改进',
              Icons.trending_up,
              const Color(0xFFFF9800),
            ),
            const SizedBox(height: AppConstants.spacing12),
            ...improvements.map(
              (improvement) =>
                  _buildFeatureItem(improvement, const Color(0xFFFF9800)),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRoadmapCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacing12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5F5),
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                child: const Icon(
                  Icons.rocket_launch,
                  color: Color(0xFF9C27B0),
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.spacing12),
              const Text(
                '即将推出',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeHeading3,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing20),
          _buildRoadmapItem('带 GPS 追踪的高级路线规划', '2026年第一季度'),
          _buildRoadmapItem('天气集成和警报', '2026年第一季度'),
          _buildRoadmapItem('分享到外部平台', '2026年第二季度'),
          _buildRoadmapItem('装备市场和评论', '2026年第二季度'),
          _buildRoadmapItem('虚拟露营之旅', '2026年第三季度'),
          _buildRoadmapItem('露营挑战和成就', '2026年第三季度'),
        ],
      ),
    );
  }

  Widget _buildUpdateInfoCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing20),
      decoration: BoxDecoration(
        color: const Color(0xFFE0F7FA),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(
          color: const Color(0xFF00BCD4).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, color: Color(0xFF00BCD4), size: 24),
          const SizedBox(width: AppConstants.spacing16),
          Expanded(
            child: Text(
              '更新可用时会自动下载。您也可以在设备设置中手动检查更新。',
              style: TextStyle(
                fontSize: AppConstants.fontSizeSmall,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: AppConstants.fontSizeMedium,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(Icons.check_circle, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoadmapItem(String feature, String timeline) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacing12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 4),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF9C27B0),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  feature,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    color: Colors.grey[800],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  timeline,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
