import 'package:flutter/material.dart';
import '../../theme/theme.dart';

class UserAgreementPage extends StatelessWidget {
  const UserAgreementPage({super.key});

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
          '用户协议',
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
            _buildSection('一、条款接受', '通过访问和使用 MoodStyle，你接受并同意受本协议条款和规定的约束。'),
            const SizedBox(height: 16),
            _buildSection('二、用户账号', '你有责任维护账号的安全以及任何相关活动的安全。'),
            const SizedBox(height: 16),
            _buildSection('三、内容准则', '你同意仅发布尊重他人权利的适当内容。'),
            const SizedBox(height: 16),
            _buildSection('四、知识产权', 'MoodStyle 的所有内容和功能均归我们所有，并受知识产权法律保护。'),
            const SizedBox(height: 16),
            _buildSection('五、隐私', '你对 MoodStyle 的使用也受我们隐私政策的约束。'),
            const SizedBox(height: 16),
            _buildSection('六、修改', '我们保留随时修改本协议的权利。'),
            const SizedBox(height: 16),
            _buildSection('七、终止', '我们可以自行决定终止或暂停你的账号。'),
            const SizedBox(height: 16),
            _buildSection('八、联系方式', '如对本协议有疑问，请通过 legal@moodstyle.app 联系我们'),
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
          Icon(Icons.description_rounded, color: AppColors.textMain, size: 32),
          SizedBox(width: 16),
          Expanded(
            child: const Text(
              '用户协议',
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
