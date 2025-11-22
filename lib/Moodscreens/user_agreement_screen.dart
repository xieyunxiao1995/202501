import 'package:flutter/material.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

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
                            '用户协议',
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
                      '更新日期：2024年11月17日',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildSection(
                    '欢迎使用 Moodora',
                    '感谢您选择 Moodora！在使用我们的服务之前，请仔细阅读本用户协议。'
                        '使用 Moodora 即表示您同意遵守本协议的所有条款和条件。',
                  ),
                  _buildSection(
                    '1. 服务说明',
                    'Moodora 是一款情绪管理和日记记录应用，提供以下服务：\n\n'
                        '• 情绪日记记录和管理\n'
                        '• AI 智能情绪分析和陪伴\n'
                        '• 情绪广场社区交流\n'
                        '• 个人情绪数据统计和分析\n\n'
                        '我们保留随时修改、暂停或终止部分或全部服务的权利。',
                  ),
                  _buildSection(
                    '2. 用户账户',
                    '• 您需要注册账户才能使用完整功能\n'
                        '• 您有责任保护账户安全，不得与他人共享\n'
                        '• 您对账户下的所有活动负责\n'
                        '• 如发现账户被盗用，请立即通知我们\n'
                        '• 一个手机号码只能注册一个账户',
                  ),
                  _buildSection(
                    '3. 用户行为规范',
                    '使用 Moodora 时，您不得：\n\n'
                        '• 发布违法、暴力、色情或其他不当内容\n'
                        '• 侵犯他人隐私、知识产权或其他合法权益\n'
                        '• 传播虚假信息或进行欺诈行为\n'
                        '• 干扰或破坏服务的正常运行\n'
                        '• 使用自动化工具或机器人访问服务\n'
                        '• 进行商业推广或垃圾信息发送',
                  ),
                  _buildSection(
                    '4. 内容所有权',
                    '• 您保留对自己创建内容的所有权\n'
                        '• 您授予 Moodora 使用、存储和展示您内容的权利\n'
                        '• 公开分享的内容可能被其他用户查看\n'
                        '• 我们有权删除违反协议的内容\n'
                        '• 您对发布的内容承担全部责任',
                  ),
                  _buildSection(
                    '5. 隐私保护',
                    '我们重视您的隐私保护。关于我们如何收集、使用和保护您的个人信息，'
                        '请参阅《隐私政策》。使用我们的服务即表示您同意我们的隐私政策。',
                  ),
                  _buildSection(
                    '6. 知识产权',
                    'Moodora 的所有内容、功能和技术均受知识产权法保护。未经授权，'
                        '您不得复制、修改、分发或以其他方式使用我们的知识产权。',
                  ),
                  _buildSection(
                    '7. 免责声明',
                    '• Moodora 提供的 AI 建议仅供参考，不构成专业医疗建议\n'
                        '• 如有严重心理健康问题，请咨询专业医生\n'
                        '• 我们不对用户发布的内容负责\n'
                        '• 服务可能因维护、升级等原因暂时中断\n'
                        '• 我们不保证服务完全无错误或不中断',
                  ),
                  _buildSection(
                    '8. 协议变更',
                    '我们可能会不时更新本协议。重大变更时，我们会通过应用内通知或其他方式告知您。'
                        '继续使用服务即表示您接受更新后的协议。',
                  ),
                  _buildSection(
                    '9. 账户终止',
                    '• 您可以随时删除账户\n'
                        '• 如违反本协议，我们有权暂停或终止您的账户\n'
                        '• 账户终止后，您的数据将按照隐私政策处理',
                  ),
                  _buildSection(
                    '10. 联系我们',
                    '如对本协议有任何疑问，请通过以下方式联系我们：\n\n'
                        '邮箱：legal@moodora.com\n'
                        '客服热线：400-123-4567',
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
