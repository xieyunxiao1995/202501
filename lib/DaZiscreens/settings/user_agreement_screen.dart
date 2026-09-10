import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';

class UserAgreementScreen extends StatelessWidget {
  const UserAgreementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text('用户协议', style: AppTextStyles.headline3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              '1. 简介',
              '欢迎使用 CP嗒啧，一款金缮匠人伴侣应用。使用本应用即表示您同意受本最终用户许可协议的约束。',
            ),
            const SizedBox(height: 20),
            _buildSection(
              '2. AI 服务说明',
              '本应用使用 DeepSeek 提供的人工智能（AI）服务来驱动金绪 AI 助手功能。',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.accentGold.withAlpha(26),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.accentGold.withAlpha(77)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '与 AI 服务共享的数据：',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.accentGold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBulletPoint('您在 AI 聊天界面的文字消息'),
                  _buildBulletPoint('您修复项目的文字描述'),
                  _buildBulletPoint('关于金缮技术的问题'),
                ],
              ),
            ),
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
                  Text(
                    '不与 AI 服务共享的数据：',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildBulletPoint('您的照片（仅存储在设备上）'),
                  _buildBulletPoint('您的身份信息（无账户系统）'),
                  _buildBulletPoint('您的设备标识符或位置信息'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSection('3. 条款接受', '使用本应用即表示您确认已阅读、理解并同意受本协议的约束。'),
            const SizedBox(height: 20),
            _buildSection(
              '4. 用户责任',
              '将应用用于其预期目的：金缮艺术指导。不要试图提取或逆向工程 AI 回复。不要将 AI 用于医疗、法律或财务建议。',
            ),
            const SizedBox(height: 20),
            _buildSection('5. 知识产权', '您的修复项目和照片仍然是您的财产。AI 生成的回复仅供您个人使用。'),
            const SizedBox(height: 20),
            _buildSection('6. 责任限制', '本应用按"原样"提供艺术指导。我们对修复尝试期间陶瓷物品的损坏不承担责任。'),
            const SizedBox(height: 20),
            _buildSection('7. 条款变更', '我们可能会不时更新本协议。继续使用应用即表示接受任何变更。'),
            const SizedBox(height: 20),
            _buildSection('8. 联系我们', '如有关于本协议的问题，请通过设置中的反馈部分联系我们。'),
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
