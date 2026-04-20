import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundLight,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_rounded,
            color: Color(0xFF1A3A34),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          '隐私政策',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1A3A34),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 24),
            _buildSection('一、我们收集的信息', '我们收集您直接提供给我们的信息，包括您的个人资料、心情记录和偏好设置。'),
            const SizedBox(height: 16),
            _buildSection('二、信息的使用方式', '我们使用收集的信息来提供、维护和改进我们的服务，并为您个性化您的体验。'),
            const SizedBox(height: 16),
            _buildSection('三、数据安全', '我们采取适当的技术和组织措施来保护您的个人信息。'),
            const SizedBox(height: 16),
            _buildSection('四、第三方服务', '我们可能会与代表我们提供服务的第三方服务提供商共享您的信息。'),
            const SizedBox(height: 16),
            _buildSection('五、您的权利', '您有权访问、更正或删除您的个人信息。请联系我们以行使这些权利。'),
            const SizedBox(height: 16),
            _buildSection('六、数据保留', '我们会在提供服务及履行法律义务所需的期限内保留您的信息。'),
            const SizedBox(height: 16),
            _buildSection('七、儿童隐私', '我们的服务不适用于13岁以下的儿童。'),
            const SizedBox(height: 16),
            _buildSection('八、政策变更', '我们可能会不时更新本隐私政策。如有变更，我们将通知您。'),
            const SizedBox(height: 16),
            _buildSection('九、联系我们', '如有隐私相关问题，请通过 privacy@moodstyle.app 联系我们'),
            const SizedBox(height: 32),
            Center(
              child: Text(
                '最后更新：2024年1月',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.security_rounded, color: AppColors.textMain, size: 32),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              '隐私政策',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textMain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A3A34),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
