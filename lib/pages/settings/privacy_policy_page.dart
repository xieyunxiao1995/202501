import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/dual_glow_background.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '隐私协议',
          style: TextStyle(color: AppColors.ink),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.ink),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: DualGlowBackground(
        child: Center(
          child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Transform.rotate(
              angle: 0.01,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.cardFace,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '心屿 MindFlow 隐私政策',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '更新日期：2024年1月',
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.inkLight,
                        ),
                      ),
                      const SizedBox(height: 32),
                      
                      _buildSection(
                        '1. 信息收集',
                        '心屿是一款完全本地化的应用，我们不会收集、上传或存储您的任何个人信息和日记内容。所有数据均保存在您的设备本地存储中。',
                      ),
                      
                      _buildSection(
                        '2. 数据存储',
                        '您创建的所有日记、照片、标签等内容都存储在您的设备本地。我们无法访问这些数据，也不会将其传输到任何服务器。',
                      ),
                      
                      _buildSection(
                        '3. 第三方服务',
                        '本应用可能使用第三方AI服务（如DeepSeek）来提供智能陪伴功能。使用这些功能时，相关对话内容会被发送到第三方服务器进行处理。您可以选择不使用这些功能。',
                      ),
                      
                      _buildSection(
                        '4. 权限使用',
                        '本应用可能需要以下权限：\n• 存储权限：用于保存和读取您的日记数据\n• 相机权限：用于拍摄照片添加到日记\n• 相册权限：用于选择照片添加到日记\n\n所有权限仅用于应用核心功能，不会用于其他目的。',
                      ),
                      
                      _buildSection(
                        '5. 数据安全',
                        '虽然数据存储在本地，但我们建议您：\n• 定期备份重要数据\n• 设置设备锁屏密码\n• 不要在公共设备上使用本应用',
                      ),
                      
                      _buildSection(
                        '6. 儿童隐私',
                        '本应用适合所有年龄段用户使用。我们不会主动收集儿童的个人信息。',
                      ),
                      
                      _buildSection(
                        '7. 政策变更',
                        '我们可能会不时更新本隐私政策。重大变更会在应用内通知您。',
                      ),
                      
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          '您的隐私对我们至关重要',
                          style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: AppColors.inkLight,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 15,
              height: 1.6,
              color: AppColors.ink.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}
