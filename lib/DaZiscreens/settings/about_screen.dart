import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../config/app_config.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;
    final horizontalPadding = isSmallScreen ? 16.0 : 20.0;
    final sectionSpacing = isSmallScreen ? 32.0 : 40.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          '关于 CP嗒啧',
          style: AppTextStyles.headline3.copyWith(
            fontSize: isSmallScreen ? 16 : 18,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo and name
            Center(
              child: Column(
                children: [
                  Container(
                    width: isSmallScreen ? 88 : 100,
                    height: isSmallScreen ? 88 : 100,
                    decoration: BoxDecoration(
                      gradient: AppColors.goldGradient,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentGold.withAlpha(77),
                          blurRadius: isSmallScreen ? 16 : 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.auto_fix_high,
                      color: Colors.white,
                      size: isSmallScreen ? 44 : 50,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 16 : 20),
                  Text(
                    AppConfig.appName,
                    style: AppTextStyles.headline1.copyWith(
                      fontSize: isSmallScreen ? 24 : 28,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 3 : 4),
                  Text(
                    'Version ${AppConfig.appVersion}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: isSmallScreen ? 13 : 14,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: sectionSpacing),

            // Story section
            _buildSection(
              '我们的故事',
              'CP嗒啧 源于对金缮艺术的深厚热爱，这是一项拥有400年历史的日本传统工艺，用金线修复破碎的陶器。这种哲学认为破损不应被隐藏，而应成为创造更美好事物的契机。',
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 20 : 24),

            _buildSection(
              '名称含义',
              'CP嗒啧 这个名字融合了代表金、陶土、生命、修复和综合的词根——捕捉了将破碎器物转化为金色艺术的精髓。',
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 20 : 24),

            _buildSection(
              '我们的使命',
              '我们相信每一道裂痕都在讲述一个故事。我们的使命是引导匠人完成金缮之旅，将传统智慧与现代便捷相结合。每一次修复都是对无常与美的冥想。',
              isSmallScreen,
            ),
            SizedBox(height: isSmallScreen ? 20 : 24),

            // Values
            Container(
              padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(isSmallScreen ? 14 : 16),
                border: Border.all(color: AppColors.accentGold.withAlpha(51)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '我们的价值观',
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.accentGold,
                      fontSize: isSmallScreen ? 15 : 16,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? 14 : 16),
                  _buildValueItem('侘寂之美', '在不完美中发现美', isSmallScreen),
                  _buildValueItem('匠心工艺', '尊重传统技艺', isSmallScreen),
                  _buildValueItem('可持续发展', '修复而非丢弃', isSmallScreen),
                  _buildValueItem('正念修行', '每次修复都是冥想', isSmallScreen),
                ],
              ),
            ),
            SizedBox(height: isSmallScreen ? 24 : 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content, bool isSmallScreen) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.headline3.copyWith(
            fontSize: isSmallScreen ? 18 : 20,
          ),
        ),
        SizedBox(height: isSmallScreen ? 10 : 12),
        Text(
          content,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.6,
            fontSize: isSmallScreen ? 13 : 14,
          ),
        ),
      ],
    );
  }

  Widget _buildValueItem(String title, String description, bool isSmallScreen) {
    return Padding(
      padding: EdgeInsets.only(bottom: isSmallScreen ? 10 : 12),
      child: Row(
        children: [
          Container(
            width: isSmallScreen ? 7 : 8,
            height: isSmallScreen ? 7 : 8,
            decoration: const BoxDecoration(
              color: AppColors.accentGold,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: isSmallScreen ? 10 : 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.labelLarge.copyWith(
                  fontSize: isSmallScreen ? 15 : 16,
                ),
              ),
              Text(
                description,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: isSmallScreen ? 11 : 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
