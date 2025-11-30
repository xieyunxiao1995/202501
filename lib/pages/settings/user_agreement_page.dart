import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';
import '../../widgets/dual_glow_background.dart';

class UserAgreementPage extends StatelessWidget {
  const UserAgreementPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '用户协议',
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
                        '心屿 MindFlow 用户协议',
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
                        '1. 服务说明',
                        '心屿（MindFlow）是一款个人日记记录应用，旨在帮助用户记录生活点滴，管理个人记忆。本应用所有数据均存储在您的本地设备中。',
                      ),
                      
                      _buildSection(
                        '2. 用户责任',
                        '您应对使用本应用创建的所有内容负责。请勿使用本应用记录、存储或传播任何违法、有害、威胁、辱骂、骚扰、侵权、诽谤或其他令人反感的内容。',
                      ),
                      
                      _buildSection(
                        '3. 数据安全',
                        '您的所有日记数据均存储在本地设备中，我们不会上传或收集您的个人日记内容。请您自行做好数据备份，以防数据丢失。',
                      ),
                      
                      _buildSection(
                        '4. 知识产权',
                        '本应用的所有设计、代码、图标等知识产权归开发者所有。您在使用本应用时创建的内容归您所有。',
                      ),
                      
                      _buildSection(
                        '5. 免责声明',
                        '本应用按"现状"提供，不提供任何明示或暗示的保证。我们不对因使用本应用而导致的任何直接或间接损失承担责任。',
                      ),
                      
                      _buildSection(
                        '6. 协议变更',
                        '我们保留随时修改本协议的权利。修改后的协议将在应用内公布，继续使用本应用即表示您接受修改后的协议。',
                      ),
                      
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          '感谢您使用心屿 MindFlow',
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
