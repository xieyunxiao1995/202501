import 'package:flutter/material.dart';
import '../../DaZitheme/app_colors.dart';
import '../../DaZitheme/app_text_styles.dart';

class OnboardingStep3 extends StatelessWidget {
  const OnboardingStep3({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // AI illustration
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              gradient: AppColors.goldGradient,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(60),
                topRight: Radius.circular(50),
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(70),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentGold.withAlpha(77),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome,
              size: 80,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            '认识金绪，您的AI向导',
            style: AppTextStyles.headline2,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            '金绪是一位金缮大师，随时准备用智慧、技术建议和哲学洞见来指导您的修复之旅。',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: AppColors.accentGold.withAlpha(77),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: AppColors.goldGradient,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person, color: Colors.white),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '金绪',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.accentGold,
                          ),
                        ),
                        Text('金缮大师向导', style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  '"欢迎，匠人。每一道裂痕都是一个等待用金线讲述的故事。我该如何指引您的修复之旅？"',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _buildFeatureRow(icon: Icons.help_outline, text: '询问技术和材料问题'),
          const SizedBox(height: 12),
          _buildFeatureRow(icon: Icons.auto_stories, text: '生成诗意的裂痕叙事'),
          const SizedBox(height: 12),
          _buildFeatureRow(icon: Icons.psychology, text: '探索侘寂哲学'),
        ],
      ),
    );
  }

  Widget _buildFeatureRow({required IconData icon, required String text}) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
      ],
    );
  }
}
