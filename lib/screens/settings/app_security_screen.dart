import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class AppSecurityScreen extends StatelessWidget {
  const AppSecurityScreen({super.key});

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
                    _buildSecurityOverviewCard(),
                    const SizedBox(height: AppConstants.spacing20),
                    _buildSecurityFeatureCard(
                      icon: Icons.lock,
                      iconColor: const Color(0xFF66BB6A),
                      iconBg: const Color(0xFFE8F5E9),
                      title: '数据加密',
                      description: '您的数据安全是我们的首要任务。所有敏感信息都使用行业标准的 AES-256 加密。',
                      features: [
                        '消息端到端加密',
                        '个人信息安全存储',
                        '加密数据传输（HTTPS/TLS）',
                        '定期安全审计和更新',
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    _buildSecurityFeatureCard(
                      icon: Icons.fingerprint,
                      iconColor: const Color(0xFF4A90E2),
                      iconBg: const Color(0xFFE3F2FD),
                      title: '身份验证与访问',
                      description: '多层身份验证确保只有您可以访问您的账户。',
                      features: [
                        '安全密码要求（最少8个字符）',
                        '生物识别认证支持（Face ID/Touch ID）',
                        '双因素认证（2FA）可用',
                        '不活动后自动会话超时',
                        '设备管理和受信任设备',
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    _buildSecurityFeatureCard(
                      icon: Icons.privacy_tip,
                      iconColor: const Color(0xFFFF9800),
                      iconBg: const Color(0xFFFFF3E0),
                      title: '隐私保护',
                      description: '我们尊重您的隐私，让您完全控制您的个人信息。',
                      features: [
                        '个人资料可见性的细粒度隐私设置',
                        '控制谁可以看到您的帖子和活动',
                        '可选择将露营日志设为私密或公开',
                        '提供匿名浏览模式',
                        '不向第三方出售个人数据',
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    _buildSecurityFeatureCard(
                      icon: Icons.shield,
                      iconColor: const Color(0xFF9C27B0),
                      iconBg: const Color(0xFFF3E5F5),
                      title: '账户安全',
                      description: '全面的账户保护功能，确保您的个人资料安全。',
                      features: [
                        '新设备登录警报',
                        '活动日志监控账户访问',
                        '可从所有设备远程登出',
                        '账户恢复选项（邮箱/手机）',
                        '可疑活动检测和警报',
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    _buildSecurityFeatureCard(
                      icon: Icons.verified_user,
                      iconColor: const Color(0xFFE91E63),
                      iconBg: const Color(0xFFFCE4EC),
                      title: '内容安全',
                      description: '我们通过主动审核和举报维护安全的社区环境。',
                      features: [
                        'AI驱动的内容审核',
                        '用户举报和屏蔽功能',
                        '社区准则执行',
                        '垃圾信息和滥用防范系统',
                        '24/7安全团队监控',
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    _buildSecurityFeatureCard(
                      icon: Icons.cloud_done,
                      iconColor: const Color(0xFF00BCD4),
                      iconBg: const Color(0xFFE0F7FA),
                      title: '数据备份与恢复',
                      description: '您的回忆和数据被安全备份，如有需要可以恢复。',
                      features: [
                        '自动云备份您的内容',
                        '跨多个服务器的冗余存储',
                        '简单的数据导出和下载选项',
                        '账户恢复协助',
                        '灾难恢复协议到位',
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacing16),
                    _buildBestPracticesCard(),
                    const SizedBox(height: AppConstants.spacing16),
                    _buildComplianceCard(),
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
            '应用安全',
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

  Widget _buildSecurityOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF66BB6A),
            const Color(0xFF66BB6A).withValues(alpha: 0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF66BB6A).withValues(alpha: 0.3),
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
            child: const Icon(Icons.security, size: 40, color: Colors.white),
          ),
          const SizedBox(height: AppConstants.spacing20),
          const Text(
            '您的安全至关重要',
            style: TextStyle(
              fontSize: AppConstants.fontSizeHeading2,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppConstants.spacing12),
          Text(
            '在 约傍，我们实施多层安全措施来保护您的数据和隐私。了解我们下面的全面安全措施。',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: Colors.white.withValues(alpha: 0.95),
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppConstants.spacing24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSecurityStat('256位', '加密'),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              _buildSecurityStat('24/7', '监控'),
              Container(
                width: 1,
                height: 40,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              _buildSecurityStat('100%', '安全'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSecurityStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: AppConstants.fontSizeHeading2,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: AppConstants.fontSizeSmall,
            color: Colors.white.withValues(alpha: 0.9),
          ),
        ),
      ],
    );
  }

  Widget _buildSecurityFeatureCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String description,
    required List<String> features,
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
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                child: Icon(icon, size: 28, color: iconColor),
              ),
              const SizedBox(width: AppConstants.spacing16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: AppConstants.fontSizeHeading3,
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing16),
          Text(
            description,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppConstants.spacing16),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Icon(Icons.check_circle, size: 18, color: iconColor),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: TextStyle(
                        fontSize: AppConstants.fontSizeMedium,
                        color: Colors.grey[700],
                        height: 1.5,
                      ),
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

  Widget _buildBestPracticesCard() {
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
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                child: const Icon(
                  Icons.lightbulb,
                  color: Color(0xFFFF9800),
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.spacing12),
              const Text(
                '安全最佳实践',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeHeading3,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing20),
          _buildBestPracticeItem('1', '使用强密码', '创建至少8个字符的唯一密码，包括大写、小写、数字和符号。'),
          _buildBestPracticeItem('2', '启用双因素认证', '通过在密码之外要求验证码来添加额外的安全层。'),
          _buildBestPracticeItem('3', '保持应用更新', '始终安装最新版本以获得安全补丁和改进。'),
          _buildBestPracticeItem('4', '谨慎对待链接', '切勿点击可疑链接或与任何人分享您的登录凭据。'),
          _buildBestPracticeItem('5', '检查隐私设置', '定期检查和更新您的隐私设置，以控制谁可以看到您的信息。'),
          _buildBestPracticeItem('6', '在共享设备上登出', '使用公共或共享设备时始终登出，以防止未经授权的访问。'),
        ],
      ),
    );
  }

  Widget _buildBestPracticeItem(
    String number,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacing16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800).withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: AppConstants.fontSizeMedium,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF9800),
                ),
              ),
            ),
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
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: AppConstants.fontSizeSmall,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing24),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(
          color: const Color(0xFF4A90E2).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified, color: Color(0xFF4A90E2), size: 28),
              const SizedBox(width: AppConstants.spacing12),
              const Text(
                '合规性与认证',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeHeading3,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing16),
          Text(
            '约傍 符合国际安全和隐私标准：',
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppConstants.spacing12),
          _buildComplianceItem('GDPR 合规', '欧洲数据保护法规'),
          _buildComplianceItem('CCPA 合规', '加州消费者隐私法'),
          _buildComplianceItem('ISO 27001', '信息安全管理'),
          _buildComplianceItem('SOC 2 Type II', '安全和可用性控制'),
        ],
      ),
    );
  }

  Widget _buildComplianceItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(Icons.check_circle, size: 16, color: Color(0xFF4A90E2)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: AppConstants.fontSizeSmall,
                  color: Colors.grey[800],
                  height: 1.5,
                ),
                children: [
                  TextSpan(
                    text: '$title: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: description),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
