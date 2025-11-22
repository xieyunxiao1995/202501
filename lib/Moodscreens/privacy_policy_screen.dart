import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000000),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 80,
            floating: true,
            pinned: false,
            elevation: 0,
            backgroundColor: const Color(0xFF000000),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white70),
              onPressed: () => Navigator.pop(context),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: const Color(0xFF000000),
                padding: const EdgeInsets.fromLTRB(24, 60, 24, 20),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.5),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      const SizedBox(width: 40),
                      Expanded(
                        child: ShaderMask(
                          shaderCallback: (bounds) => const LinearGradient(
                            colors: [Color(0xFF8A7CF5), Color(0xFF6B5BFF)],
                          ).createShader(bounds),
                          child: const Text(
                            '隐私政策',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      '生效日期：2024年11月17日',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    '引言',
                    'Moodora 深知个人信息对您的重要性，我们将按照法律法规要求，'
                        '采取相应的安全保护措施，尽力保护您的个人信息安全可控。'
                        '本隐私政策将帮助您了解我们如何收集、使用、存储和保护您的个人信息。',
                  ),
                  _buildSection(
                    '1. 我们收集的信息',
                    '为了向您提供服务，我们可能收集以下信息：\n\n'
                        '账户信息：\n'
                        '• 手机号码（用于注册和登录）\n'
                        '• 昵称、头像（可选）\n'
                        '• 邮箱地址（可选）\n\n'
                        '日记内容：\n'
                        '• 文字内容\n'
                        '• 图片\n'
                        '• 情绪标签\n'
                        '• 创建时间和地点（可选）\n\n'
                        '使用数据：\n'
                        '• 设备信息（型号、操作系统版本）\n'
                        '• 应用使用情况\n'
                        '• 崩溃日志\n'
                        '• IP 地址',
                  ),
                  _buildSection(
                    '2. 信息使用方式',
                    '我们使用收集的信息用于：\n\n'
                        '• 提供和改进服务功能\n'
                        '• AI 情绪分析和个性化建议\n'
                        '• 账户安全保护\n'
                        '• 发送服务通知和更新\n'
                        '• 统计分析和产品优化\n'
                        '• 遵守法律法规要求\n\n'
                        '我们承诺不会将您的个人信息用于营销推广，除非获得您的明确同意。',
                  ),
                  _buildSection(
                    '3. 信息共享',
                    '我们不会出售您的个人信息。仅在以下情况下共享：\n\n'
                        '• 您主动选择公开分享的内容\n'
                        '• 获得您的明确授权\n'
                        '• 与服务提供商共享（如云存储、AI 服务）\n'
                        '• 法律法规要求或政府部门要求\n'
                        '• 保护用户或公众的安全\n\n'
                        '与第三方共享时，我们会要求其遵守保密义务。',
                  ),
                  _buildSection(
                    '4. 信息存储',
                    '• 您的数据存储在安全的云服务器上\n'
                        '• 我们采用加密技术保护数据传输和存储\n'
                        '• 数据存储在中国境内\n'
                        '• 我们会保留您的信息直到您删除账户\n'
                        '• 删除账户后，我们会在 30 天内删除您的个人数据',
                  ),
                  _buildSection(
                    '5. 您的权利',
                    '您对个人信息享有以下权利：\n\n'
                        '• 访问权：查看我们持有的您的个人信息\n'
                        '• 更正权：更新或修改不准确的信息\n'
                        '• 删除权：要求删除您的个人信息\n'
                        '• 撤回同意：撤回之前给予的授权\n'
                        '• 导出权：导出您的个人数据\n'
                        '• 注销权：注销您的账户\n\n'
                        '您可以在应用内的设置页面行使这些权利。',
                  ),
                  _buildSection(
                    '6. 儿童隐私保护',
                    '我们的服务面向 13 岁以上的用户。如果您是 13 岁以下儿童的监护人，'
                        '发现孩子在未经您同意的情况下向我们提供了个人信息，请联系我们，'
                        '我们会尽快删除相关信息。',
                  ),
                  _buildSection(
                    '7. 第三方服务',
                    '我们的应用可能包含第三方服务的链接或集成：\n\n'
                        '• AI 服务提供商\n'
                        '• 云存储服务\n'
                        '• 数据分析工具\n\n'
                        '这些第三方服务有自己的隐私政策，我们建议您仔细阅读。',
                  ),
                  _buildSection(
                    '8. 数据安全',
                    '我们采取多种安全措施保护您的信息：\n\n'
                        '• 数据传输加密（HTTPS/TLS）\n'
                        '• 数据存储加密\n'
                        '• 访问控制和权限管理\n'
                        '• 定期安全审计\n'
                        '• 员工保密培训\n\n'
                        '尽管我们尽力保护，但没有任何安全措施是绝对安全的。',
                  ),
                  _buildSection(
                    '9. 隐私政策更新',
                    '我们可能会不时更新本隐私政策。重大变更时，我们会通过应用内通知、'
                        '邮件或其他方式告知您。请定期查看本政策以了解最新信息。',
                  ),
                  _buildSection(
                    '10. 联系我们',
                    '如对本隐私政策有任何疑问、意见或投诉，请联系我们：\n\n'
                        '邮箱：privacy@moodora.com\n'
                        '客服热线：400-123-4567\n'
                        '地址：北京市朝阳区xxx路xxx号\n\n'
                        '我们会在 15 个工作日内回复您的请求。',
                  ),
                  const SizedBox(height: 32),
                  Center(
                    child: Text(
                      '© 2024 Moodora. All rights reserved.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF8A7CF5),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
