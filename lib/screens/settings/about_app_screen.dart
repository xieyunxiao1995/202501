import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

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
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(AppConstants.spacing20),
                  child: Column(
                    children: [
                      _buildAppLogoCard(),
                      const SizedBox(height: AppConstants.spacing20),
                      _buildInfoCard(),
                      const SizedBox(height: AppConstants.spacing20),
                      _buildFeaturesCard(),
                      const SizedBox(height: AppConstants.spacing20),
                      _buildContactCard(),
                      const SizedBox(height: AppConstants.spacing20),
                      _buildSocialMediaCard(),
                    ],
                  ),
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
            '关于应用',
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

  Widget _buildAppLogoCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacing32),
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
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppConstants.primaryColor,
                  AppConstants.primaryColor.withValues(alpha: 0.7),
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
            child: const Icon(Icons.nature, size: 50, color: Colors.white),
          ),
          const SizedBox(height: AppConstants.spacing20),
          const Text(
            '悦伴',
            style: TextStyle(
              fontSize: AppConstants.fontSizeHeading1,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(height: AppConstants.spacing8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacing16,
              vertical: AppConstants.spacing8,
            ),
            decoration: BoxDecoration(
              color: AppConstants.accentColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusRound),
            ),
            child: const Text(
              '版本 1.0.0',
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                fontWeight: FontWeight.w600,
                color: AppConstants.accentColor,
              ),
            ),
          ),
          const SizedBox(height: AppConstants.spacing16),
          const Text(
            '露营社区与工具',
            style: TextStyle(
              fontSize: AppConstants.fontSizeLarge,
              color: AppConstants.neutralColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
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
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                child: const Icon(
                  Icons.info_outline,
                  color: Color(0xFF4A90E2),
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.spacing12),
              const Text(
                '关于 悦伴',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeHeading3,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing20),
          const Text(
            '您的户外冒险和露营体验的终极伴侣。悦伴汇聚了充满热情的户外爱好者社区，提供工具和资源来规划、追踪和分享您的露营之旅。',
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: AppConstants.neutralColor,
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppConstants.spacing20),
          _buildInfoRow(Icons.calendar_today, '发布时间', '2025年11月'),
          const SizedBox(height: AppConstants.spacing12),
          _buildInfoRow(Icons.people, '社区用户', '10,000+ 用户'),
          const SizedBox(height: AppConstants.spacing12),
          _buildInfoRow(Icons.star, '评分', '4.8/5.0'),
        ],
      ),
    );
  }

  Widget _buildFeaturesCard() {
    return Container(
      width: double.infinity,
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
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Color(0xFF66BB6A),
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.spacing12),
              const Text(
                '核心功能',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeHeading3,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing20),
          _buildFeatureItem(
            Icons.explore,
            '发现',
            '寻找令人惊叹的露营地点和隐藏宝地',
            const Color(0xFF4A90E2),
          ),
          _buildFeatureItem(
            Icons.book,
            '露营日志',
            '追踪和记录您的露营冒险',
            const Color(0xFF66BB6A),
          ),
          _buildFeatureItem(
            Icons.people,
            '社区',
            '与户外爱好者建立联系',
            const Color(0xFFFF9800),
          ),
          _buildFeatureItem(
            Icons.smart_toy,
            'AI 助手',
            '获取由AI驱动的专业露营建议',
            const Color(0xFF9C27B0),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
    return Container(
      width: double.infinity,
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
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                child: const Icon(
                  Icons.contact_mail,
                  color: Color(0xFFFF9800),
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.spacing12),
              const Text(
                '联系我们',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeHeading3,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing20),
          _buildContactItem(Icons.email, '邮箱', 'support@celva.app'),
          const SizedBox(height: AppConstants.spacing12),
          _buildContactItem(Icons.language, '网站', 'www.celva.app'),
          const SizedBox(height: AppConstants.spacing12),
          _buildContactItem(Icons.business, '公司', '悦伴 Technologies Inc.'),
        ],
      ),
    );
  }

  Widget _buildSocialMediaCard() {
    return Container(
      width: double.infinity,
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
          const Text(
            '关注我们',
            style: TextStyle(
              fontSize: AppConstants.fontSizeHeading3,
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryColor,
            ),
          ),
          const SizedBox(height: AppConstants.spacing16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSocialButton(Icons.facebook, const Color(0xFF1877F2)),
              _buildSocialButton(Icons.camera_alt, const Color(0xFFE4405F)),
              _buildSocialButton(Icons.chat, const Color(0xFF1DA1F2)),
              _buildSocialButton(Icons.video_library, const Color(0xFFFF0000)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppConstants.accentColor),
        const SizedBox(width: AppConstants.spacing12),
        Text(
          '$label: ',
          style: const TextStyle(
            fontSize: AppConstants.fontSizeMedium,
            fontWeight: FontWeight.w600,
            color: AppConstants.neutralColor,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: Colors.grey[600],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(
    IconData icon,
    String title,
    String description,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacing16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.spacing8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusSmall),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: AppConstants.spacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeMedium,
                    fontWeight: FontWeight.w600,
                    color: AppConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: Colors.grey[600],
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppConstants.accentColor),
        const SizedBox(width: AppConstants.spacing12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  fontWeight: FontWeight.w500,
                  color: AppConstants.neutralColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }
}
