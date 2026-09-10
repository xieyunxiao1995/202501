import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_text_styles.dart';
import '../../theme/app_decorations.dart';
import '../../services/storage_service.dart';
import '../../config/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EulaScreen extends StatefulWidget {
  const EulaScreen({super.key});

  @override
  State<EulaScreen> createState() => _EulaScreenState();
}

class _EulaScreenState extends State<EulaScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _hasScrolledToBottom = false;
  bool _hasAgreed = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_checkScrollPosition);
  }

  void _checkScrollPosition() {
    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 50 &&
        !_hasScrolledToBottom) {
      setState(() {
        _hasScrolledToBottom = true;
      });
    }
  }

  Future<void> _acceptEula() async {
    final prefs = await SharedPreferences.getInstance();
    final storageService = StorageService(prefs);
    await storageService.setEulaAccepted(true);
    await storageService.setOnboardingCompleted(true);
    await storageService.setFirstLaunch(false);

    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.main);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('用户协议', style: AppTextStyles.headline3),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('最终用户许可协议', style: AppTextStyles.headline3),
                    const SizedBox(height: 16),
                    _buildSection(
                      '1. 简介',
                      '欢迎使用 CP嗒啧，一款金缮匠人伴侣应用。使用本应用即表示您同意受本最终用户许可协议的约束。',
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      '2. AI 服务说明',
                      '本应用使用 DeepSeek 提供的人工智能（AI）服务来支持金绪 AI 助手功能。',
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.accentGold.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.accentGold.withAlpha(77),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.cloud_upload_outlined,
                                color: AppColors.accentGold,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '与 AI 服务共享的数据：',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.accentGold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildBulletPoint('您在 AI 聊天界面中发送的文字消息'),
                          _buildBulletPoint('您修复项目的文字描述'),
                          _buildBulletPoint('您提出的关于金缮技术的问题'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.success.withAlpha(26),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.success.withAlpha(77),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.lock_outline,
                                color: AppColors.success,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '不与 AI 服务共享的数据：',
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: AppColors.success,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          _buildBulletPoint('您的照片（仅存储在您的设备上）'),
                          _buildBulletPoint('您的身份信息（本应用不使用账户系统）'),
                          _buildBulletPoint('您的设备标识符或位置信息'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      '3. 条款接受',
                      '点击"接受并继续"，即表示您确认已阅读、理解并同意受本协议约束。',
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      '4. 用户责任',
                      '请将本应用用于其预期目的：金缮艺术指导。请勿尝试提取或逆向工程 AI 响应。请勿将 AI 用于医疗、法律或财务建议。',
                    ),
                    const SizedBox(height: 16),
                    _buildSection('5. 知识产权', '您的修复项目和照片仍归您所有。AI 生成的响应仅供您个人使用。'),
                    const SizedBox(height: 16),
                    _buildSection(
                      '6. 责任限制',
                      '本应用按"原样"提供艺术指导。我们不对修复尝试过程中对陶瓷作品造成的任何损坏负责。',
                    ),
                    const SizedBox(height: 16),
                    _buildSection(
                      '7. 联系我们',
                      '如有关于本协议或所用 AI 服务的问题，请通过设置中的反馈部分联系我们。',
                    ),
                    const SizedBox(height: 24),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.background,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryDark.withAlpha(13),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Checkbox (only visible after scrolling)
                  if (_hasScrolledToBottom)
                    Row(
                      children: [
                        Checkbox(
                          value: _hasAgreed,
                          activeColor: AppColors.accentGold,
                          onChanged: (value) {
                            setState(() {
                              _hasAgreed = value ?? false;
                            });
                          },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _hasAgreed = !_hasAgreed;
                              });
                            },
                            child: Text(
                              '我理解并同意上述条款，包括 AI 服务说明。',
                              style: AppTextStyles.bodySmall,
                            ),
                          ),
                        ),
                      ],
                    ),
                  if (!_hasScrolledToBottom)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: Text(
                        '请滚动阅读完整协议',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: _hasAgreed ? _acceptEula : null,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: AppDecorations.primaryButton(
                        isDisabled: !_hasAgreed,
                      ),
                      child: Center(
                        child: Text(
                          '接受并继续',
                          style: AppTextStyles.button.copyWith(
                            color: _hasAgreed
                                ? Colors.white
                                : AppColors.textLight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
      padding: const EdgeInsets.only(left: 8, bottom: 4),
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
