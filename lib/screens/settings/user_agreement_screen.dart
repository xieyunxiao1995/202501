import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

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
                      _buildHeaderCard(),
                      const SizedBox(height: AppConstants.spacing20),
                      _buildQuickSummaryCard(),
                      const SizedBox(height: AppConstants.spacing20),
                      _buildSection(
                        icon: Icons.handshake,
                        iconColor: const Color(0xFF4A90E2),
                        iconBg: const Color(0xFFE3F2FD),
                        title: '1. 接受条款',
                        content:
                            '通过访问和使用 实遇记（"本应用"），您接受并同意受本协议条款和规定的约束。如果您不同意这些条款，请不要使用本应用。\n\n本协议自您首次使用本应用之日起生效，并将持续有效，直至任何一方终止。',
                      ),
                      const SizedBox(height: AppConstants.spacing16),
                      _buildSection(
                        icon: Icons.account_circle,
                        iconColor: const Color(0xFF66BB6A),
                        iconBg: const Color(0xFFE8F5E9),
                        title: '2. 用户账户',
                        content:
                            '要访问本应用的某些功能，您必须创建一个账户。您负责：\n\n• 保持账户凭据的机密性\n• 在您账户下发生的所有活动\n• 立即通知我们任何未经授权的使用\n• 确保您的账户信息准确且最新\n\n您必须年满13岁才能创建账户。18岁以下的用户需要获得父母同意。',
                      ),
                      const SizedBox(height: AppConstants.spacing16),
                      _buildSection(
                        icon: Icons.content_paste,
                        iconColor: const Color(0xFFFF9800),
                        iconBg: const Color(0xFFFFF3E0),
                        title: '3. 用户内容',
                        content:
                            '您保留在 实遇记 上发布的所有内容的所有权利，包括照片、视频、露营日志和评论。通过发布内容，您授予我们：\n\n• 全球范围内非独家许可，以使用、展示和分发您的内容\n• 出于技术目的修改内容的权利（例如格式化）\n• 在宣传材料中展示您内容的许可\n\n您声明您拥有或有权使用您发布的所有内容。',
                      ),
                      const SizedBox(height: AppConstants.spacing16),
                      _buildSection(
                        icon: Icons.block,
                        iconColor: const Color(0xFF9C27B0),
                        iconBg: const Color(0xFFF3E5F5),
                        title: '4. 禁止活动',
                        content:
                            '您同意不：\n\n• 发布非法、有害或冒犯性内容\n• 骚扰、欺凌或威胁其他用户\n• 冒充他人或歪曲您的身份\n• 发送垃圾邮件或未经请求的消息\n• 试图破解或危害应用的安全性\n• 使用自动化工具访问应用\n• 侵犯知识产权\n• 未经许可从事商业活动\n\n违规可能导致账户暂停或终止。',
                      ),
                      const SizedBox(height: AppConstants.spacing16),
                      _buildSection(
                        icon: Icons.privacy_tip,
                        iconColor: const Color(0xFFE91E63),
                        iconBg: const Color(0xFFFCE4EC),
                        title: '5. 隐私与数据',
                        content:
                            '您的隐私对我们很重要。我们的隐私政策解释：\n\n• 我们收集哪些数据以及为什么\n• 我们如何使用和保护您的信息\n• 您对数据的权利\n• Cookie 使用和跟踪\n• 第三方集成\n\n使用本应用即表示您同意我们隐私政策中描述的数据实践。',
                      ),
                      const SizedBox(height: AppConstants.spacing16),
                      _buildSection(
                        icon: Icons.copyright,
                        iconColor: const Color(0xFF00BCD4),
                        iconBg: const Color(0xFFE0F7FA),
                        title: '6. 知识产权',
                        content:
                            '本应用的所有内容、功能和功能均由 实遇记 Technologies Inc. 拥有，并受以下保护：\n\n• 版权法\n• 商标法\n• 专利法\n• 商业秘密法\n\n未经书面许可，您不得复制、修改、分发或逆向工程本应用的任何部分。',
                      ),
                      const SizedBox(height: AppConstants.spacing16),
                      _buildSection(
                        icon: Icons.gavel,
                        iconColor: const Color(0xFFF44336),
                        iconBg: const Color(0xFFFFEBEE),
                        title: '7. 免责声明与限制',
                        content:
                            '本应用按"原样"提供，不提供任何形式的保证。我们不保证：\n\n• 不间断或无错误的服务\n• 用户生成内容的准确性\n• 特定功能的可用性\n• 与所有设备的兼容性\n\n我们不对以下情况负责：\n• 间接或后果性损害\n• 数据或利润损失\n• 第三方行为或内容\n• 基于应用信息进行的户外活动',
                      ),
                      const SizedBox(height: AppConstants.spacing16),
                      _buildSection(
                        icon: Icons.update,
                        iconColor: const Color(0xFF795548),
                        iconBg: const Color(0xFFEFEBE9),
                        title: '8. 条款变更',
                        content:
                            '我们保留随时修改这些条款的权利。变更将生效：\n\n• 对于小的变更，发布后立即生效\n• 对于重大变更，提前30天通知后生效\n\n变更后继续使用本应用即表示接受新条款。我们将通过电子邮件或应用内通知告知您重大变更。',
                      ),
                      const SizedBox(height: AppConstants.spacing16),
                      _buildSection(
                        icon: Icons.cancel,
                        iconColor: const Color(0xFF607D8B),
                        iconBg: const Color(0xFFECEFF1),
                        title: '9. 终止',
                        content:
                            '任何一方都可以终止本协议：\n\n• 您可以随时删除您的账户\n• 我们可能因违规而暂停或终止账户\n• 我们可能提前30天通知后停止本应用\n\n终止后：\n• 您使用本应用的权利立即终止\n• 我们可能删除您的账户和内容\n• 某些条款在终止后继续有效（例如免责声明）',
                      ),
                      const SizedBox(height: AppConstants.spacing16),
                      _buildSection(
                        icon: Icons.language,
                        iconColor: const Color(0xFF3F51B5),
                        iconBg: const Color(0xFFE8EAF6),
                        title: '10. 适用法律',
                        content:
                            '这些条款受美国加利福尼亚州法律管辖，不考虑法律冲突原则。\n\n任何争议将通过以下方式解决：\n• 善意协商\n• 如果协商失败，则进行有约束力的仲裁\n• 对于不可仲裁的事项，由加利福尼亚州旧金山的法院处理',
                      ),
                      const SizedBox(height: AppConstants.spacing20),
                      _buildContactCard(),
                      const SizedBox(height: AppConstants.spacing20),
                      _buildAcceptanceCard(),
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
            '用户协议',
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

  Widget _buildHeaderCard() {
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
          const Icon(Icons.description, size: 56, color: Colors.white),
          const SizedBox(height: AppConstants.spacing16),
          const Text(
            '服务条款',
            style: TextStyle(
              fontSize: AppConstants.fontSizeHeading1,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppConstants.spacing8),
          Text(
            '最后更新：2025年11月26日',
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: AppConstants.spacing16),
          Text(
            '在使用 实遇记 之前，请仔细阅读这些条款。使用我们的应用即表示您同意这些条款和条件。',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: Colors.white.withValues(alpha: 0.95),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(
          color: const Color(0xFFFF9800).withValues(alpha: 0.3),
          width: 2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.info_outline,
                color: Color(0xFFFF9800),
                size: 28,
              ),
              const SizedBox(width: AppConstants.spacing12),
              const Text(
                '快速摘要',
                style: TextStyle(
                  fontSize: AppConstants.fontSizeHeading3,
                  fontWeight: FontWeight.bold,
                  color: AppConstants.primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacing16),
          _buildSummaryItem('您拥有您的内容，但授予我们使用许可'),
          _buildSummaryItem('尊重他人并遵守社区准则'),
          _buildSummaryItem('我们保护您的隐私和数据'),
          _buildSummaryItem('服务按"原样"提供，不提供保证'),
          _buildSummaryItem('我们可以在通知后更新这些条款'),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 4),
            child: Icon(Icons.check_circle, size: 18, color: Color(0xFFFF9800)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: Colors.grey[800],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String content,
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
                padding: const EdgeInsets.all(AppConstants.spacing12),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                child: Icon(icon, size: 24, color: iconColor),
              ),
              const SizedBox(width: AppConstants.spacing12),
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
            content,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: Colors.grey[700],
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard() {
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
                  color: const Color(0xFFE0F7FA),
                  borderRadius: BorderRadius.circular(
                    AppConstants.radiusMedium,
                  ),
                ),
                child: const Icon(
                  Icons.contact_support,
                  color: Color(0xFF00BCD4),
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.spacing12),
              const Text(
                '有疑问？',
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
            '如果您对这些服务条款有任何疑问，请联系我们：',
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: Colors.grey[700],
              height: 1.6,
            ),
          ),
          const SizedBox(height: AppConstants.spacing12),
          _buildContactItem(Icons.email, 'legal@celva.app'),
          _buildContactItem(Icons.language, 'www.celva.app/terms'),
          _buildContactItem(Icons.location_on, '美国加利福尼亚州旧金山'),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppConstants.accentColor),
          const SizedBox(width: 12),
          Text(
            text,
            style: TextStyle(
              fontSize: AppConstants.fontSizeMedium,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptanceCard() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacing20),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
        border: Border.all(
          color: const Color(0xFF66BB6A).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Color(0xFF66BB6A), size: 28),
          const SizedBox(width: AppConstants.spacing16),
          Expanded(
            child: Text(
              'By using 实遇记, you acknowledge that you have read, understood, and agree to be bound by these Terms of Service.',
              style: TextStyle(
                fontSize: AppConstants.fontSizeMedium,
                color: Colors.grey[800],
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
