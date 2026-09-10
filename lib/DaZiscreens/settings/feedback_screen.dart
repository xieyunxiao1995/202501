import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_decorations.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _feedbackController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isSubmitting = false;
  bool _isSubmitted = false;

  Future<void> _submitFeedback() async {
    if (_feedbackController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('请输入您的反馈'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate submission delay
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isSubmitting = false;
        _isSubmitted = true;
      });
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 375;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          '反馈与建议',
          style: AppTextStyles.headline3.copyWith(
            fontSize: isSmallScreen ? 16 : 18,
          ),
        ),
      ),
      body: _isSubmitted
          ? _buildThankYouView(isSmallScreen)
          : _buildFeedbackForm(isSmallScreen),
    );
  }

  Widget _buildFeedbackForm(bool isSmallScreen) {
    final horizontalPadding = isSmallScreen ? 16.0 : 20.0;
    final sectionSpacing = isSmallScreen ? 24.0 : 32.0;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(horizontalPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '我们重视您的意见',
              style: AppTextStyles.headline3.copyWith(
                fontSize: isSmallScreen ? 20 : 22,
              ),
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            Text(
              '分享您的想法、建议或报告问题。我们会认真阅读每一条反馈。',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: isSmallScreen ? 13 : 14,
              ),
            ),
            SizedBox(height: sectionSpacing),

            // Feedback type chips
            Text(
              '反馈主题',
              style: AppTextStyles.labelLarge.copyWith(
                fontSize: isSmallScreen ? 15 : 16,
              ),
            ),
            SizedBox(height: isSmallScreen ? 10 : 12),
            Wrap(
              spacing: isSmallScreen ? 6 : 8,
              runSpacing: isSmallScreen ? 6 : 8,
              children: [
                _buildTopicChip('一般反馈', isSmallScreen),
                _buildTopicChip('问题报告', isSmallScreen),
                _buildTopicChip('功能建议', isSmallScreen),
                _buildTopicChip('AI助手', isSmallScreen),
              ],
            ),
            SizedBox(height: isSmallScreen ? 20 : 24),

            // Feedback text
            Text(
              '您的留言',
              style: AppTextStyles.labelLarge.copyWith(
                fontSize: isSmallScreen ? 15 : 16,
              ),
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            TextFormField(
              controller: _feedbackController,
              maxLines: isSmallScreen ? 4 : 5,
              decoration: AppDecorations.inputDecoration(
                hintText: '描述您的反馈、建议或遇到的问题...',
              ),
              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            ),
            SizedBox(height: isSmallScreen ? 16 : 20),

            // Email (optional)
            Text(
              '邮箱（可选）',
              style: AppTextStyles.labelLarge.copyWith(
                fontSize: isSmallScreen ? 15 : 16,
              ),
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: AppDecorations.inputDecoration(hintText: '用于后续跟进回复'),
              style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
            ),
            SizedBox(height: sectionSpacing),

            // Submit button
            GestureDetector(
              onTap: _isSubmitting ? null : _submitFeedback,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  vertical: isSmallScreen ? 14 : 16,
                ),
                decoration: AppDecorations.primaryButton(
                  isDisabled: _isSubmitting,
                ),
                child: Center(
                  child: _isSubmitting
                      ? SizedBox(
                          width: isSmallScreen ? 18 : 20,
                          height: isSmallScreen ? 18 : 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          '发送反馈',
                          style: AppTextStyles.button.copyWith(
                            fontSize: isSmallScreen ? 15 : 16,
                          ),
                        ),
                ),
              ),
            ),

            SizedBox(height: isSmallScreen ? 16 : 20),
            Center(
              child: Text(
                '您的反馈帮助我们改进 CP嗒啧',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: isSmallScreen ? 11 : 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopicChip(String label, bool isSmallScreen) {
    return GestureDetector(
      onTap: () {
        // Would set selected topic in production
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 14 : 16,
          vertical: isSmallScreen ? 8 : 10,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 20),
          border: Border.all(color: AppColors.surfaceLight),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: isSmallScreen ? 11 : 12,
          ),
        ),
      ),
    );
  }

  Widget _buildThankYouView(bool isSmallScreen) {
    final iconSize = isSmallScreen ? 88.0 : 100.0;
    final iconInnerSize = isSmallScreen ? 44.0 : 50.0;
    final padding = isSmallScreen ? 32.0 : 40.0;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: iconSize,
              height: iconSize,
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
                Icons.check,
                color: Colors.white,
                size: iconInnerSize,
              ),
            ),
            SizedBox(height: isSmallScreen ? 20 : 24),
            Text(
              '感谢您的反馈！',
              style: AppTextStyles.headline2.copyWith(
                fontSize: isSmallScreen ? 20 : 22,
              ),
            ),
            SizedBox(height: isSmallScreen ? 10 : 12),
            Text(
              '我们已收到您的反馈。感谢您花时间帮助我们改进 CP嗒啧。',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: isSmallScreen ? 13 : 14,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isSmallScreen ? 24 : 32),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isSubmitted = false;
                  _feedbackController.clear();
                  _emailController.clear();
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 28 : 32,
                  vertical: isSmallScreen ? 12 : 14,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(isSmallScreen ? 10 : 12),
                  border: Border.all(color: AppColors.primary.withAlpha(77)),
                ),
                child: Text(
                  '再发一条',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: AppColors.primary,
                    fontSize: isSmallScreen ? 15 : 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
