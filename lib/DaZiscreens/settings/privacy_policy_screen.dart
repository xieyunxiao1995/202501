import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../config/app_config.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('隐私政策', style: AppTextStyles.headline3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              '1. 数据收集',
              'CP嗒啧 将所有数据存储在您的设备本地。我们不在外部服务器上收集、传输或存储任何个人信息。',
            ),
            const SizedBox(height: 20),
            _buildSection(
              '2. AI 服务使用',
              '本应用使用 DeepSeek AI 技术提供金绪 AI 助手功能。当您使用此功能时：',
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primary.withAlpha(51)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBulletPoint('您发送给 AI 的文字消息会传输到 DeepSeek 服务器'),
                  _buildBulletPoint('DeepSeek 处理您的消息以生成回复'),
                  _buildBulletPoint('消息按照 DeepSeek 隐私政策进行处理'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSection('3. 本地数据', '您的照片和修复项目数据保留在您的设备上：'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.success.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.success.withAlpha(77)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBulletPoint('照片存储在本地，从不上传到外部服务器'),
                  _buildBulletPoint('我们不会使用 AI 分析或处理您的图片'),
                  _buildBulletPoint('您的修复项目数据保留在设备上'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSection('4. 无账户系统', 'CP嗒啧 不需要或使用任何账户系统。我们不收集姓名、邮箱地址或任何身份信息。'),
            const SizedBox(height: 20),
            _buildSection(
              '5. 第三方服务',
              '唯一使用的第三方服务是用于聊天助手功能的 DeepSeek AI。您可以在以下地址查看他们的隐私政策：',
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Would open URL in production
              },
              child: Text(
                AppConfig.deepSeekPrivacyPolicyUrl,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.primary,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 20),
            _buildSection('6. 数据保留', '所有数据都存储在您的设备本地，直到您删除应用。卸载应用会移除所有存储的数据。'),
            const SizedBox(height: 20),
            _buildSection('7. 用户权利', '您对您的数据拥有完全控制权：'),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBulletPoint('不使用 AI 聊天功能也可以使用应用'),
                  _buildBulletPoint('随时清除您的聊天记录'),
                  _buildBulletPoint('删除应用以移除所有本地数据'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSection('8. 儿童隐私', '本应用不面向 13 岁以下儿童。我们不会在知情的情况下收集任何儿童信息。'),
            const SizedBox(height: 20),
            _buildSection('9. 安全性', '由于所有数据都存储在您的设备本地，数据的安全性取决于您设备的安全措施。'),
            const SizedBox(height: 20),
            _buildSection('10. 政策变更', '我们可能会不时更新本隐私政策。继续使用应用即表示接受任何变更。'),
            const SizedBox(height: 20),
            _buildSection('11. 联系我们', '如有关于本隐私政策的问题，请通过设置中的反馈部分联系我们。'),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTextStyles.labelLarge),
        const SizedBox(height: 8),
        Text(
          content,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('\u2022 ', style: AppTextStyles.bodyMedium),
          Expanded(child: Text(text, style: AppTextStyles.bodySmall)),
        ],
      ),
    );
  }
}
